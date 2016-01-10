Sprite = {}
Sprite.__index = Sprite
function Sprite.create(imageFile, x, y, tileSizeX, tileSizeY, framerate, scale)
  local sprite = {}
  setmetatable(sprite, Sprite)
  sprite.framerate = framerate
  sprite.x = x
  sprite.y = y
  sprite.speed = 2
  sprite.scale = scale
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

function Sprite:draw()
  love.graphics.draw(self.image, self.currentQuad, self.x, self.y, 0,
    self.scale, self.scale)
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

return Sprite
