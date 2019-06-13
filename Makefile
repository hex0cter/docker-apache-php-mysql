REGISTRY                 ?= hex0cter
IMAGE                     = opencart
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
	@$(DOCKER) run -it -P --name $(IMAGE) $(REGISTRY)/$(IMAGE):$(VERSION)

shell:
	@$(DOCKER) exec -it $(IMAGE) bash

push: build
	@$(DOCKER) push $(REGISTRY)/$(IMAGE):$(VERSION)
