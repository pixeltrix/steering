# Steering

Steering is a bridge to the [Handlebars.js][1] template precompiler. By precompiling your templates you can speed up page loading in two ways - firstly the final compilation step is much quicker as the template source code does not have to be parsed and the size of the library can be reduced by using the smaller runtime library if all your templates are precompiled.

    $ irb
    
    require "steering"
    # => true
    
    Steering.compile(File.read("example/mytemplate.handlebars"))
    # => "function(Handlebars,...) {...}"
    
    # This will create a file called "mytemplate.handlebars.js" in the supplied example folder and return the size of the resulting file in bytes.
    # Make sure to load "index.html" before and after in your favourite browser!
    file = "example/mytemplate.handlebars"
    # => "example/mytemplate.handlebars"
    Steering.compile_to_file(file, File.dirname(file) + "/" + File.basename(file) + ".js")
    # => 1069
    
    context = Steering.context_for("Hello {{ name }}")
    context.call("template", :name => "Andrew")
    # => "Hello Andrew"
    
    Steering.render("Hello {{ name }}", :name => "world")
    # => "Hello world"

## Installation

    $ gem install steering

## Dependencies

This library depends on the `steering-source` gem which is updated any time a new version of Handlebars.js is released (The `steering-source` gem's version number is synced with each official Handlebars.js release). This way you can build against different versions of Handlebars.js by requiring the correct version of the `steering-source` gem.

In addition, you can use this library with unreleased versions of Handlebars.js by setting the `HANDLEBARS_SOURCE_PATH` and `HANDLEBARS_RUNTIME_PATH` environment variable:

    export HANDLEBARS_SOURCE_PATH=/path/to/handlebars.js
    export HANDLEBARS_RUNTIME_PATH=/path/to/handlebars.runtime.js

### ExecJS

The [ExecJS][2] library is used to automatically choose the best JavaScript engine for your platform. Check out its [README][3] for a complete list of supported engines.

## Acknowledgements

The structure and code patterns for this gem were derived from the [Ruby Eco][4] gem

[1]: https://github.com/wycats/handlebars.js
[2]: https://github.com/sstephenson/execjs
[3]: https://github.com/sstephenson/execjs/blob/master/README.md
[4]: https://github.com/sstephenson/ruby-eco

## Changelog

### 1.1.0

* Added 'compile_to_file' method.
* Added precompile workflow example files.

### 1.0.0

Initial version.