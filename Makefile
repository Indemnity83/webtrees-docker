cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

VERSION ?= master
APP_NAME = webtrees
DOCKER_REPO = indemnity83

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build --build-arg VERSION=$(VERSION) -t $(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --build-arg VERSION=$(VERSION) --no-cache -t $(APP_NAME) .

run: ## Run container on port configured in `.env`
	docker run -it --rm --env-file .env -v $(DATA_VOLUME):/var/www/html/data -p $(PORT):8080 --name "$(APP_NAME)" $(APP_NAME)

up: build run ## Run container on port configured in `.env` (Alias to run)

clean: stop ## Remove the container
	docker rm $(APP_NAME)

stop: ## Stop a running container
	docker stop $(APP_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` and `latest` tagged containers to Dockerhub

# Docker publish
publish: publish-latest publish-version ## Publish the `{version}` and `latest` tagged containers to Dockerhub'

publish-latest: tag-latest ## Publish the `latest` taged container to Dockerhub'
	@echo 'publish latest to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):latest

publish-version: tag-version ## Publish the `{version}` taged container to Dockerhub'
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Docker tagging
tag: tag-latest tag-version ## Generate container tags for the `{version}` ans `latest` tags

tag-latest: build ## Generate container `{version}` tag
ifeq '$(VERSION)' 'master'
	@( read -p "Version is master, are you sure you want to tag it as latest? [y/N]: " sure && case "$$sure" in [yY]) true;; *) false;; esac )
endif

	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest


tag-version: build ## Generate container `latest` tag
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

version: ## Output the current version
	@echo $(VERSION)
	