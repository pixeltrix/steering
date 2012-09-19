# Steering

[![Build Status][build]][travis] [![Dependency Status][depends]][gemnasium]

Steering is a bridge to the [Handlebars.js][1] template precompiler. By precompiling
your templates you can speed up page loading in two ways - firstly the final compilation
step is much quicker as the template source code does not have to be parsed and the
size of the library can be reduced by using the smaller runtime library if all your
templates are precompiled.

    $ irb

    require "steering"
    # => true

    Steering.compile(File.read("example/mytemplate.handlebars"))
    # => "function(Handlebars,...) {...}"

    # This will create a file called "mytemplate.js" in the supplied
    # example folder and return the size of the resulting file in bytes.
    # Make sure to load "index.html" before and after in your favourite browser!
    Steering.compile_to_file("example/mytemplate.handlebars", "example/mytemplate.js")
    # => 1069

    context = Steering.context_for("Hello {{ name }}")
    context.call("template", :name => "Andrew")
    # => "Hello Andrew"

    Steering.render("Hello {{ name }}", :name => "world")
    # => "Hello world"

## Installation

    $ gem install steering

## Dependencies

This library depends on the `steering-source` gem which is updated any time a
new version of Handlebars.js is released (The `steering-source` gem's version
number is synced with each official Handlebars.js release). This way you can
build against different versions of Handlebars.js by requiring the correct
version of the `steering-source` gem.

In addition, you can use this library with unreleased versions of Handlebars.js
by setting the `HANDLEBARS_SOURCE_PATH` and `HANDLEBARS_RUNTIME_PATH`
environment variable:

    export HANDLEBARS_SOURCE_PATH=/path/to/handlebars.js
    export HANDLEBARS_RUNTIME_PATH=/path/to/handlebars.runtime.js

### ExecJS

The [ExecJS][2] library is used to automatically choose the best JavaScript engine
for your platform. Check out its [README][3] for a complete list of supported engines.

## Acknowledgements

The structure and code patterns for this gem were derived from the [Ruby Eco][4] gem

## Contributing

You can check out the Steering source code from GitHub:

    $ git clone http://github.com/pixeltrix/steering.git

To run Steerings's test suite run `rake test`.

Report bugs on the [GitHub issue tracker](http://github.com/pixeltrix/steering/issues).

## Special thanks

* Daniel Demmel <dain@danieldemmel.me>

## Changelog

### 1.1.1

* Bumped steering-source version to 1.0.rc.1

### 1.1.0

* Added 'compile_to_file' method. *Daniel Demmel*
* Added precompile workflow example files. *Daniel Demmel*

### 1.0.0

Initial version.

## License (MIT)

Copyright (c) 2012 Andrew White <andyw@pixeltrix.co.uk>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[1]: https://github.com/wycats/handlebars.js
[2]: https://github.com/sstephenson/execjs
[3]: https://github.com/sstephenson/execjs/blob/master/README.md
[4]: https://github.com/sstephenson/ruby-eco
[build]: https://secure.travis-ci.org/pixeltrix/steering.png
[travis]: http://travis-ci.org/pixeltrix/steering
[depends]: https://gemnasium.com/pixeltrix/steering.png?travis
[gemnasium]: https://gemnasium.com/pixeltrix/steering
