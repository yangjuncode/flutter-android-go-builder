#!/bin/bash
export GO_VERSION=1.21.13
export FLUTTER_VERSION=3.24.3
docker build --build-arg="go_version=${GO_VERSION}" --build-arg="flutter_version=${FLUTTER_VERSION}" -t ghcr.io/yangjuncode/flutter-builder:${FLUTTER_VERSION} .