DSClangFormatter

## What 

DSClangFormatter 是一个iOS代码风格检测工具，在git提交代码是会触发检测的脚本，若未通过则禁止提交代码.


## Why

代码风格检测工具利于提高团队代码风格规范的下限~

## How

### Usage
1. clone 本仓库到本地
2. 在Xcode-Build Phases添加一个脚本位，可以放在最上面的位置（基于现在的壳工程以及子pod的结构）
3. 在脚本位插入脚本间接调用本项目中format/shell/xcode_pre_build.sh
参考下图：
4. 将项目跑起来，之后可以在各个子pod中提交代码了

### Implementation

本项目，基于SpaceCommander,做了大量的定制话，最终的检测代码也是通过clang-format插件.


## Other
为了让使用起来更加方便，便于推广，可以将该项目下的format目录直接提交到司机端的壳工程内，然后在Xcode中配置pre-build的脚本，这样使用起来是相对方便的。

## Advanced
各个子pod库也有一定的自定制能力，如下：
1. 代码风格自定制：通过.clang-format 配置，本项目下有.clang-format 如果各个子pod中需要差异化自己的代码风格，可以添加自己.clang-format到各自的目录下
2. formatting-directory: 各个子pod通过改文件配置.formatting-directory 定制需要style check的目录
3. formatting-directory-ignore: 道理同上，配置各自的忽略style check的目录