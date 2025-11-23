# Container Image Security Scanning

This project demonstrates container image security scanning using Trivy through a reusable workflow.

## Overview

- Builds a Docker image from `./docker/Dockerfile`
- Scans with Trivy using centralized workflow
- Uses central and project-specific exceptions
- Uploads results to GitHub Security and Artifacts

## Project Structure

```
Create-Test-Container-Image/
├── .github/workflows/trivy-workflow.yml
├── docker/Dockerfile
├── .trivyignore
└── README.md
```

## Usage

Push or create a PR to trigger the scan. The workflow builds `my-trivy-test-app:latest` and scans it.

### Workflow Configuration

```yaml
jobs:
  container-scan:
    uses: marekboodt/Security-Scanning-Repo/.github/workflows/10-container-scan-workflow.yml@main
    with:
      image-name: my-trivy-test-app
      image-tag: latest
      dockerfile-path: ./docker
      exception-profile: ubuntu
      environment: non-prod
```

### Parameters

- `image-name`: Container image name
- `image-tag`: Image tag (e.g., `latest`, `v1.0`)
- `dockerfile-path`: Path to Dockerfile
- `exception-profile`: `ubuntu` | `alpine` # More to come
- `environment`: `non-prod` (continue on error) | `prod` (fail on error)

## Exception Management

### Levels

- **Project**: Add CVEs to `.trivyignore` in this repo
- **Central**: Managed by the Security team in `Security-Scanning-Repo/trivy-exceptions/` - create a PR to have specific ones added

### Format

```
CVE-YYYY-XXXXX  # Reason | Team | YYYY-MM-DD | Review/Expire YYYY-MM-DD
```

### Examples

```
CVE-2024-12345  # Feature disabled in config | Dev Team | 2024-11-23 | Review 2025-05-01
CVE-2023-99999  # express@3 - upgrade Q2 2025 | Dev Team | 2024-11-23 | Expires 2025-06-30
```

### DO NOT ADD:
- OS/kernel issues - make Pull Request into the global/base image exception list. The security Team will review and can add it for everyone. 
- Issues already in global.trivyignore

## Viewing Results

- **Security Tab**: Security â†’ Code scanning alerts
- **Artifacts**: Actions â†’ Run â†’ Artifacts â†’ `trivy-results.sarif`
- **Logs**: Actions â†’ Run logs (table output)

## Troubleshooting

### No alerts or artifacts

Check workflow permissions:

```yaml
permissions:
  actions: read
  contents: read
  security-events: write
```

### CVE not ignored

- Check if CVE is in correct file (`.trivyignore`)
- Verify `exception-profile` is set correctly
- Check "Merged trivyignore file" output in logs
