
main:
	@echo "please run \`make release-{major|minor|patch}\`"

increment-patch:
	composer increment:patch

increment-minor:
	composer increment:minor

increment-major:
	composer increment:major

build:
	docker build -t "sideagroup/web-academy-devcontainer:$(shell cat .devcontainer/sidea-devcontainer.version)" \
		--build-arg PHP_VERSION=8.1 \
		--build-arg NODE_VERSION="lts/gallium" \
		--build-arg MYSQL_HOST=db \
		--build-arg MYSQL_USER=mariadb \
		--build-arg MYSQL_PWD=mariadb \
		--build-arg MYSQL_DB_NAME=mariadb \
		--build-arg MYSQL_ROOT_PWD=mariadb \
		--build-arg SIDEA_DEVCONTAINER_VERSION=$(shell cat .devcontainer/sidea-devcontainer.version) \
		devcontainer

push:
	docker tag "sideagroup/web-academy-devcontainer:$(shell cat .devcontainer/sidea-devcontainer.version)" sideagroup/web-academy-devcontainer:latest
	docker push "sideagroup/web-academy-devcontainer:$(shell cat .devcontainer/sidea-devcontainer.version)"
	docker push sideagroup/web-academy-devcontainer:latest

release-patch: increment-patch version-file build push release-zip
release-minor: increment-minor version-file build push release-zip
release-major: increment-major version-file build push release-zip

version-file:
	composer get:version > .devcontainer/sidea-devcontainer.version

zip:
	sed -i '' -e 's/sideagroup\/web-academy-devcontainer:.*/sideagroup\/web-academy-devcontainer:$(shell cat .devcontainer/sidea-devcontainer.version)/g' .devcontainer/docker-compose.yml
	rm sidea-workspace.zip
	zip -r sidea-workspace.zip .devcontainer/ .vscode/

release-zip: zip
	git add .
	git commit -m "release $(shell cat .devcontainer/sidea-devcontainer.version)"
	git push

stack-up:
	docker-compose \
		-f .devcontainer/docker-compose.yml \
		-f docker-compose.override.yml \
		--project-directory . \
		up --build --force-recreate -d app db

test: stack-up
	docker-compose \
		-f .devcontainer/docker-compose.yml \
		-f docker-compose.override.yml \
		--project-directory . \
		exec app bash

test-as-root: stack-up
	docker-compose \
		-f .devcontainer/docker-compose.yml \
		-f docker-compose.override.yml \
		--project-directory . \
		exec -u root app bash

stack-down:
	docker-compose \
		-f .devcontainer/docker-compose.yml \
		-f docker-compose.override.yml \
		--project-directory . \
		down --volumes --remove-orphans