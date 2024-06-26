VERSION_FILE := .version
VERSION      := $(shell cat ${VERSION_FILE})
LATEST_RELEASE := $(shell git describe --tags `git rev-list --tags --max-count=1`)

build-vminit:
	GOOS=linux CGO_ENABLED=0 installsuffix=cgo go build -o ./vminit-linux-amd64-${VERSION} ./cmd/vminit/main.go
	
.PHONY: release
release:
	curl -sL https://raw.githubusercontent.com/radekg/git-release/master/git-release --output /tmp/git-release
	chmod +x /tmp/git-release
	/tmp/git-release --repository-path=${GOPATH}/src/github.com/combust-labs/firebuild-mmds
	make build-from-latest-tag
	rm -rf /tmp/git-release

build-from-latest-tag:
	cd ${GOPATH}/src/github.com/combust-labs/firebuild-mmds && git checkout $(LATEST_RELEASE) && make build-vminit && git checkout master