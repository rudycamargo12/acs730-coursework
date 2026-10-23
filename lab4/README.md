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

Screenshots and CI timing measurements are recorded in `evidence/`. The evidence includes image-size comparisons, the CI workflow graph, the published GHCR package, and a JSON record of the required-check failure demonstration.


## Cache timing experiments

Times were measured in GitHub Actions. The baseline ran without caching,
the cache-miss run enabled caching for the first time, and the cache-hit
run repeated the workflow with caching enabled.

| Experiment | Baseline (no cache) | Cache miss | Cache hit |
|---|---:|---:|---:|
| Python dependency installation | 2,067 ms | 2,353 ms | 1,150 ms |
| Docker image build | 8,087 ms | 8,425 ms | 8,147 ms |

### Cache decision

The pip cache is worthwhile for this experiment: the cache-hit installation
took about 51% less time than the first cache-enabled run and about 44%
less than the baseline.

The Docker layer cache did not show a meaningful improvement in these
measurements. The cache-hit build took 8,147 ms, close to the 8,087 ms
baseline. Build time can vary between hosted runners, so more repeated runs
would be needed to establish a reliable performance difference.

Caching should be retained where it reduces repeated dependency downloads,
but its value should be evaluated against actual workflow timings.

## Image tagging

CI builds use `sha-<commit-sha>` tags, for example `sha-abc123...`.
A commit-SHA tag identifies the exact source revision used to build an image,
making it easier to trace, reproduce, and roll back a deployment. It avoids
relying only on a mutable tag such as `latest`.

## GitHub Actions versus AWS-native CI/CD

GitHub Actions is a practical choice for this repository because the source
code and pull requests are hosted on GitHub, and CI results appear directly
alongside code changes. GitHub-hosted runners also avoid needing AWS
credentials for ordinary unit tests and image builds.

AWS-native services such as CodePipeline and CodeBuild may be a better fit
when a team needs deeper integration with AWS deployment environments,
centralized AWS permissions, or an AWS-managed delivery pipeline. The choice
depends on the existing team workflow, security requirements, and deployment
architecture.

## Evidence

The `evidence/` directory should contain the requested screenshots:

- `image-sizes.png` — comparison of the naive and optimized Docker images.
- `ci-graph.png` — successful CI workflow graph.
- `ghcr-package.png` — published GitHub Container Registry package.
- `required-check.png` — required status check demonstrated on a pull request.
