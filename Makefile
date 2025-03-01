ROCKS_TREE := .luarocks
LUAROCKS := luarocks --lua-version 5.1 --tree $(ROCKS_TREE)
BUSTED := $(ROCKS_TREE)/bin/busted

# capture arguments after `make <recipe>` and prevent interpretation as targets
ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

.PHONY: default deps test watch
default: # no-op
	@exit 0

deps:
	@$(LUAROCKS) install busted 2.2.0
	@$(LUAROCKS) install nlua   0.2.0

test:
	@XDG_STATE_HOME=. NVIM_APPNAME="tests" $(BUSTED) tests --pattern=".*$(ARGS).*"

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
