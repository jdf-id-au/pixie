## This example show how to have real time pixie using sdl2 API.

import math, pixie, sdl2, sdl2/gfx

const
  rmask = uint32 0x000000ff
  gmask = uint32 0x0000ff00
  bmask = uint32 0x00ff0000
  amask = uint32 0xff000000

let
  w: int32 = 256
  h: int32 = 256

var
  screen = newImage(w, h)
  ctx = newContext(screen)
  frameCount = 0
  window: WindowPtr
  render: RendererPtr
  mainSurface: SurfacePtr
  mainTexture: TexturePtr
  evt = sdl2.defaultEvent

proc display() =
  ## Called every frame by main while loop

  # draw shiny sphere on gradient background
  let linerGradient = newPaint(pkGradientLinear)
  linerGradient.gradientHandlePositions.add(vec2(0, 0))
  linerGradient.gradientHandlePositions.add(vec2(0, 256))
  linerGradient.gradientStops.add(
    ColorStop(color: pixie.color(0, 0, 0, 1), position: 0))
  linerGradient.gradientStops.add(
    ColorStop(color: pixie.color(1, 1, 1, 1), position: 1))
  ctx.fillStyle = linerGradient
  ctx.fillRect(0, 0, 256, 256)

  let radialGradient = newPaint(pkGradientRadial)
  radialGradient.gradientHandlePositions.add(vec2(128, 128))
  radialGradient.gradientHandlePositions.add(vec2(256, 128))
  radialGradient.gradientHandlePositions.add(vec2(128, 256))
  radialGradient.gradientStops.add(
    ColorStop(color: pixie.color(1, 1, 1, 1), position: 0))
  radialGradient.gradientStops.add(
    ColorStop(color: pixie.color(0, 0, 0, 1), position: 1))
  ctx.fillStyle = radialGradient
  ctx.fillCircle(circle(
    vec2(128.0, 128.0 + sin(float32(frameCount)/10.0) * 20),
    76.8
  ))
  inc frameCount

  var dataPtr = ctx.image.data[0].addr
  mainSurface = createRGBSurfaceFrom(dataPtr, cint w, cint h, cint 32, cint 4*w,
      rmask, gmask, bmask, amask)
  mainTexture = render.createTextureFromSurface(mainSurface)
  destroy(mainSurface)

  render.clear()
  render.copy(mainTexture, nil, nil)
  destroy(mainTexture)

  render.present()

discard sdl2.init(INIT_EVERYTHING)
window = createWindow("SDL/Pixie", 100, 100, cint w, cint h, SDL_WINDOW_SHOWN)
render = createRenderer(window, -1, 0)

while true:
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      quit(0)
  display()
  delay(14)
