# Nanoc template

This is a template project for building static websites with [Nanoc][]. It contains
some extensions and configurations that I frequently use.

## Features

* CSS compiled using [autoprefixer][] and [Tailwind][]
* Apply [PurgeCSS][] in production environment
* A Gemfile with a bunch of commonly used gems
* A `Convert` filter to convert between image formats using ImageMagick
* A `PngCrush` filter to optimise PNG files
* Automatically export website icons from a [Sketch][] file
* Some default files for JS, webmanifest, robots.txt, etc. courtesy of
  [HTML5 Boilerplate][]
* Automatically generated sitemap
* Add gzipped versions of static assets in production environment

[Tailwind]: https://tailwindcss.com
[Nanoc]: https://nanoc.ws
[autoprefixer]: https://autoprefixer.github.io
[Sketch]: https://sketch.com
[PurgeCSS]: https://www.purgecss.com
[HTML5 Boilerplate]: https://html5boilerplate.com