#!make

MAKEFLAGS += --always-make

BUILD_VERSION=dev
REGISTRY_IMAGE_PREFIX=egnd/hms

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

%:
	@:

########################################################################################################################

owner: ## Reset folder owner
	sudo chown -R $$(id -u) ./
	@echo "Success"

compose: compose-stop ## Run composed services
ifeq ($(wildcard docker-compose.override.yml),)
	ln -s docker-compose.debug.yml docker-compose.override.yml
endif
	docker-compose up --abort-on-container-exit --renew-anon-volumes

compose-stop: ## Stop composed services
ifeq ($(wildcard .env),)
	cp .env.dist .env
endif
	docker-compose down --remove-orphans --volumes

check-conflicts: ## Find git conflicts
	@if grep -rn '^<<<\<<<< ' .; then exit 1; fi
	@if grep -rn '^===\====$$' .; then exit 1; fi
	@if grep -rn '^>>>\>>>> ' .; then exit 1; fi
	@echo "All is OK"

check-todos: ## Find TODO's
	@if grep -rn '@TO\DO:' .; then exit 1; fi
	@echo "All is OK"

check-master: ## Check for latest master in current branch
	@git remote update
	@if ! git log --pretty=format:'%H' | grep $$(git log --pretty=format:'%H' -n 1 origin/master) > /dev/null; then exit 1; fi
	@echo "All is OK"

release: ## Create release archive
	@rm -rf release-$(BUILD_VERSION).zip release && mkdir -p release
	cp .env.dist release/.env.dist
	cp docker-compose.yml release/docker-compose.yml
	cp docker-compose.example.yml release/docker-compose.example.yml
	cp build/Makefile release/Makefile
	cp README.md release/README.md	
	zip -9 -roTj hms-$(BUILD_VERSION).zip release
	@ls -lah hms-$(BUILD_VERSION).zip
