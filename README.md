# T. 已测试目录

| 主机类型 | 主机版本    | Docker镜像版本 | 结果 |
| -------- | ----------- | -------------- | ---- |
| WSL2     | Ubuntu22.04 | Ubuntu20.04    | PASS |
| WSL2     | Ubuntu22.04 | Ubuntu18.04    | PASS |

# R. 软硬件要求：

- 硬件：

| 设备 | 容量  | 备注                                   |
| ---- | ----- | -------------------------------------- |
| 硬盘 | >500G | 多版本系统测试，必须固态，否则编译卡死 |
| 硬盘 | >300G | 单系统开发，必须固态，否则编译卡死     |
| 内存 | >25G  | 物理机                                 |
| 内存 | >32G  | WSL2                                   |

- 软件：

​	安装好Docker的Linux发行版。

> 如果你使用的是WSL2，请不要将源码存放在NTFS文件系统的目录中！！
>
> 应该把WSL2进行迁移之后，下载源码到Linux的EXT4文件系统的目录下！用户目录之类的都可以！
>
> WSL2迁移可以参考：[[WSL][教程]WSL2系统迁移到其他盘以及其他电脑教程](https://blog.csdn.net/qq_38844263/article/details/143913755)

# 0. 制作过程

如果你想知道这个镜像是如何制作的，请看下面的教程，如果你只想拿到镜像。那就往下看就好了

链接：[[OpenHarmony5.0][Docker][教程]OpenHarmony5.0编译环境基于WSL2封装Docker镜像教程](https://blog.csdn.net/qq_38844263/article/details/144020040)

# 1. 获取源码

> 源码下载请参考：[OHOS_5.0](https://gitee.com/openharmony/docs/blob/master/zh-cn/release-notes/OpenHarmony-v5.0.0-release.md#https://gitee.com/link?target=https%3A%2F%2Frepo.huaweicloud.com%2Fopenharmony%2Fos%2F5.0.0-Release%2Fcode-v5.0.0-Release.tar.gz)中的[源码下载]章节，建议使用镜像站点下载。

![image-20241123223700213](https://taxue-alfred-1253400076.cos.ap-beijing.myqcloud.com/image-20241123223700213.png)

# 2. 获取镜像

获取镜像有两种方式：

1. Docker Hub及其镜像站获取。（本篇）

   不需要源码的话直接往下面看就可以了。下面是构建源码的链接：

   Gitee Dockerfile源码：[openharmony_5.x_docker_env](https://gitee.com/taxue-vernon/openharmony_5.x_docker_env) **Issue和PR请在Gitee上提交~**

   Github Dockerfile源码：[openharmony_5.x_docker_env](https://github.com/taxue-vernon/openharmony_5.x_docker_env)

   **如果有用，辛苦麻烦给个Star喽~**

2. 下载我封装好的压缩包，跳转链接之后下面的不用看了，直接看链接里面的即可。

   链接：[[OpenHarmony5.0][Docker][环境]OpenHarmony5.0 Docker编译环境镜像下载以及使用方式](https://blog.csdn.net/qq_38844263/article/details/144021999)

# 3. 拉取镜像

> Docker的安装请参照其他教程，较为简单，这里不再赘述

```bash
sudo docker pull taxuevernon/openharmony_5.x_docker_env:5.0
```

如果你的网络环境拉取不下来，**请自己找国内镜像源替代。**具体如何替代自行查阅。

看一下镜像

![image-20241127154701330](https://taxue-alfred-1253400076.cos.ap-beijing.myqcloud.com/image-20241127154701330.png)

# 4. 运行容器

启动的时候要顺便把源码通过Volume映射到Ubuntu里面

> 下面的`-v`内容一定要特别注意！！！
>
> 你的映射必须要到源码的上一级目录，把源码再加一层文件夹，也就是说你要映射为如下结构！！！
>
> ```bash
> OHOS_5/（应该映射的是这一层，也就是`-v`参数后面写的东西，映射到Docker里也应该是这个层级）
> 	├── OHS_5 （源码真正存放的目录）
> 	├── openharmony_prebuilts （如果你是repo同步源码，这个东西后面才会有）
> ```

```bash
sudo docker run --name ohos_5_v0.1 -ti -v /home/taxue/OpenHarmony-v5.0.0-Release:/home/taxue/ -p 10022:22 ohos:5.0 /bin/bash
```

# 5. 安装hb构建工具

先进入源码目录：

```bash
cd /home/taxue/OpenHarmony
```

再安装：

```bash
python3 -m pip install --user build/hb
```

> PATH我已经提前写好，不用更新。

# 6. 准备编译

先进入源码根目录 

```bash
cd /home/taxue/OpenHarmony
```

## 6.1 clean

执行一次clean

```bash
hb clean
```

## 6.2 预编译工具

需要为你的下载的源码重新过一下编译工具

```bash
bash build/prebuilts_download.sh
```

一般npm每次都要重新安装的

![image-20241125105034140](https://taxue-alfred-1253400076.cos.ap-beijing.myqcloud.com/image-20241125105034140.png)

## 6.3 拉取最新源码（选做）

如果你在获取源码的时候就是使用的repo，那么你可以跳过本节。**一般来说不需要执行**

拉取最新代码

```bash
repo sync -c
```

## 6.4 开始编译

> 参考链接：[编译](https://docs.openharmony.cn/pages/v5.0/zh-cn/device-dev/quick-start/quickstart-pkg-3568-build.md)

### 6.4.1 脚本方式编译（推荐）

> 推荐的理由是我这个编译通了，而另一个没有

```bash
bash ./build.sh --product rk3568
```

### 6.4.2 hb方式编译

源码根目录执行

![image-20241121182100335](https://taxue-alfred-1253400076.cos.ap-beijing.myqcloud.com/image-20241121182100335.png)

```bash
hb set
```

按照你自己的板子进行选择

![image-20241121182126875](https://taxue-alfred-1253400076.cos.ap-beijing.myqcloud.com/image-20241121182126875.png)

之后就可以进行编译了

```bash
hb build -f # 全量编译
hb build # 增量编译
```

## 6.5 编译结果

![image-20241124185116358](https://taxue-alfred-1253400076.cos.ap-beijing.myqcloud.com/image-20241124185116358.png)

# F. 参考

[[OpenHarmony5.0][Docker][教程]OpenHarmony5.0编译环境基于WSL2封装Docker镜像教程](https://blog.csdn.net/qq_38844263/article/details/144020040)
