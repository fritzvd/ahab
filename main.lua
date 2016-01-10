debug = true

Sprite = {}
Sprite.__index = Sprite
function Sprite.create(imageFile, x, y, tileSizeX, tileSizeY, framerate)
  local sprite = {}
  setmetatable(sprite, Sprite)
  sprite.framerate = framerate
  sprite.x = x
  sprite.y = y
  sprite.speed = 2
  sprite.image = love.graphics.newImage(imageFile)
  sprite.width = sprite.image:getWidth()
  sprite.height = sprite.image:getHeight()
  sprite.tileSizeX = tileSizeX
  sprite.tileSizeY = tileSizeY
  sprite.maxFramesX = sprite.width / sprite.tileSizeX
  sprite.maxFramesY = sprite.height / sprite.tileSizeY
  sprite.maxFrames = sprite.maxFramesX * sprite.maxFramesY
  sprite.currentQuad =  love.graphics.newQuad(0, 0, sprite.tileSizeX,
                                              sprite.tileSizeY,
                                sprite.width, sprite.height)
  sprite.currentFrame = 0
  return sprite
end

function Sprite:updateFrame()
  -- if self.currentFrame > sprite.maxFrames then error('Does not compute as frame') end
  --
  -- if self.currentFrame > maxFramesX then
  --   x = sprite.maxFramesY /
  if frames % self.framerate == 0 then
    self.currentFrame = self.currentFrame + 1
    if self.currentFrame == self.maxFrames then
      self.currentFrame = 0
    end
    x = (self.currentFrame % self.maxFramesY) * self.tileSizeX
    y = math.floor(self.currentFrame / self.maxFramesY) * self.tileSizeY

    self.currentQuad = love.graphics.newQuad(x, y, self.tileSizeX, self.tileSizeY,
                                  self.width, self.height)
  end
end

function Sprite:moveLeft()
  self.x = self.x - self.speed
  self:updateFrame()
end

function Sprite:moveRight()
  self.x = self.x + self.speed
  self:updateFrame()
end

function Sprite:moveUp()
  self.y = self.y - self.speed
  self:updateFrame()
end

function Sprite:moveDown()
  self.y = self.y + self.speed
  self:updateFrame()
end

function Sprite:moveRandomly()
  if frames % self.framerate == 0 then
    self.x = self.x + love.math.random(-10, 10)
    self.y = self.y + love.math.random(-10, 10)
  end
end

function love.load()
  font = love.graphics.newFont('font.ttf', 20)
  love.graphics.setDefaultFilter('nearest', 'nearest', 1)
  moby = Sprite.create('moby.png', 100, 100, 8, 8, 8)
  ahab = Sprite.create('ahab.png', 300, 300, 8, 8, 8)

  scale = 20
  time = 0
  frames = 0
end

function love.update(dt)
  time = time + dt
  frames = frames + 1

  ahab:moveRandomly()

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

function love.draw()
  love.graphics.draw(moby.image, moby.currentQuad, moby.x, moby.y, 0, scale, scale)
  love.graphics.draw(ahab.image, ahab.currentQuad, ahab.x, ahab.y, 0, scale, scale)
  -- love.graphics.rectangle('fill', 100, 100, 20, 20)
end
