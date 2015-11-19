rocks_trees = { { root = "./bundle", bin_dir = "./bundle/bin", lib_dir = "./bundle/lib/lua", lua_dir = "./bundle/share/lua" } }
variables = { CFLAGS = "{{CFLAGS}} -I./skynet/3rd/lua -I/usr/local/include", LIBFLAG = "{{LIBFLAG}} -L./skynet/3rd/lua -L/usr/local/lib", LUA = "./skynet/3rd/lua/lua", LUA_BINDIR = "./skynet/3rd/lua" }
