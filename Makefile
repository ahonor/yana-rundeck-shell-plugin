
all: clean zip

clean:
	rm -rf dist
	mkdir dist
zip: 
	mkdir -p dist/yana-rundeck-shell-plugin
	cp -r src/* dist/yana-rundeck-shell-plugin
	(cd dist; zip -r ../dist/yana-rundeck-shell-plugin.zip yana-rundeck-shell-plugin)

check-env:
ifndef RDECK_BASE
    $(error RDECK_BASE is undefined)
endif

install: zip check-env
	cp dist/yana-rundeck-shell-plugin.zip $(RDECK_BASE)/libext