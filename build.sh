#!/bin/bash

# ============================================
# Flutter Android Go Builder - 版本配置
# 适配 Flutter 3.32.8
# ============================================

# Go 版本 - https://go.dev/dl/
export GO_VERSION=1.24.10

# Flutter 版本 - https://docs.flutter.dev/release/archive
export FLUTTER_VERSION=3.32.8

# Android NDK 版本 - https://developer.android.com/ndk/downloads
export NDK_VERSION=27.3.13750724

# Android SDK Command-line Tools 版本
# https://developer.android.com/studio#command-line-tools-only
export SDK_TOOLS_VERSION=13114758

# Android Platform 版本 (compileSdkVersion)
export PLATFORM_VERSION=34

# Android Build Tools 版本
# https://developer.android.com/studio/releases/build-tools
export BUILD_TOOLS_VERSION=34.0.0

# CMake 版本 - https://developer.android.com/studio/projects/install-ndk#default-ndk-per-agp
export CMAKE_VERSION=3.22.1

# ============================================
# Docker 构建
# ============================================
docker build \
    --build-arg="go_version=${GO_VERSION}" \
    --build-arg="flutter_version=${FLUTTER_VERSION}" \
    --build-arg="ndk_version=${NDK_VERSION}" \
    --build-arg="sdk_tools_version=${SDK_TOOLS_VERSION}" \
    --build-arg="platform_version=${PLATFORM_VERSION}" \
    --build-arg="build_tools_version=${BUILD_TOOLS_VERSION}" \
    --build-arg="cmake_version=${CMAKE_VERSION}" \
    -t ghcr.io/yangjuncode/flutter-builder:${FLUTTER_VERSION} .