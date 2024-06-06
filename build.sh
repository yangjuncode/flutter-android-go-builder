#!/bin/bash
export GO_VERSION=1.21.11
export FLUTTER_VERSION=3.19.6
docker build --build-arg="go_version=${GO_VERSION}" --build-arg="flutter_version=${FLUTTER_VERSION}" -t ghcr.io/yangjuncode/flutter-builder:${FLUTTER_VERSION} .