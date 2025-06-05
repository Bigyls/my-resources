# Configuration
SCRIPTS_DIR := scripts
LOG_FILE := /opt/my-resources/setup/setup.log
ERROR_LOG := /workspace/error.log
TEMP_LOG_DIR := /tmp/setup_logs
LOG_FUNC_FILE := helpers/logs.sh

# Script discovery
SCRIPTS := $(wildcard $(SCRIPTS_DIR)/*.sh)
SCRIPT_NAMES := $(notdir $(SCRIPTS))

# Mark all targets as phony
.PHONY: all $(SCRIPT_NAMES) clean_logs

# Default target
all: clean_logs $(SCRIPT_NAMES)
	@echo "==== Setup finished at $$(date) ====" >> $(LOG_FILE)
	@echo "==== Elapsed time: $$(($$(date +%s) - $(START_TIME))) seconds ====" >> $(LOG_FILE)
	@rm -rf $(TEMP_LOG_DIR)

# Clean temporary logs
clean_logs:
	@rm -rf $(TEMP_LOG_DIR)
	@mkdir -p $(TEMP_LOG_DIR)
	@echo "==== Setup started at $$(date) ====" > $(LOG_FILE)
	$(eval START_TIME := $(shell date +%s))

# Get dependancies
define GET_DEPS
$(shell grep -m1 '^# DEPENDS_ON:' $(1) | awk -F': ' '{print $$2}' | tr ',' ' ')
endef

define HANDLE_ALL_DEPS
$(if $(filter all,$(1)),$(filter-out $(2),$(SCRIPT_NAMES)),$(1))
endef

# Script execution template
define SCRIPT_RULE
$(notdir $(1)): $$(call HANDLE_ALL_DEPS,$$(call GET_DEPS,$(1)),$$@)
	@echo "Executing $(1). See logs in $(TEMP_LOG_DIR)/$$@.log" >> $(LOG_FILE)
	@echo "[START] $$(date) $(1)" > "$(TEMP_LOG_DIR)/$$@.log"
	@if ! bash $(1) >> "$(TEMP_LOG_DIR)/$$@.log" 2>&1; then \
		echo "[ERROR] $$(date) $(1)" >> "$(TEMP_LOG_DIR)/$$@.log"; \
		echo "An error occurred while executing $(1). Check the $(LOG_FILE) file for details." >> $(ERROR_LOG); \
		exit 1; \
	else \
		echo "[SUCCESS] $$(date) $(1)" >> "$(TEMP_LOG_DIR)/$$@.log"; \
	fi
	@echo "[END] $$(date) $(1)" >> "$(TEMP_LOG_DIR)/$$@.log"
	@flock $(LOG_FILE) -c 'cat "$(TEMP_LOG_DIR)/$$@.log" >> $(LOG_FILE)'
endef

# Generate rules for all scripts
$(foreach script,$(SCRIPTS),$(eval $(call SCRIPT_RULE,$(script))))
