
all: clean zip

clean:
	rm -rf dist
	mkdir dist
zip: 
	mkdir -p dist/yana-rundeck-shell-plugin
	cp -r src/* dist/yana-rundeck-shell-plugin
	(cd dist; zip -r ../dist/yana-rundeck-shell-plugin.zip yana-rundeck-shell-plugin)
