SHELL := /bin/bash
.ONESHELL:

DOCKER_COMPOSE ?= docker compose
# default image used if you don’t build custom one
COMPOSER_IMAGE ?= composer:2
UID := $(shell id -u)
GID := $(shell id -g)

# Custom composer image tag
COMPOSER_BCMATH_IMAGE = composer:bcmath

.PHONY: help composer-build composer-install composer-update composer-require composer-remove composer-dump composer-clear-cache composer-validate composer-audit

help:
	@echo "Usage:"
	@echo "  make composer-build               # build local composer:bcmath image"
	@echo "  make composer-install"
	@echo "  make composer-update"
	@echo "  make composer-require vendor/pkg[:ver] [-- <flags>]"
	@echo "  make composer-remove  vendor/pkg"
	@echo "  make composer-dump"
	@echo "  make composer-validate"
	@echo "  make composer-audit"

# Build a custom composer image with ext-bcmath enabled
composer-build:
	docker build -f docker/composer/Dockerfile -t $(COMPOSER_BCMATH_IMAGE) .
	@echo "Run make with COMPOSER_IMAGE=$(COMPOSER_BCMATH_IMAGE) to use it."

composer-install:
	$(MAKE) _composer CMD="install --prefer-dist --no-interaction --no-progress $(EXTRA)"

composer-update:
	$(MAKE) _composer CMD="update --prefer-dist --no-interaction --no-progress $(EXTRA)"

composer-require:
	@args='$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))'
	pkgs=""; flags=""; seen=0
	for a in $$args; do
		if [ "$$a" = "--" ]; then seen=1; continue; fi
		if [ $$seen -eq 0 ]; then pkgs="$$pkgs $$a"; else flags="$$flags $$a"; fi
	done
	@if [ -z "$$pkgs" ]; then echo "Usage: make composer-require vendor/pkg[:ver] ... [-- <flags>]"; exit 1; fi
	$(MAKE) _composer CMD="require $$pkgs $$flags"

composer-remove:
	@pkgs='$(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))'
	@if [ -z "$$pkgs" ]; then echo "Usage: make composer-remove vendor/package ..."; exit 1; fi
	$(MAKE) _composer CMD="remove $$pkgs"

composer-dump:
	$(MAKE) _composer CMD="dump-autoload -o"

composer-clear-cache:
	$(MAKE) _composer CMD="clear-cache"

composer-validate:
	$(MAKE) _composer CMD="validate --strict"

composer-audit:
	$(MAKE) _composer CMD="audit"

# Internal target to run composer either via service or image
.PHONY: _composer
_composer:
	@if $(DOCKER_COMPOSE) config --services 2>/dev/null | grep -qx composer; then \
		echo "→ Using compose service 'composer'"; \
		$(DOCKER_COMPOSE) run --rm composer $$CMD; \
	else \
		echo "→ Using image $(COMPOSER_IMAGE)"; \
		docker run --rm -v "$(CURDIR)":/app -u $(UID):$(GID) -w /app $(COMPOSER_IMAGE) $$CMD; \
	fi

# Swallow extra goals like package names
%::
	@:
