# Lab 4 — Docker and CI/CD

## Application

A small Flask application used to demonstrate Docker image construction, container execution, health checks, and automated testing.

### Endpoints

- `GET /` — Returns the application name and version.
- `GET /healthz` — Returns the application health status and version as JSON.

The application reads its version from the `APP_VERSION` environment variable and defaults to `dev`.

## Docker Images

Two Dockerfiles are provided for comparison:

- `Dockerfile.naive` — Baseline image.
- `Dockerfile` — Optimized image using pinned dependencies, a separate dependency-installation layer, and a non-root application user.

### Local image-size comparison

| Image | Displayed size |
|---|---:|
| Naive | 138 MB |
| Optimized | 130 MB |
| Approximate reduction | 8 MB (5.8%) |

These sizes are the values reported by the local Docker image listing; they may be rounded.

The optimized container was also checked to confirm that the application runs as `appuser`.

## Testing

Run the tests from the repository root:

```bash
pytest lab4/
```

Latest local result: **3 passed**.

The tests cover the root endpoint, the health endpoint, and a nonexistent route returning HTTP 404.

## GitHub Actions

The CI workflow is defined in `.github/workflows/lab4-ci.yml`.

It includes:

- Python tests using a matrix of Python 3.11 and 3.12.
- A reusable Docker build workflow.
- A container smoke test against `/healthz`.
- A final pipeline summary.

The Python dependency installation is implemented as a composite action in `.github/actions/python-deps/action.yml`.

## Evidence

Screenshots and CI timing measurements will be added to `evidence/` after the corresponding workflow runs have completed.
