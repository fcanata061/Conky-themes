-- Anéis/rings simples para CPU, RAM etc.
-- Inspirado no conky-lua-rings, mas minimalista.
-- Uso: ${lua ring <valor> <max> <x> <y> <raio> <larg> <r> <g> <b> <a>}
-- Ex.: ${lua ring ${cpu cpu0} 100 1580 220 44 5 0 255 255 0.9}
require 'cairo'

local function clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end

function conky_ring(val, max, x, y, radius, thickness, r, g, b, a)
  if conky_window == nil then return end
  local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable,
              conky_window.visual, conky_window.width, conky_window.height)
  local cr = cairo_create(cs)

  val = tonumber(val) or 0
  max = tonumber(max) or 100
  local pct = clamp(val / max, 0, 1)

  -- fundo
  cairo_set_source_rgba(cr, r/255, g/255, b/255, a*0.2)
  cairo_set_line_width(cr, thickness)
  cairo_arc(cr, x, y, radius, 0, 2*math.pi)
  cairo_stroke(cr)

  -- valor
  cairo_set_source_rgba(cr, r/255, g/255, b/255, a)
  cairo_arc(cr, x, y, radius, -math.pi/2, -math.pi/2 + 2*math.pi*pct)
  cairo_stroke(cr)

  cairo_destroy(cr)
  cairo_surface_destroy(cs)
end
