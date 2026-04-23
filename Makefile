EXT_HOME=$(HOME)/.local/share/gnome-shell/extensions/netspeedsimplified@prateekmedia.extension

SCHEMA_DIR=schemas
SCHEMA_FILE=$(SCHEMA_DIR)/org.gnome.shell.extensions.netspeedsimplified.gschema.xml
SCHEMA_COMPILED=$(SCHEMA_DIR)/gschemas.compiled

$(SCHEMA_COMPILED): $(SCHEMA_FILE)
	glib-compile-schemas $(SCHEMA_DIR)

all: install

install: extension.js metadata.json prefs.js stylesheet.css $(SCHEMA_COMPILED)
	#Remove old files(if any)
	rm -rf ${EXT_HOME}
	#Create directory structure
	mkdir -p ${EXT_HOME}
	mkdir -p ${EXT_HOME}/schemas

	#Copy compulsory files
	cp extension.js metadata.json prefs.js stylesheet.css ${EXT_HOME}
	cp $(SCHEMA_COMPILED) ${EXT_HOME}/schemas

	#Optional files
	cp LICENSE ${EXT_HOME} 2>/dev/null || true
	cp README.md ${EXT_HOME} 2>/dev/null || true
	cp $(SCHEMA_FILE) ${EXT_HOME}/schemas 2>/dev/null || true

	#Reload extension in a Wayland-safe way
	gnome-extensions disable netspeedsimplified@prateekmedia.extension 2>/dev/null || true
	gnome-extensions enable netspeedsimplified@prateekmedia.extension

remove:
	rm -rf ${EXT_HOME}
	gnome-extensions disable netspeedsimplified@prateekmedia.extension 2>/dev/null || true

remove-no-reboot:
	rm -rf ${EXT_HOME}

reinstall: remove-no-reboot install
