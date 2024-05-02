#!/usr/bin/env make

Container 	= example-go-versioning

SHELL 			:= $(shell command -v zsh)
UNAME 			:= $(shell uname)
CWD 			:= $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

Directory 		= $(shell git rev-parse --show-toplevel 2>/dev/null || true)

Remote   		= $(shell git remote 2>/dev/null | xargs echo)
Branch 	  		= $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
Branches  		= $(shell git for-each-ref --format="%(refname:short)" refs/heads/ 2>/dev/null | xargs printf)

Remotes   		= $(shell git remote -v 2>/dev/null | xargs printf)

Dirty 			= $(shell git diff --shortstat 2>/dev/null 2>/dev/null | tail -n1)

Version  		= $(shell [ -f VERSION ] && head VERSION || echo "0.0.0")

Build    		= $(shell git log --oneline 2>/dev/null | wc -l | sed -e "s/[ \t]*//g")

Major      		= $(shell echo $(Version) | sed "s/^\([0-9]*\).*/\1/")
Minor      		= $(shell echo $(Version) | sed "s/[0-9]*\.\([0-9]*\).*/\1/")
Patch      		= $(shell echo $(Version) | sed "s/[0-9]*\.[0-9]*\.\([0-9]*\).*/\1/")

Major-Upgrade 	= $(shell expr $(Major) + 1).$(Minor).$(Patch)
Minor-Upgrade 	= $(Major).$(shell expr $(Minor) + 1).$(Patch)
Patch-Upgrade 	= $(Major).$(Minor).$(shell expr $(Patch) + 1)

Major-Build-Upgrade 	= $(shell expr $(Major) + 1).$(Minor).$(Patch)-Build-$(Build)
Minor-Build-Upgrade 	= $(Major).$(shell expr $(Minor) + 1).$(Patch)-Build-$(Build)
Patch-Build-Upgrade 	= $(Major).$(Minor).$(shell expr $(Patch) + 1)-Build-$(Build)

Binary 	?=  $(shell command -v go)

.PHONY: run

version-bump-patch:
	@echo $(Patch-Upgrade) > VERSION

version-bump-minor:
	@echo $(Minor-Upgrade) > VERSION

version-bump-major:
	@echo $(Major-Upgrade) > VERSION

clean:
	$(Binary) clean -x -cache -modcache -r -i

build: version-bump-patch
	docker build --tag "$(Container)" --file Dockerfile .

test:
	go run .

run: build
	docker run $(Container)

list:
	$(Binary) list -m -u -json all

upgrade:
	$(Binary) get -u .
	$(Binary) mod tidy

MAKEFLAGS += --warn-undefined-variables --no-builtin-rules

.SHELLFLAGS := -eu -o pipefail -c
