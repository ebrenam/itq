- Ejemplo de revisión de vulnerabilidades.

```bash
$ docker scout quickview docker.swagger.io/swaggerapi/swagger-editor
# Output
    i New version 1.18.4 available (installed version is 1.17.1) at https://github.com/docker/scout-cli
    ✓ Image stored for indexing
    ✓ Indexed 86 packages

    i Base image was auto-detected. To get more accurate results, build images with max-mode provenance attestations.
      Review docs.docker.com ↗ for more information.

  Target               │  docker.swagger.io/swaggerapi/swagger-editor:latest  │    2C     5H     5M     4L
    digest             │  d281a60c3770                                        │
  Base image           │  nginx:1-alpine                                      │    2C     5H     5M     4L
  Refreshed base image │  nginx:1-alpine                                      │    0C     0H     1M     2L
                       │                                                      │    -2     -5     -4     -2
  Updated base image   │  nginx:1-alpine-slim                                 │    0C     0H     1M     2L
                       │                                                      │    -2     -5     -4     -2

What's next:
    View vulnerabilities → docker scout cves docker.swagger.io/swaggerapi/swagger-editor
    View base image update recommendations → docker scout recommendations docker.swagger.io/swaggerapi/swagger-editor
    Include policy results in your quickview by supplying an organization → docker scout quickview docker.swagger.io/swaggerapi/swagger-editor --org <organization>
```
