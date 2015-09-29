# Luabundle

## 用法

Luabundle 是简单的 shell 脚本方便安装 skynet 和 luarocks 的模块。

首先 clone 本仓库

    git clone git@github.com:3pjgames/luabundle.git

把本仓库的 bin 目录加到 PATH 里，或者建立符号链接

    cd luabundle
    ln -snf "$(pwd)/bin/luabundle" /usr/local/bin/luabundle

然后在自己的项目顶层创建 Luafile

``` shell
skynet HEAD
rock inspect
rock moonscript
```

主要有三个命令

-   `skynet` 安装 skynet 到 `skynet` 目录下。参数用来指定 git 的分支或者标签。也可以传两个参数用来分别指定仓库地址和分支或标签名，比如 `skynet git@github.com:cloudwu/skynet.git HEAD`
-   `rock` 就是调用 `luarocks` 安装 lua 模块。不过所有的 rocks 会安装到 `bundle` 目录下
-   `rock_dev` 和 `rock` 一样，只是在运行 `luabundle prod` 的时候不会安装，可以用来安装开发和测试才需要的模块

执行 `luabundle` 就会安装 Luafile 中指定的 skynet 和 rocks。并且如果 Luafile 中有安装 skynet，所有的 luarock 模块有 C 代码需要编译的时候也会使用 skynet 内的 lua。

要使用安装的 rocks，可以执行 `luabundle path` 导出 shell 需要的环境变量，也可以直接应用到当前的会话当中：

    eval `luabundle path`

## 提交 rockspec

如果 `rock` 后面的参数不包含 `/` 并且以 `.rockspec` 结尾，会优先在本仓库中找对应的 `.rockspec` 文件，对于不方便上传到 luarocks 服务器上的 lua 库，可以将 `.rockspec` 提交到本仓库中。

## Skynet 编译出错

可以尝试在 skynet 目录里执行 `make cleanall` 再回到上层目录执行 `luabundle`

## Skynet 集成

Skynet 中注意配置文件中的路径，skynet 本身是安装在 skynet 子目录下的。Luarock 的包在 bundle 子目录下，需要在启动的 config 文件中指定 `lua_path` 和 `lua_cpath`，例如下面配置。

这个配置也是推荐的做法，不往 skynet 内提交文件，自己的代码都在 src 子目录下。

``` lua
-- vim: ft=lua:
-- luacheck: no global

skynet = "./skynet/"
src = "./src/"

thread = 8
harbor = 0
start = "main"
bootstrap = "snlua bootstrap"
luaservice = skynet.."service/?.lua;"..src.."service/?.lua"
lualoader = skynet.."lualib/loader.lua"
-- preload = "./src/preload.lua"
snax = src.."snax/?.lua"
-- snax_interface_g = "snax_g"
cpath = skynet.."cservice/?.so"

lua_path = src.."lualib/?.lua;"..skynet.."lualib/?.lua;./bundle/share/lua/?.lua;./bundle/share/lua/?/init.lua"
lua_cpath = skynet.."luaclib/?.so;./bundle/lib/lua/?.so"
```

另外推荐将这些文件排除在代码仓库外，使用 git 就是添加到 .gitignore 中

```
/bundle
/skynet
/.luabundle.lua
```
