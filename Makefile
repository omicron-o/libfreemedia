.PHONY: all release build build-addon build-embed release-addon-zip release-addon-tar release-embed-zip release-embed-tar clean install

BUILD_DIR := ./build
RELEASE_DIR := ./release
SRC_DIR := ./src
MEDIA_DIR := ./media

all: release-addon-zip release-addon-tar release-embed-zip release-embed-tar
	

release: build
	mkdir -p $(RELEASE_DIR)

build: build-addon build-embed
	

build-addon: clean
	mkdir -p $(BUILD_DIR)/addon
	cp -r $(SRC_DIR) $(BUILD_DIR)/addon/LibFreeMedia
	cp LICENSE.md $(BUILD_DIR)/addon/LibFreeMedia
	#cp CHANGELOG.md $(BUILD_DIR)/addon/LibFreeMedia

build-embed: clean
	mkdir -p $(BUILD_DIR)/embed/LibFreeMedia
	echo "--[[" > $(BUILD_DIR)/embed/LibFreeMedia/LibFreeMedia.lua
	cat LICENSE.md >> $(BUILD_DIR)/embed/LibFreeMedia/LibFreeMedia.lua
	echo "--]]" >> $(BUILD_DIR)/embed/LibFreeMedia/LibFreeMedia.lua
	cat $(SRC_DIR)/LibFreeMedia.lua >> $(BUILD_DIR)/embed/LibFreeMedia/LibFreeMedia.lua

release-addon-zip: release
	7z a -tzip $(RELEASE_DIR)/LibFreeMedia-standalone.zip -w $(BUILD_DIR)/addon/.

release-addon-tar: release
	tar -cJf $(RELEASE_DIR)/LibFreeMedia-standalone.tar.xz -C $(BUILD_DIR)/addon LibFreeMedia
	tar -czf $(RELEASE_DIR)/LibFreeMedia-standalone.tar.gz -C $(BUILD_DIR)/addon LibFreeMedia

release-embed-zip: release
	7z a -tzip $(RELEASE_DIR)/LibFreeMedia-embed.zip -w $(BUILD_DIR)/embed/.

release-embed-tar: release
	tar -cJf $(RELEASE_DIR)/LibFreeMedia-embed.tar.xz -C $(BUILD_DIR)/embed LibFreeMedia
	tar -czf $(RELEASE_DIR)/LibFreeMedia-embed.tar.gz -C $(BUILD_DIR)/embed LibFreeMedia

clean:
	rm -rf $(BUILD_DIR) $(RELEASE_DIR)

install: build
	test -d "${WOW_ADDON_DIR}"
	echo rsync -q -a ./build/addon/LibFreeMedia "${WOW_ADDON_DIR}/" --delete
