#!make

MAKEFLAGS += --always-make

.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

%:
	@:

########################################################################################################################

owner: ## Reset folder owner
	sudo chown -R $$(id -u) ./
	@echo "Success"

run: stop ## Run composed services
	docker-compose up --detach

stop: ## Stop composed services
	docker-compose down --remove-orphans

logs: ## Start saving compose log to file
	docker-compose logs --no-color --timestamps --follow >> compose.log &
