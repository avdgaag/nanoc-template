# Nanoc Website Template

## Description

This is a simple template project for kick-starting a web project using the [Nanoc static site generator by Denis Defreyne][2]. Here are some notable features:

* Settings to automatically support Google Analytics, Feedburner and
  Webmaster tools.
* Base stylesheet
* Javascript and CSS concatenation and minification
* combined screen and print stylesheet for minimal number of HTTP requests
* Improved typography
* Caching of static assets
* Comes with sitemap, htaccess, robots.txt and 404 page
* Comes with vendored jquery and modernizr
* rake tasks to ping Google and ping-o-matic when your site has changed
* rake task to find unused CSS rules for your site
* Lots of demo content to help setting up base stylesheet

Here's what's left on my to-do list:

* Automatic image optimization using jpgtran and pngcrush.

  The problem here is setting up the required third-party tools. Also,
  processing images takes a lot of time. This is not really desirable when
  compiling the site. It should be done once and that's it.

* Automatic thumbnail generation

  An `img_tag` helper could insert images in the desired size with dimension
  already filled out. Feels bloated, though.

Occasionally, I extract code and conventions from real-world projects and pull it back into this template.

## Credits

* **Author**: Arjan van der Gaag  <aran@arjanvandergaag.nl>
* **URL**: http://arjanvandergaag.nl

A lot of the HTML, CSS and htaccess rules is based on [Paul Irish's HTML5-boilerplate][1].

## License

Copyright (c) 2009-2010 Arjan van der Gaag

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

[1]: http://github.com/paulirish/html5-boilerplate
[2]: http://nanoc.stoneship.org
