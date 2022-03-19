
main:
	@echo "please run \`make release-{major|minor|patch}\`"

increment-patch:
	composer increment:patch

increment-minor:
	composer increment:minor

increment-major:
	composer increment:major

build:
	docker build -t "sideagroup/web-academy-devcontainer:$(shell composer get:version)" \
		--build-arg VARIANT=8.1 \
		--build-arg NODE_VERSION="lts/gallium" \
		--build-arg MYSQL_HOST=db \
		--build-arg MYSQL_USER=root \
		--build-arg MYSQL_PWD=mariadb \
		devcontainer

push:
	docker tag "sideagroup/web-academy-devcontainer:$(shell composer get:version)" sideagroup/web-academy-devcontainer:latest
	docker push sideagroup/web-academy-devcontainer

release-patch: increment-patch build push release-zip
release-minor: increment-minor build push release-zip
release-major: increment-major build push release-zip

release-zip:
	sed -i '' -e 's/sideagroup\/web-academy-devcontainer:.*/sideagroup\/web-academy-devcontainer:$(shell composer get:version)/g' .devcontainer/docker-compose.yml
	rm sidea-workspace.zip
	zip -r sidea-workspace.zip .devcontainer/
	git add .
	git commit -m "release $(shell composer get:version)"
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