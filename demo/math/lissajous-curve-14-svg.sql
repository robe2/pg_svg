-- ---------------------------------
-- Lissajous curve, as SVG
--
-- Parameter: iteration
-- iteration dependent values in SVG:
--   id divisor hsl function

-- psql -A -t -o lissajous-curve-14.svg  < lissajous-curve-14-svg.sql
-- ---------------------------------

WITH angs AS (
  SELECT  1 AS a,
          4 As b,
          0.0 as phase,
          generate_series(0.0, 2*pi()::numeric, 0.05) AS ang
),
seg AS (
    SELECT ang, ST_MakeLine(
        ST_Point( sin(a * ang),        sin(b * ang          + phase)),
        ST_Point( sin(a * ang + 0.05), sin(b * (ang + 0.05) + phase))
    ) AS geom
    FROM angs
),
svg AS ( SELECT geom, svgShape( geom,
        style => svgStyle('stroke',
                    svgHSL( 240, 100,
                      10 + abs( 50 * sin(ang - pi()/4))
                    ))
      ) AS svg
    FROM seg
)
SELECT svgDoc( array_agg( svg ),
          viewbox => svgViewbox( ST_Expand( ST_Extent(geom), 0.5 )),
          style => svgStyle('stroke-width', '0.2', 'stroke-linecap', 'round' )
    ) AS svg
  FROM svg;