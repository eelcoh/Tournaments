SRC = src
BUILD = build
HTML = src/index.html
ASSETS = assets
ASSETSDIR = $(BUILD)/assets

# From https://dimiterpetrov.com/blog/elm-single-page-application-setup/

build: build-directory html js assets pwa

debug: build-directory html js-debug assets

build-directory:
	echo "Creating build directory..."
	mkdir -p $(BUILD)

html:
	echo "Copying HTML..."
	cp $(HTML) $(BUILD)/index.html

assets:
	echo "Copying assets..."
	cp -r $(ASSETS) $(BUILD)

pwa:
	echo "Copying PWA files..."
	cp $(SRC)/manifest.json $(BUILD)/manifest.json
	cp $(SRC)/sw.js $(BUILD)/sw.js

js:
	echo "Building JS..."
	elm make $(SRC)/Main.elm --optimize --output $(BUILD)/main.js

js-debug:
	echo "Building JS (debug)..."
	elm make $(SRC)/Main.elm  --output $(BUILD)/main.js

clean:
	echo "Removing build artifacts..."
	rm -rf ./elm-stuff
	rm -rf ./build


.PHONY: build debug build-directory html assets pwa js js-debug clean
