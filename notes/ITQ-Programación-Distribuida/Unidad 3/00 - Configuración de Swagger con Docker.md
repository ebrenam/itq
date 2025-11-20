# Configuración de Swagger con Docker

## Descarga de imagen

- Existe una imagen docker publicada en `docker.swagger.io`.

- Descargar imagen del registry.

```bash
docker pull docker.swagger.io/swaggerapi/swagger-editor
```

- Ejemplo:

```bash
$ docker pull docker.swagger.io/swaggerapi/swagger-editor
# Output
Using default tag: latest
latest: Pulling from swaggerapi/swagger-editor
9824c27679d3: Pull complete
a5585638209e: Pull complete
fd372c3c84a2: Pull complete
958a74d6a238: Pull complete
c1d2dc189e38: Pull complete
828fa206d77b: Pull complete
bdaad27fd04a: Pull complete
f23865b38cc6: Pull complete
ef4d5251eb61: Pull complete
9e036e8e7462: Pull complete
3e181d4fa6fc: Pull complete
ed2744884d9b: Pull complete
dfc211c0bf81: Pull complete
ffe2a7448444: Pull complete
48f52e5eee45: Pull complete
Digest: sha256:ead7bba6d1ac1aa1ef854efeadda4812684be3ba98d84bed54fdb81dfb088901
Status: Downloaded newer image for docker.swagger.io/swaggerapi/swagger-editor:latest
docker.swagger.io/swaggerapi/swagger-editor:latest

What's next:
    View a summary of image vulnerabilities and recommendations → docker scout quickview docker.swagger.io/swaggerapi/swagger-editor
```

## Ejecución de contenedor

- Ejecutar Swagger utilizando contenedor en Docker.

```bash
docker run -d -p 80:8080 docker.swagger.io/swaggerapi/swagger-editor
```

- Ejemplo: Se ejecuta sin bandera `-d` y con un `--name` para el contenedor.

```bash
$ docker run --name swaggger -d -p 80:8080 docker.swagger.io/swaggerapi/swagger-editor
# Output
WARNING: The requested image's platform (linux/amd64) does not match the detected host platform (linux/arm64/v8) and no specific platform was requested
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
20-envsubst-on-templates.sh: Running envsubst on /etc/nginx/templates/default.conf.template to /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/91-docker-run.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/10/19 17:18:42 [notice] 1#1: using the "epoll" event method
2025/10/19 17:18:42 [notice] 1#1: nginx/1.29.0
2025/10/19 17:18:42 [notice] 1#1: built by gcc 14.2.0 (Alpine 14.2.0)
2025/10/19 17:18:42 [notice] 1#1: OS: Linux 6.10.14-linuxkit
2025/10/19 17:18:42 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2025/10/19 17:18:42 [notice] 1#1: start worker processes
2025/10/19 17:18:42 [notice] 1#1: start worker process 37
2025/10/19 17:18:42 [notice] 1#1: start worker process 38
2025/10/19 17:18:42 [notice] 1#1: start worker process 39
2025/10/19 17:18:42 [notice] 1#1: start worker process 40
2025/10/19 17:18:42 [notice] 1#1: start worker process 41
2025/10/19 17:18:42 [notice] 1#1: start worker process 42
2025/10/19 17:18:42 [notice] 1#1: start worker process 43
2025/10/19 17:18:42 [notice] 1#1: start worker process 44
```

- Acceder a URL del servicio.

```bash
http://localhost/
```

- Detener servicio.

```bash
docker container stop swaggger
```

- Eliminar servicio.

```bash
docker container rm swaggger
```
