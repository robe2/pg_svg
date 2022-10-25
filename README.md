# SVG Functions

A collection of [PostgreSQL](https://www.postgresql.org/) functions
which allow easily creating [SVG](https://developer.mozilla.org/en-US/docs/Web/SVG) graphics.
The main goal of the API is to allow converting [PostGIS](https://postgis.net/) geometries into styled SVG documents.
The functions also support simple geometry generated without PostGIS.

## Installation

```
psql < pg-svg-lib.sql
```

Sometimes function signatures can change.
The old function must be removed.
To generate `DROP FUNCTION` commands use this query:

```sql
SELECT 'DROP FUNCTION ' || oid::regprocedure
FROM   pg_proc
WHERE  proname LIKE 'svg%' AND pg_function_is_visible(oid);
```

## Functions

### svgDoc

Creates an SVG doc element from an array of content elements.

* `content` - an array of strings output as the content of the `<svg>` element
* `viewbox` - (opt) value of SVG viewBox attribute ( x y width height )
* `width` (opt) - width of view
* `height` (opt) - height of view
* `style` (opt) - specifies CSS styling at the document level
  * see `svgStyle` function
* `def` (opt) - specifies a definition
  * see `svgLinearGradient` function

### svgViewbox

Returns an SVG `viewBox` attribute value determined from the envelope of a geometry.
The PostGIS `ST_Extent` aggregate function can be use to determine the overall
envelope of the geometries being encoded.

* `extent` - (opt) a `geometry` providing the envelope to encode.

### svgLinearGradient

Returns an SVG `linearGradient` definition element.
The element is provided as a `def` to `svgDoc`.
The CSS `fill` property value refers to the gradient using the specifier `url(#id)`

* `id` - the gradient id
* `color1` - the start color of the gradient
* `color2` - the end color of the gradient

### svgShape

Encodes a PostGIS geometry as an SVG shape.

* `geom` - geometry to encode
* `class` - (opt) class attribute
* `id` - (opt) id attribute
* `style` - (opt) style attribute value
* `attr` - (opt) additional attributes
* `title` - (opt) title

### svgPolygon

Encodes an array of XY ordinates as an SVG `polygon`.

* `pts` - array of X Y ordinates
* `class` - (opt) class attribute
* `id` - (opt) id attribute
* `style` - (opt) style attribute value
* `attr` - (opt) additional attributes
* `title` - (opt) title

### svgRect

Encodes an array of XY ordinates as an SVG `polygon`.

* `x` - X location of bottom-left corner
* `y` - Y location of bottom-left corner
* `width` - rectangle width
* `height` - rectangle height
* `class` - (opt) class attribute
* `id` - (opt) id attribute
* `style` - (opt) style attribute value
* `attr` - (opt) additional attributes
* `title` - (opt) title

### svgText

Positions a piece of textual `content` at location specified by `loc`.

* `loc` - Point geometry giving location of text
* `content` - text value
* `class` - (opt) class attribute
* `id` - (opt) id attribute
* `style` - (opt) style attribute value
* `attr` - (opt) additional attributes
* `title` - (opt) title

Relevant style CSS properties include:

* `text-anchor` - value of `start | middle | end | inherit`
* `font` - full font specifier.  E.g. `10px Verdana,Helvetica,Arial,sans-serif`
* `font-style` - value of `normal | italic | oblique`
* `font-weight` - value of `normal | bold | bolder | lighter | <number>`

### svgStyle

Encodes an array of name,value pairs as a string of SVG CSS `name: value;` properties

* `param ...` - list of name/value pairs

Common styling CSS properties are given below.
For full list see [W3C SVG spec](https://www.w3.org/TR/SVG/propidx.html).

* `fill` - fill color
* `fill-opacity` - opacity of fill; value in [ 0,1 ]
* `stroke` - line color
* `stroke-dasharray` - dashed line specifier, e.g. `2,4,1,4`
* `stroke-dashoffset` - offset of dashes
* `stroke-width` - line width
* `fill-opacity` - opacity of stroke; value in [ 0,1 ]

CSS color specifiers include:

* `#RRGGBB`
* `colorname`
* `hsl(h,s,l)` - can use the `svgHSL` function to create this
* `url(#id)` - reference to a gradient definition

### svgHSL

Encodes H,S,L values as a CSS HSL function `hsl(H,S,L)`

### svgRandInt

Returns a random integer from the range [lo, hi] (inclusive)

### svgRandPick

Returns a random item from an array of integers
