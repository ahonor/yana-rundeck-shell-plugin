Building
--------

Run the `make` command to produce a Zip suitable for installation.

Installation
------------

Put the `yana-rundeck-shell-plugin.zip` into your `$RDECK_BASE/libext` dir.

Usage
-----

You can configure the Resource Model Sources for a project either via the
RunDeck GUI, under the "Admin" page, or you can modify the `project.properties`
file to configure the sources.

See: [Resource Model Source Configuration](http://rundeck.org/1.4/RunDeck-Guide.html#resource-model-source-configuration)

The provider name is: `yana-rundeck-shell-plugin`

Here are the configuration properties:

* `url`: The base URL to Yana server
* `nodetype`: The type name for nodes you want to return.
* `username`: The Yana username
* `password`: The Yana password


