#!/bin/bash
export GO_VERSION=1.20.12
export FLUTTER_VERSION=3.16.4
docker build --build-arg="go_version=${GO_VERSION}" --build-arg="flutter_version=${FLUTTER_VERSION}" -t ghcr.io/yangjuncode/flutter-builder:${FLUTTER_VERSION} .