.PHONY: all
.PHONY: venv
.PHONY: wheels wheels-all # additional PHONY 'wheels' targets are generated per architecture (e.g. wheels-x86_64)
.PHONY: appimages appimage-all # additional PHONY 'appimage' targets are generated per architecture (e.g. appimage-x86_64)
.PHONY: clean clean-all clean-venv-all clean-venv clean-build-stamps clean-build-all clean-build

.DEFAULT_GOAL := all

get_project_name = $(shell awk -F ' = ' '/^\[project\]/ {in_project=1} in_project && /name/ {gsub(/"/, "", $$2); print $$2; exit}' $(1))
get_formatted_name = $(shell echo $(1) | sed -E 's/-/_/g' | tr '_' '\n' | awk '{ $$1=toupper(substr($$1,1,1)) tolower(substr($$1,2)); print $$1 }' | tr '\n' '_' | sed 's/_$$//')

get_requires_python = $(shell awk '/\[project\]/ {in_project=1} in_project && /requires-python/ {gsub(/"/, "", $$3); split($$3, arr, ">="); print arr[2]; exit}' $(1))
get_major_minor = $(shell echo $(1) | sed -E 's/^([0-9]+)(\.[0-9]+)?(\.[0-9]+)?$$/\1\2/; s/^([0-9]+)$$/\1.0/')

SOURCE_DIR := $(CURDIR)
PACKAGING_DIR := $(SOURCE_DIR)/packaging
BUILD_DIR := $(SOURCE_DIR)/build
DIST_DIR := $(SOURCE_DIR)/dist

WHEELS_BUILD_DIR := $(BUILD_DIR)/wheels
APPIMAGE_BUILD_DIR := $(BUILD_DIR)/appimage
APPIMAGE_DIST_DIR := $(DIST_DIR)
APPIMAGE_RECIPE_DIR := $(PACKAGING_DIR)/appimage/recipe

VENV_DIR := $(BUILD_DIR)/.venv
VENV_PYTHON := $(VENV_DIR)/bin/python
VENV_PIP := $(VENV_DIR)/bin/pip

PYPROJECT_TOML := $(SOURCE_DIR)/pyproject.toml
PROJECT_NAME := $(call get_formatted_name, $(call get_project_name, $(PYPROJECT_TOML)))
REQ_PYTHON_VERSION := $(call get_requires_python, $(PYPROJECT_TOML))

ARCHS := x86_64

PYTHON_TARGET_VERSION := $(call get_major_minor, $(REQ_PYTHON_VERSION))
PYTHON_IMPLEMENTATION_CODE := cp
PYTHON_TAG := $(PYTHON_IMPLEMENTATION_CODE)$(subst .,,$(REQ_PYTHON_VERSION))
PYTHON_ABI_TAG := $(PYTHON_IMPLEMENTATION_CODE)$(subst .,,$(REQ_PYTHON_VERSION))
PYTHON_PLATFORM_TAG := manylinux2014

VENV_STAMP := $(BUILD_DIR)/.venv.stamp
WHEELS_STAMPS := $(foreach arch, $(ARCHS), $(WHEELS_BUILD_DIR)/.$(arch).stamp)
APPIMAGE_STAMPS := $(foreach arch, $(ARCHS), $(APPIMAGE_BUILD_DIR)/.$(arch).stamp)

$(VENV_STAMP):
	mkdir -p $(dir $(VENV_DIR))
	PYTHON=$(shell MIN_PYTHON_VERSION=$(REQ_PYTHON_VERSION) $(PACKAGING_DIR)/find_python.sh || echo "") $(PACKAGING_DIR)/create_venv.sh $(VENV_DIR) $(PYPROJECT_TOML) packaging
	touch $@

venv: $(VENV_STAMP)

$(WHEELS_BUILD_DIR)/.%.stamp: $(VENV_STAMP)
	mkdir -p $(WHEELS_BUILD_DIR)
	PIP=$(VENV_PIP) $(PACKAGING_DIR)/build_wheels.sh $* $(PYTHON_TARGET_VERSION) $(PYTHON_IMPLEMENTATION_CODE) $(PYTHON_ABI_TAG) $(PYTHON_PLATFORM_TAG) $(WHEELS_BUILD_DIR)/$* $(SOURCE_DIR)
	touch $@

# Generate 'wheels' targets per arch (e.g. wheels-x86_64)
.PHONY: $(foreach arch, $(ARCHS), wheels-$(arch))
define MAKE_WHEELS_TARGET
wheels-$1: $(WHEELS_BUILD_DIR)/.$1.stamp
	@echo "Built wheels for architecture: $1"
endef
$(foreach arch,$(ARCHS),$(eval $(call MAKE_WHEELS_TARGET,$(arch))))

wheels-all: $(WHEELS_STAMPS)

wheels: wheels-all

$(APPIMAGE_BUILD_DIR)/.%.stamp: $(WHEELS_BUILD_DIR)/.%.stamp
	mkdir -p $(APPIMAGE_BUILD_DIR)
	VENV=$(VENV_DIR) PYTHON=$(VENV_PYTHON) $(PACKAGING_DIR)/appimage/build.sh $* $(PYTHON_TARGET_VERSION) $(PYTHON_TAG) $(PYTHON_ABI_TAG) $(PYTHON_PLATFORM_TAG) $(APPIMAGE_RECIPE_DIR) $(WHEELS_BUILD_DIR)/$* $(APPIMAGE_BUILD_DIR)
	touch $@

# Generate 'appimage' targets per arch (e.g. appimage-x86_64)
.PHONY: $(foreach arch, $(ARCHS), appimage-$(arch))
define MAKE_APPIMAGE_TARGET
appimage-$1: $(APPIMAGE_BUILD_DIR)/.$1.stamp
	@echo "Built appimage for architecture: $1"
endef
$(foreach arch,$(ARCHS),$(eval $(call MAKE_APPIMAGE_TARGET,$(arch))))

appimage-all: $(APPIMAGE_STAMPS)

appimages: appimage-all

all: appimage-all

clean-venv-all:
	rm -rf $(VENV_DIR)
	rm -f $(VENV_STAMP)

clean-venv: clean-venv-all

clean-build-all:
	rm -rf $(BUILD_DIR)/*

clean-build-stamps:
	rm -f $(WHEELS_STAMPS) $(APPIMAGE_STAMPS)

clean-build: clean-build-all

clean-all: clean-venv-all clean-build-all

clean: clean-build
