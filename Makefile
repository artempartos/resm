REBAR="./rebar"
PROJECT=resm
DESCRIPTION="Simple resource manager"

all: get-deps compile

compile:
	$(REBAR) compile

test: compileapp
	ERL_FLAGS="-config $(CURDIR)/files/app" $(REBAR) ct -r skip_deps=true

run: compileapp
	erl -config $(CURDIR)/files/app -pa apps/*/ebin deps/*/ebin -s resm

get-deps:
	$(REBAR) get-deps

cleanapp:
	rm -rf build
	$(REBAR) clean skip_deps=true

compileapp:
	$(REBAR) compile skip_deps=true

.PHONY: test

BUILD_DIR=$(CURDIR)/$(PROJECT)
PACKAGE_DIR=$(CURDIR)/build

_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
ifeq ($(_BRANCH),master)
    PACKAGE?=$(PROJECT)
else
    PACKAGE?=$(PROJECT)-$(_BRANCH)
endif

OVERLAY_VARS?=files/vars.config
VERSION?=$(shell git describe --always --tags | sed -e "s/-[^-]*$$//;s/-/./")

build: compile
	./rebar generate overlay_vars=$(OVERLAY_VARS)

go:
	make OVERLAY_VARS=files/vars-dev.config
	./$(PROJECT)/bin/$(PROJECT) console

deb: cleanapp build
	mkdir -p $(PACKAGE_DIR)/etc/init.d
	mkdir -p $(PACKAGE_DIR)/etc/$(PROJECT)
	mkdir -p $(PACKAGE_DIR)/usr/lib/$(PROJECT)/bin
	mkdir -p $(PACKAGE_DIR)/var/log/$(PROJECT)

	cp -R $(BUILD_DIR)/erts-*   $(PACKAGE_DIR)/usr/lib/$(PROJECT)/
	cp -R $(BUILD_DIR)/lib      $(PACKAGE_DIR)/usr/lib/$(PROJECT)/
	cp -R $(BUILD_DIR)/releases $(PACKAGE_DIR)/usr/lib/$(PROJECT)/

	install -p -m 0755 $(BUILD_DIR)/bin/$(PROJECT) $(PACKAGE_DIR)/usr/lib/$(PROJECT)/bin/$(PROJECT)
	install -p -m 0755 $(CURDIR)/files/init        $(PACKAGE_DIR)/etc/init.d/$(PROJECT)
	install -m644 $(BUILD_DIR)/etc/app.config      $(PACKAGE_DIR)/etc/$(PROJECT)/app.config
	install -m644 $(BUILD_DIR)/etc/vm.args         $(PACKAGE_DIR)/etc/$(PROJECT)/vm.args

	fpm -s dir -t deb -f -n $(PACKAGE) -v $(VERSION) \
		--after-install $(CURDIR)/files/postinst \
		--after-remove  $(CURDIR)/files/postrm \
		--config-files /etc/$(PROJECT)/app.config \
		--config-files /etc/$(PROJECT)/vm.args \
		--deb-pre-depends adduser \
		--description $(DESCRIPTION) \
		-C $(PACKAGE_DIR) etc usr var
