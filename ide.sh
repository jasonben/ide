#!/usr/bin/env bash

set -e

source .env

ide () {
  docker_host="tcp://dockersock:2375"
  dockersock_network="dockersock"
  ide_docker_image="${IDE_DOCKER_IMAGE:-jasonben/ide}"
  host_hostname=$(cat /etc/hostname)
  mount_point="${IDE_MOUNT_POINT:-$HOME/.config/ide}"

  mkdir -p "$mount_point/shared"
  mkdir -p "$mount_point/bundle"
  mkdir -p "$mount_point/cache"
  mkdir -p "$mount_point/code"
  mkdir -p "$mount_point/config"
  mkdir -p "$mount_point/local"
  mkdir -p "$mount_point/ssh"
  mkdir -p "$mount_point/tailscale"
  mkdir -p "$mount_point/tmuxinator"

  docker run -it --rm \
    --log-driver=none \
    --privileged \
    --network="$dockersock_network" \
    -e DOCKER_HOST="$docker_host" \
    --cap-add=NET_ADMIN \
    --cap-add=SYS_MODULE \
    -v "$mount_point/shared:/jasonben/ide/shared" \
    -v "$mount_point/bundle:/jasonben/ide/bundle" \
    -v "$mount_point/cache:/jasonben/ide/.cache" \
    -v "$mount_point/code:/jasonben/ide/code" \
    -v "$mount_point/config:/jasonben/ide/.config" \
    -v "$mount_point/local:/jasonben/ide/.local" \
    -v "$mount_point/ssh:/jasonben/ide/.ssh" \
    -v "$mount_point/tailscale:/var/lib" \
    -v "$mount_point/tmuxinator:/jasonben/ide/.tmuxinator" \
    -v "/dev/net/tun:/dev/net/tun" \
    "$ide_docker_image" \
    tmux new-session -A -s "ide on $host_hostname" "$@"
}

docker_socket() {
  echo "starting docker-socket-proxy"
  git clone -q https://github.com/jasonben/docker-sock.git /tmp/docker-sock && \
  pushd /tmp/docker-sock 1>/dev/null 2>/dev/null && \
  docker compose up -d 1>/dev/null 2>/dev/null && \
  popd 1>/dev/null 2>/dev/null
  rm -rf /tmp/docker-sock
}

docker ps --format "table {{.Names}}" | grep -q "^dockersock$" || docker_socket
ide "$@"
