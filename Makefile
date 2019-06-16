REGISTRY                 ?= hex0cter
IMAGE                     = apache-php
GIT_COMMIT                = $(shell git log --pretty=format:'%h' -n 1)
VERSION                   = latest

# docker might or might not require sudo
# # detect this automatically to simplify life a bit
DOCKER=$(shell docker info >/dev/null 2>&1 && echo "docker" || echo "sudo docker")

all: build

build:
	@$(DOCKER) build \
		--pull \
		--rm \
		--tag $(REGISTRY)/$(IMAGE):$(VERSION) \
		.

run:
	@$(DOCKER) run -it --rm -P --name $(IMAGE) $(REGISTRY)/$(IMAGE):$(VERSION)

opencart-run:
	@$(DOCKER) run -it --rm -P --name opencart -v $(PWD)/applications/opencart/upload:/var/www/html $(REGISTRY)/$(IMAGE):$(VERSION)

shell:
	@$(DOCKER) exec -it $(IMAGE) bash

opencart-shell:
	@$(DOCKER) exec -it opencart bash

push: build
	@$(DOCKER) push $(REGISTRY)/$(IMAGE):$(VERSION)
