SCRIPTS_DIR := scripts
LOG_FILE := /opt/my-resources/setup/setup.log
ERROR_LOG := /workspace/error.log
TEMP_LOG_DIR := /tmp/setup_logs
LOG_FUNC_FILE := helpers/logs.sh

# Create temp log directory
$(shell mkdir -p $(TEMP_LOG_DIR))

# Get list of scripts with full paths
SCRIPTS := $(wildcard $(SCRIPTS_DIR)/*.sh)

# Get list of script names without directory
SCRIPT_NAMES := $(notdir $(SCRIPTS))

# Mark all targets as phony to ensure they always run
.PHONY: all $(SCRIPT_NAMES) clean_logs

# Default target
all: clean_logs $(SCRIPT_NAMES)
	@echo "Concatenating logs in order..." | tee -a $(LOG_FILE)
	@for script in $(SCRIPT_NAMES); do \
		if [ -f "$(TEMP_LOG_DIR)/$$script.log" ]; then \
			cat "$(TEMP_LOG_DIR)/$$script.log" >> $(LOG_FILE); \
		fi; \
	done
	@rm -rf $(TEMP_LOG_DIR)

# Clean temporary logs
clean_logs:
	@rm -rf $(TEMP_LOG_DIR)
	@mkdir -p $(TEMP_LOG_DIR)
	@> $(LOG_FILE)

# Function to get dependencies for a script
define GET_DEPS
$(shell grep -m1 '^# DEPENDS_ON:' $(1) | awk -F': ' '{print $$2}' | tr ',' ' ')
endef

# Function to handle 'all' dependency
define HANDLE_ALL_DEPS
$(if $(filter all,$(1)),$(filter-out $(2),$(SCRIPT_NAMES)),$(1))
endef

# Auto-detect dependencies
define SCRIPT_RULE
$(notdir $(1)): $$(call HANDLE_ALL_DEPS,$$(call GET_DEPS,$(1)),$$@)
	@echo "Running $$@..." > "$(TEMP_LOG_DIR)/$$@.log"
	@bash -c '\
		source $(LOG_FUNC_FILE); \
		log START "Starting $$@"; \
		if ! bash $(1); then \
			log ERROR "Last 5 lines of output:"; \
			tail -n 20 "$(TEMP_LOG_DIR)/$$@.log" | while read line; do echo "$$line"; done; exit 1; fi; \
		log SUCCESS "$$@ completed successfully"; \
		log END "Finished $$@"' 2>&1 | tee -a "$(TEMP_LOG_DIR)/$$@.log" || { \
			echo "Error in $$@. Check $(LOG_FILE) for details." | tee -a $(ERROR_LOG); \
			echo "Dependencies: $$(call GET_DEPS,$(1))" | tee -a $(ERROR_LOG); \
			exit 1; \
		}
endef

# Create rules for all scripts
$(foreach script,$(SCRIPTS),$(eval $(call SCRIPT_RULE,$(script))))