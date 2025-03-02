ROCKS_TREE := $(PWD)/.luarocks
export ROCKS_TREE

LUA := $(ROCKS_TREE)/bin/nlua
LUA_BIN := $(ROCKS_TREE)/bin
LUA_CPATH := $(ROCKS_TREE)/lib/lua/5.1/?.so
LUA_PATH := lua/?.lua;lua/?/init.lua;$(ROCKS_TREE)/share/lua/5.1/?.lua;$(ROCKS_TREE)/share/lua/5.1/?/init.lua
export LUA LUA_BIN LUA_CPATH LUA_PATH

XDG_STATE_HOME := $(PWD)
XDG_CONFIG_HOME := $(PWD)
XDG_CACHE_HOME := $(PWD)
XDG_DATA_HOME := $(PWD)
export XDG_STATE_HOME XDG_CONFIG_HOME XDG_CACHE_HOME XDG_DATA_HOME

NVIM_APPNAME := tests
export NVIM_APPNAME

LUAROCKS := luarocks --lua-version 5.1 --tree $(ROCKS_TREE)
BUSTED := $(ROCKS_TREE)/bin/busted --lua $(LUA)

# capture arguments after `make <recipe>` and prevent interpretation as targets
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: usage deps test watch scratch
usage:
	@echo "usage:"
	@echo "  make <test|watch> [filter...]  # run tests"
	@echo "  make deps                      # install test dependencies"
	@echo "  make nvim                      # start neovim w/ test env"
	@exit 0

deps:
	@$(LUAROCKS) install busted             2.2.0
	@$(LUAROCKS) install nlua               0.2.0
	@$(LUAROCKS) install nvim-nio           1.10.1
	@$(LUAROCKS) install fennel-ls          0.1.3
	@$(LUAROCKS) install tree-sitter-fennel 0.0.29

test:
	@$(BUSTED) tests --pattern=".*$(ARGS).*"

watch:
	@while true; do \
		modtime=$$(find lua tests -name "*.lua" -type f -exec stat -f %m {} \; | sort -n | tail -n 1); \
		if [ "$$modtime" != "$$prev_modtime" ]; then \
			clear; \
			make -s test $(ARGS) || true; \
			prev_modtime=$$modtime; \
		fi; \
		sleep 0.5; \
	done

nvim:
	@nvim
