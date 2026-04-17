.PHONY: all build bundle clean help list verify lint test test-unit
.DEFAULT_GOAL := help
.SECONDEXPANSION:

PYTHON ?= python3
PLUGIN_NAME := repo-docs-skills
SKILLS_ROOT := skills
SKILLS := $(sort $(patsubst $(SKILLS_ROOT)/%/SKILL.md,%,$(wildcard $(SKILLS_ROOT)/*/SKILL.md)))
BUILD_DIR := built
ZIP_FILES := $(addprefix $(BUILD_DIR)/,$(addsuffix -skill.zip,$(SKILLS)))
REPO_DIR := $(notdir $(CURDIR))
PARENT_DIR := $(dir $(CURDIR))
PACKAGED_ROOT := $(REPO_DIR)/$(SKILLS_ROOT)

skill_files = $(shell find $(SKILLS_ROOT)/$(1) -type f | sort)

help:
	@echo "$(REPO_DIR) Build System"
	@echo ""
	@echo "Available targets:"
	@echo "  make build             - Build all skill ZIPs and place in $(BUILD_DIR)/ folder"
	@echo "  make verify            - Verify that every built ZIP is present and readable"
	@echo "  make list              - List the ZIPs currently in $(BUILD_DIR)/"
	@echo "  make clean             - Remove $(BUILD_DIR)/ folder and all ZIP files"
	@echo "  make all               - Clean then build (fresh build)"
	@echo "  make lint              - Lint Markdown, Python, YAML, and skill structure"
	@echo "  make test              - Run lint + unit tests"
	@echo "  make test-unit         - Run Python unit tests only (stdlib, no external tools)"
	@echo "  make help              - Show this help message"
	@echo ""
	@echo "Skills ($(words $(SKILLS))): $(SKILLS)"

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)
	@echo "Created $(BUILD_DIR)/ directory"

$(BUILD_DIR)/%-skill.zip: $(BUILD_DIR) $$(call skill_files,$$*)
	@echo "Building $*-skill.zip..."
	@rm -f "$@"
	@cd "$(PARENT_DIR)" && zip -q -r "$(CURDIR)/$@" "$(PACKAGED_ROOT)/$*" -x "$(PACKAGED_ROOT)/$*/.DS_Store"
	@echo "  ✓ $@ created"

build: $(ZIP_FILES)
	@echo ""
	@echo "Build complete! ZIP files ready in $(BUILD_DIR)/:"
	@ls -lh $(BUILD_DIR)/*.zip

clean:
	@if [ -d "$(BUILD_DIR)" ]; then \
		echo "Removing $(BUILD_DIR)/ folder..."; \
		rm -rf "$(BUILD_DIR)"; \
		echo "  ✓ Cleanup complete"; \
	else \
		echo "Nothing to clean ($(BUILD_DIR)/ not found)"; \
	fi

all: clean build
	@echo ""
	@echo "Full rebuild complete!"
	@echo "Skills available in: $(BUILD_DIR)/"

bundle: build
	@echo "Building $(PLUGIN_NAME)-plugin.zip..."
	@cd $(BUILD_DIR) && zip -q $(PLUGIN_NAME)-plugin.zip *-skill.zip
	@echo "  ✓ $(BUILD_DIR)/$(PLUGIN_NAME)-plugin.zip created"

verify:
	@$(PYTHON) scripts/verify_built_zips.py --build-dir $(BUILD_DIR) --skills-dir $(SKILLS_ROOT)

lint:
	@$(PYTHON) scripts/check_node_version.py || exit 1
	@echo "==> Markdown (markdownlint-cli2)..."
	@markdownlint-cli2 "**/*.md" || exit 1
	@echo "==> YAML (yamllint)..."
	@find . -name "*.yaml" -o -name "*.yml" \
		| grep -v "^./.git/" | grep -v "^./built/" | grep -v "^./node_modules/" \
		| xargs yamllint -c .yamllint.yml || exit 1
	@echo "==> Python (ruff)..."
	@ruff check --select E,F,W,I --ignore E501 \
		$$(find . -name "*.py" -not -path "./built/*" -not -path "./.git/*") || exit 1
	@echo "==> Skill structure (L01–L11)..."
	@$(PYTHON) scripts/lint_skills.py || exit 1
	@echo "==> Skill quality pre-flight (V01–V08)..."
	@$(PYTHON) scripts/validate_skills.py || exit 1
	@echo ""
	@echo "Lint passed."

test-unit:
	@echo "Running unit tests..."
	@$(PYTHON) -m unittest discover -s tests -v

test: lint test-unit
	@echo ""
	@echo "All checks passed."

list:
	@if [ -d "$(BUILD_DIR)" ]; then \
		echo "Built skill ZIPs:"; \
		ls -lh $(BUILD_DIR)/*.zip 2>/dev/null || echo "  (no ZIPs found)"; \
	else \
		echo "$(BUILD_DIR)/ folder not found. Run 'make build' first."; \
	fi
