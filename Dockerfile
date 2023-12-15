FROM ubuntu:22.04

#ref from https://github.com/cirruslabs/docker-images-android
LABEL org.opencontainers.image.source=https://github.com/yangjuncode/flutter-android-go-builder

USER root

ENV ANDROID_HOME=/opt/android-sdk-linux \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

ENV ANDROID_SDK_ROOT=$ANDROID_HOME \
    PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

# comes from https://developer.android.com/studio/#command-tools
ENV ANDROID_SDK_TOOLS_VERSION 9477386

RUN set -o xtrace \
    && cd /opt \
   && sed -i s@/archive.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g /etc/apt/sources.list \
   && apt-get clean \
    && apt-get update \
    && apt-get install -y openjdk-17-jdk \
    && apt-get install -y sudo xz-utils wget gzip zip unzip git openssh-client curl bc software-properties-common build-essential ruby-full ruby-bundler libstdc++6 libpulse0 libglu1-mesa locales lcov libsqlite3-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && sh -c 'echo "en_US.UTF-8 UTF-8" > /etc/locale.gen' \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip -O android-sdk-tools.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools/ \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && chown -R root:root $ANDROID_HOME \
    && rm android-sdk-tools.zip \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && yes | sdkmanager --licenses >> /dev/null \
    && touch /root/.android/repositories.cfg \
    && sdkmanager platform-tools \
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg

# https://developer.android.com/studio/releases/build-tools
ENV ANDROID_PLATFORM_VERSION 33
ENV ANDROID_BUILD_TOOLS_VERSION 33.0.2
RUN yes | sdkmanager \
   "platforms;android-$ANDROID_PLATFORM_VERSION" \
   "build-tools;$ANDROID_BUILD_TOOLS_VERSION"   

# https://developer.android.com/ndk/downloads
ENV ANDROID_NDK_VERSION 23.1.7779620
RUN yes | sdkmanager "ndk;$ANDROID_NDK_VERSION"  "cmake;3.22.1" >> /dev/null
ENV PATH=$PATH:${ANDROID_HOME}/ndk/${ANDROID_NDK_VERSION}/toolchains/llvm/prebuilt/linux-x86_64/bin/

# 安装go环境
ARG go_version=go1.20.12
#https://go.dev/dl/go1.20.12.linux-amd64.tar.gz
RUN wget -O go.tar.gz https://dl.google.com/go/${go_version}.linux-amd64.tar.gz \
    && tar -xzf go.tar.gz -C /usr/local/ \
    && rm -f go.tar.gz
ENV GOPROXY=https://goproxy.cn,direct \
    PATH=$PATH:/usr/local/go/bin

# install flutter
# https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.6-stable.tar.xz
# https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.6-stable.tar.xz
ARG flutter_version=3.16.4
RUN wget  -O /tmp/flutter.tar.xz https://storage.flutter-io.cn/flutter_infra_release/releases/stable/linux/flutter_linux_$flutter_version-stable.tar.xz \
    && tar -xf /tmp/flutter.tar.xz -C /usr/local/  \
    && export PATH=$PATH:/usr/local/flutter/bin:$HOME/.pub-cache/bin \
    && export PUB_HOSTED_URL=https://pub.flutter-io.cn \
    && export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn \
    && git config --global --add safe.directory /usr/local/flutter \
    && flutter config --enable-android   --no-enable-ios  \
    && flutter precache --universal  \
    && (yes | flutter doctor --android-licenses) \
    && flutter --version \
    && rm -rf /var/lib/apt/lists/* /tmp/*
ENV FLUTTER_HOME=/usr/local/flutter \
    PUB_HOSTED_URL=https://pub.flutter-io.cn \
    FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn \
    PATH=$PATH:/usr/local/flutter/bin:$HOME/.pub-cache/bin
