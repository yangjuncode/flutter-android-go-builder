#!/bin/bash

# ============================================
# Flutter Android Go Builder - 版本配置
# 适配 Flutter 3.38.5
# ============================================

# Go 版本 - https://go.dev/dl/
export GO_VERSION=1.25.5

# Flutter 版本 - https://docs.flutter.dev/release/archive
export FLUTTER_VERSION=3.38.5

# Android NDK 版本 - https://developer.android.com/ndk/downloads
export NDK_VERSION=28.2.13676358

# Android SDK Command-line Tools 版本
# https://developer.android.com/studio#command-line-tools-only
export SDK_TOOLS_VERSION=13114758

# Android Platform 版本 (compileSdkVersion)
export PLATFORM_VERSION=35

# Android Build Tools 版本
# https://developer.android.com/studio/releases/build-tools
export BUILD_TOOLS_VERSION=35.0.0

# CMake 版本 - https://developer.android.com/studio/projects/install-ndk#default-ndk-per-agp
export CMAKE_VERSION=3.22.1

# 是否在国内构建 (0: 国外, 1: 国内)
export BUILD_IN_CN=0

# ============================================
# Docker 构建
# ============================================

IMAGE_TAG="ghcr.io/yangjuncode/flutter-builder:${FLUTTER_VERSION}"

docker build \
    --build-arg="go_version=${GO_VERSION}" \
    --build-arg="flutter_version=${FLUTTER_VERSION}" \
    --build-arg="ndk_version=${NDK_VERSION}" \
    --build-arg="sdk_tools_version=${SDK_TOOLS_VERSION}" \
    --build-arg="platform_version=${PLATFORM_VERSION}" \
    --build-arg="build_tools_version=${BUILD_TOOLS_VERSION}" \
    --build-arg="cmake_version=${CMAKE_VERSION}" \
    --build-arg="build_in_cn=${BUILD_IN_CN}" \
    -t "${IMAGE_TAG}" .

#if has param -p, push to docker registry
if [[ $1 == "-p" ]]; then
    docker push "${IMAGE_TAG}"

    if [[ "${BUILD_IN_CN}" == "0" ]]; then
        read -r -p "Push completed. Do you want to remove the local image ${IMAGE_TAG}? [Y/n] " delete_image
        delete_image=${delete_image:-Y}
        if [[ "${delete_image}" =~ ^[Yy]$ ]]; then
            docker rmi "${IMAGE_TAG}"

            disk_used_pct=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')
            if [[ -n "${disk_used_pct}" ]] && (( disk_used_pct > 50 )); then
                read -r -p "Disk usage is ${disk_used_pct}%. Do you want to clean Docker build cache? [Y/n] " clean_build_cache
                clean_build_cache=${clean_build_cache:-Y}
                if [[ "${clean_build_cache}" =~ ^[Yy]$ ]]; then
                    docker builder prune -af
                fi
            fi
        fi
    fi
fi