FROM ubuntu:cosmic
LABEL author="james@pickett.me"

ENV GODOT_VERSION "3.1.2"
ENV GODOT_BUILD="Godot_v${GODOT_VERSION}-stable_linux_headless.64"
ENV SDK_TOOLS_VERSION "4333796"

# install basic packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    ca-certificates \
    git \
    python \
    python-openssl \
    unzip \
    wget \
    zip \
    && rm -rf /var/lib/apt/lists/*

# add openjdk repo
RUN add-apt-repository ppa:openjdk-r/ppa

# install openjdk
RUN apt-get update \
    && apt-get install openjdk-8-jdk -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# download and unzip android-sdk-linux
RUN export ANDROID_HOME=/opt/android-sdk-linux \
    && mkdir -p $ANDROID_HOME \
    && cd $ANDROID_HOME \
    && wget https://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS_VERSION}.zip \
    && unzip sdk-tools-linux-${SDK_TOOLS_VERSION}.zip \
    && rm -f sdk-tools-linux-${SDK_TOOLS_VERSION}.zip

# install android sdk platform tools
RUN cd /opt/android-sdk-linux/tools/bin \
    && yes | ./sdkmanager platform-tools \
    && ./sdkmanager --update

# download and unzip godot templates
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mkdir /root/.cache \
    && mkdir -p /root/.config/godot \
    && mkdir -p /root/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && unzip Godot_v${GODOT_VERSION}-stable_export_templates.tpz \
    && mv templates/* /root/.local/share/godot/templates/${GODOT_VERSION}.stable \
    && rm -f Godot_v${GODOT_VERSION}-stable_export_templates.tpz

# download unzip godot
RUN wget https://downloads.tuxfamily.org/godotengine/${GODOT_VERSION}/${GODOT_BUILD}.zip \
    && unzip ${GODOT_BUILD}.zip \
    && mv ${GODOT_BUILD} /usr/local/bin/godot \
    && rm -f ${GODOT_BUILD}.zip