#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="${PVMA_BOOTSTRAP_REPO_URL:-https://github.com/caonima715/123321.git}"
BRANCH="${PVMA_BOOTSTRAP_BRANCH:-main}"
INSTALL_DIR="${PVMA_INSTALL_DIR:-/opt/private-vps-installer}"

if [[ ${EUID:-$(id -u)} -ne 0 ]]; then
  echo '请使用 root 运行此脚本。' >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y git ca-certificates curl
  else
    echo '当前仅支持 Debian / Ubuntu 自动安装 git。' >&2
    exit 1
  fi
fi

rm -rf "$INSTALL_DIR"
git clone --depth=1 -b "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
chmod 700 "$INSTALL_DIR/install.sh"
exec bash "$INSTALL_DIR/install.sh"
