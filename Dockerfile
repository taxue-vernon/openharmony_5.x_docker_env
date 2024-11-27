FROM ubuntu:20.04
WORKDIR /home/taxue
ENV TZ=Asia/Chongqing

RUN  apt update -y \
	&& sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \ 
	&& apt install ca-certificates -y \
        && apt update -y \
	&& apt upgrade -y \
	&& apt install dialog -y \
	&& DEBIAN_FRONTEND="noninteractive" apt -y install tzdata \
	&& apt install gcc g++ -y \
	&& apt install git git-lfs curl -y \
	&& git config --global user.name "taxue" \
	&& git config --global user.email "taxue_tianxing@outlook.com" \
	&& git config --global credential.helper store \
	&& curl -s https://gitee.com/oschina/repo/raw/fork_flow/repo-py3 > /root/repo \
	&& sed -i '$a \export PATH=/root:$PATH' /root/.bashrc \
	&& chmod a+x /root/repo \
	&& apt install -y apt-utils binutils bison flex bc build-essential make mtd-utils u-boot-tools python3.9 python3-pip git zip unzip curl wget gcc g++ ruby dosfstools mtools default-jre default-jdk scons python3-distutils perl openssl libssl-dev cpio git-lfs m4 ccache zlib1g-dev tar rsync liblz4-tool genext2fs binutils-dev device-tree-compiler e2fsprogs git-core gnupg gnutls-bin gperf lib32ncurses5-dev libffi-dev zlib* libelf-dev libx11-dev libgl1-mesa-dev lib32z1-dev xsltproc x11proto-core-dev libc6-dev-i386 libxml2-dev lib32z-dev libdwarf-dev \
	&& apt install -y grsync xxd libglib2.0-dev libpixman-1-dev kmod jfsutils reiserfsprogs xfsprogs squashfs-tools  pcmciautils quota ppp libtinfo-dev libtinfo5 libncurses5 libncurses5-dev libncursesw5 libstdc++6  gcc-arm-none-eabi vim ssh locales doxygen \
	&& apt install -y libxinerama-dev libxcursor-dev libxrandr-dev libxi-dev \
	&& update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
	&& update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
	&& pip3 install --trusted-host https://repo.huaweicloud.com -i https://repo.huaweicloud.com/repository/pypi/simple requests setuptools pymongo kconfiglib pycryptodome ecdsa  pyyaml prompt_toolkit==1.0.14 redis json2html yagmail python-jenkins json5 requests \
	&& pip3 install esdk-obs-python --trusted-host pypi.org \
	&& pip3 install six --upgrade --ignore-installed six \
	&& sed -i '$a \export PATH=/root/.local/bin:$PATH' /root/.bashrc \
	&& apt install -y curl wget unzip tar \
	&& mkdir -p /home/tools \
	&& mkdir -p /home/tools/gn \
	&& wget -P /home/tools https://repo.huaweicloud.com/harmonyos/compiler/hc-gen/0.65/linux/hc-gen-0.65-linux.tar \
	&& wget -P /home/tools https://repo.huaweicloud.com/harmonyos/compiler/gcc_riscv32/7.3.0/linux/gcc_riscv32-linux-7.3.0.tar.gz \
	&& wget -P /home/tools https://repo.huaweicloud.com/harmonyos/compiler/ninja/1.9.0/linux/ninja.1.9.0.tar \
	&& wget -P /home/tools https://repo.huaweicloud.com/harmonyos/compiler/gn/1717/linux/gn-linux-x86-1717.tar.gz \
	&& wget -P /home/tools https://mirrors.huaweicloud.com/nodejs/v14.15.4/node-v14.15.4-linux-x64.tar.xz \
	&& wget -P /home/tools https://hm-verify.obs.cn-north-4.myhuaweicloud.com/qemu-5.2.0.tar.xz \
	&& tar -xvf /home/tools/hc-gen-0.65-linux.tar -C /home/tools \
	&& tar -xvf /home/tools/gcc_riscv32-linux-7.3.0.tar.gz -C /home/tools \
	&& tar -xvf /home/tools/ninja.1.9.0.tar -C /home/tools \
	&& tar -xvf /home/tools/gn-linux-x86-1717.tar.gz -C /home/tools/gn \
	&& tar -xJf /home/tools/node-v14.15.4-linux-x64.tar.xz -C /home/tools \
	&& cp /home/tools/node-v14.15.4-linux-x64/bin/node /usr/local/bin \
	&& ln -s /home/tools/node-v14.15.4-linux-x64/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
	&& ln -s /home/tools/node-v14.15.4-linux-x64/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
	&& tar -xJf /home/tools/qemu-5.2.0.tar.xz -C /home/tools \
	&& sed -i '$aexport PATH=/home/tools/hc-gen:$PATH' /root/.bashrc \
	&& sed -i '$aexport PATH=/home/tools/gcc_riscv32/bin:$PATH' /root/.bashrc \
	&& sed -i '$aexport PATH=/home/tools/ninja:$PATH' /root/.bashrc \
	&& sed -i '$aexport PATH=/home/tools/node-v14.15.4-linux-x64/bin:$PATH' /root/.bashrc \
	&& sed -i '$aexport PATH=/home/tools/gn:$PATH' /root/.bashrc \
        && export PATH=/home/tools/hc-gen:$PATH \
        && export PATH=/home/tools/gcc_riscv32/bin:$PATH \
        && export PATH=/home/tools/ninja:$PATH \
        && export PATH=/home/tools/node-v12.20.0-linux-x64/bin:$PATH \
        && export PATH=/home/tools/gn:$PATH \
        && export PATH=/root/.local/bin:$PATH \
	&& cd /home/tools/qemu-5.2.0 \
        && mkdir build \
        && cd build \
        && ../configure --target-list=arm-softmmu \
        && make -j \
        && make install \
        && cd /home/taxue \
        && rm -rf /home/tools/*.tar \
        && rm -rf /home/tools/*.gz \
        && rm -rf /home/tools/*.xz \
        && rm -rf /home/tools/qemu-5.2.0 \
