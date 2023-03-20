# Statically linked XZ Utils

Statically linked [XZ Utils][XZ] container image with [Bash]

> ~ 1,6M (1,1M bash)

```bash
ghcr.io/awesome-containers/static-xz:latest
ghcr.io/awesome-containers/static-xz:5.4.2

docker.io/awesomecontainers/static-xz:latest
docker.io/awesomecontainers/static-xz:5.4.2
```

Slim statically linked [XZ Utils][XZ] container image with [Bash] and
packaged with [UPX]

> ~ 865K (578K bash)

```bash
ghcr.io/awesome-containers/static-xz:latest-slim
ghcr.io/awesome-containers/static-xz:5.4.2-slim

docker.io/awesomecontainers/static-xz:latest-slim
docker.io/awesomecontainers/static-xz:5.4.2-slim
```

[XZ]: https://tukaani.org/xz/
[Bash]: https://github.com/awesome-containers/static-bash
[UPX]: https://upx.github.io/

<!--
```bash
image="localhost/${PWD##*/}"

podman build -t "$image:latest" .
podman build -t "$image:latest-slim" -f Containerfile-slim \
  --build-arg STATIC_XZ_IMAGE="$image" \
  --build-arg STATIC_XZ_VERSION=latest --no-cache .

echo "$image:latest"
podman inspect "$image:latest" | jq '.[].Size' | numfmt --to=iec
echo "$image:latest-slim"
podman inspect "$image:latest-slim" | jq '.[].Size' | numfmt --to=iec

```
-->
