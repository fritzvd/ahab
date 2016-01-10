debug = true

Sprite = require 'sprite'
shine = require 'shine'

Text = {}
Text.__index = Text
function Text.create (font, textString, x, y)
  local text = {}
  setmetatable(text, Text)
  text.string = textString
  text.text = love.graphics.newText(font, textString)
  text.x = x
  text.y = y
  return text
end

function Text:draw ()
  love.graphics.draw(self.text, self.x, self.y)
end

function love.load()

  -- post processor
  local grain = shine.filmgrain()
  grain.opacity = 0.2
  local desaturate = shine.desaturate{strength = 0.6, tint = {255,250,200}}
  -- you can chain multiple effects
  post_effect = grain
  -- warning - setting parameters affects all chained effects:
  post_effect.opacity = 0.5 -- affects both vignette and film grain

  local scale = 20
  local framerate = 8
  font = love.graphics.newFont('font.ttf', 40)
  love.graphics.setDefaultFilter('nearest', 'nearest', 1)
  moby = Sprite.create('moby.png', 100, 100, 8, 8, framerate, scale)
  ahab = Sprite.create('ahab.png', 0, 0, 8, 8, framerate, scale)

  time = 0
  frames = 0

  love.graphics.setBackgroundColor(148, 178, 255, 0.5)
  width, height, mode = love.window.getMode()
  wave = love.graphics.newImage('wave.png')
  waveW = wave:getWidth()
  waveH = wave:getHeight()
  TileTable = {
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0 }
  }

  drawables = {}
  drawables['ahab'] = ahab
  drawables['ahab-ack'] = Text.create(font, 'AAH! It\'s Moby', 200, 200)
end

function love.update(dt)
  time = time + dt
  frames = frames + 1
  
  if time < 2 then
    drawables['ahab'].scale = drawables['ahab'].scale + 0.5
  elseif (time > 2 and time < 3)  then
    drawables['ahab'] = nil
    drawables['ahab-ack'] = nil
  end
  if time > 2 then
    drawables['moby'] = moby
    drawables['ahab'] = nil
  end

  if love.keyboard.isDown("a") then
    moby:moveLeft()
  end
  if love.keyboard.isDown("d") then
    moby:moveRight()
  end
  if love.keyboard.isDown("s") then
    moby:moveDown()
  end
  if love.keyboard.isDown("w") then
    moby:moveUp()
  end
end

function draw()
  for rowIndex=1, #TileTable do
    local row = TileTable[rowIndex]
    for columnIndex=1, #row do
      local number = row[columnIndex]
      love.graphics.draw(wave, (columnIndex - 1) * waveW, (rowIndex - 1) * waveH)
    end
  end

  for k,drawable in pairs(drawables) do
    if k ~= nill then
      print(k)
      drawable:draw()
    end
  end
end

function love.draw()
  post_effect:draw(function()
        draw()
    end)
end
