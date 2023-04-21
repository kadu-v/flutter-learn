FROM ubuntu:20.04

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN  apt update \
    && apt install -y sudo \
    && apt install -y openjdk-11-jdk-headless --no-install-recommends \
    && apt install -y wget curl git xz-utils zip unzip --no-install-recommends 

# Clean Up
RUN	apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* 

RUN	groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && su $USERNAME \
    && cd $HOME


ENV DEBIAN_FRONTEND="noninteractive"
ENV JAVA_VERSION="11"
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip"
ENV ANDROID_VERSION="29"
ENV ANDROID_BUILD_TOOLS_VERSION="29.0.3"
ENV ANDROID_ARCHITECTURE="x86_64"
ENV ANDROID_SDK_ROOT="/usr/local/android-sdk"
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="3.0.2"
ENV GRADLE_VERSION="7.2"
ENV GRADLE_USER_HOME="/opt/gradle"
ENV GRADLE_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip"
ENV FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/$FLUTTER_CHANNEL/linux/flutter_linux_$FLUTTER_VERSION-$FLUTTER_CHANNEL.tar.xz"
ENV FLUTTER_ROOT="/opt/flutter"
ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/platforms:$FLUTTER_ROOT/bin:$GRADLE_USER_HOME/bin:$PATH"

# Install the necessary dependencies.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
    openjdk-$JAVA_VERSION-jdk \
    curl \
    wget \
    unzip \
    sed \
    git \
    bash \
    xz-utils \
    libglvnd0 \
    ssh \
    xauth \
    x11-xserver-utils \
    libpulse0 \
    libxcomposite1 \
    libgl1-mesa-glx \
    && rm -rf /var/lib/{apt,dpkg,cache,log}


# Install Gradle.
RUN curl -L $GRADLE_URL -o gradle-$GRADLE_VERSION-bin.zip \
    && apt-get install -y unzip \
    && unzip gradle-$GRADLE_VERSION-bin.zip \
    && mv gradle-$GRADLE_VERSION $GRADLE_USER_HOME \
    && rm gradle-$GRADLE_VERSION-bin.zip

# Install the Android SDK.
RUN mkdir /root/.android \
    && touch /root/.android/repositories.cfg \
    && mkdir -p $ANDROID_SDK_ROOT \
    && curl -o android_tools.zip $ANDROID_TOOLS_URL \
    && unzip -qq -d "$ANDROID_SDK_ROOT" android_tools.zip \
    && rm android_tools.zip \
    && mv $ANDROID_SDK_ROOT/cmdline-tools $ANDROID_SDK_ROOT/latest \
    && mkdir -p $ANDROID_SDK_ROOT/cmdline-tools \
    && mv $ANDROID_SDK_ROOT/latest $ANDROID_SDK_ROOT/cmdline-tools/latest \
    && yes "y" | sdkmanager "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
    && yes "y" | sdkmanager "platforms;android-$ANDROID_VERSION" \
    && yes "y" | sdkmanager "platform-tools"

# Install Chrome
RUN apt-get update && apt-get install -y \
    gnupg2 \
    && sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
    && install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list \
    && apt-get update && apt-get install -y \
    code \
    google-chrome-stable \
    && apt-get clean \
    && rm microsoft.gpg \
    && rm -rf /var/lib/apt/lists/*


# Install linux toolchain
RUN apt-get update \
    && apt-get install -y clang cmake ninja-build libgtk-3-dev

# Install Flutter.
RUN curl -o flutter.tar.xz $FLUTTER_URL \
    && mkdir -p $FLUTTER_ROOT \
    && tar xf flutter.tar.xz -C /opt/ \
    && rm flutter.tar.xz \
    && git config --global --add safe.directory /opt/flutter \
    && flutter config --no-analytics \
    && flutter precache \
    && yes "y" | flutter doctor --android-licenses \
    && flutter doctor \
    && flutter update-packages



