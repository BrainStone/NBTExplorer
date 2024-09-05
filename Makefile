########################################################################################################################
# Settings                                                                                                             #
########################################################################################################################

# Where we want to create the source packages
BUILD_DIR := build

# Package dirs
NBTEXPLORER_DIR := $(BUILD_DIR)/nbtexplorer
NBTUTIL_DIR := $(BUILD_DIR)/nbtutil
NBTEXPLORER_COMPLETE_DIR := $(BUILD_DIR)/nbtexplorer-complete

# Versions
NBTEXPLORER_VERSION := $(shell awk -F'[".]' '/AssemblyFileVersion/ {print $$2"."$$3"."$$4}' upstream/NBTExplorer/Properties/AssemblyInfo.cs)
NBTUTIL_VERSION := $(shell awk -F'[".]' '/AssemblyFileVersion/ {print $$2"."$$3"."$$4}' upstream/NBTUtil/Properties/AssemblyInfo.cs)
BASE_VERSION := $(NBTEXPLORER_VERSION)
NBTEXPLORER_VERSION_FULL := $(BASE_VERSION)-$(NBTEXPLORER_VERSION)
NBTUTIL_VERSION_FULL := $(BASE_VERSION)-$(NBTUTIL_VERSION)

########################################################################################################################
# High level targets                                                                                                   #
########################################################################################################################

# Build all 3 source packages
all: nbtexplorer nbtutil nbtexplorer_complete

# Build nbtexplorer source package
nbtexplorer: $(NBTEXPLORER_DIR)/nbtexplorer_$(NBTEXPLORER_VERSION_FULL).orig.tar.gz
	@echo "Building nbtexplorer"

# Build nbtutil source package
nbtutil: $(NBTUTIL_DIR)/nbtutil_$(NBTUTIL_VERSION_FULL).orig.tar.gz
	@echo "Building nbtutil"

# Build nbtexplorer_complete source package
nbtexplorer_complete: $(NBTEXPLORER_COMPLETE_DIR)/nbtexplorer-complete_$(BASE_VERSION).orig.tar.gz
	@echo "Building nbtexplorer_complete"

# Clean target to remove the build directory
clean:
	rm -rf "$(BUILD_DIR)"
	@echo "Build directory removed"

########################################################################################################################
# Individual files and other build rules                                                                               #
########################################################################################################################

$(BUILD_DIR)/%.orig.tar.gz: upstream/
	mkdir -p "$(dir $@)"
	bsdtar -s '@^\.@$(subst _,-,$(notdir $*))@' -czf "$@" -C upstream .
