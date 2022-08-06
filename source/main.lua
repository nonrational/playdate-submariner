-- Name this file `main.lua`. Your game can use multiple source files if you wish
-- (use the `import "myFilename"` command), but the simplest games can be written
-- with just `main.lua`.

-- You'll want to import these in just about every project you'll work on.

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"

-- local playdate = playdate

-- Declaring this "gfx" shorthand will make your life easier. Instead of having
-- to preface all graphics calls with "playdate.graphics", just use "gfx."
-- Performance will be slightly enhanced, too.
-- NOTE: Because it's local, you'll have to do it in every .lua source file.

local gfx <const> = playdate.graphics

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.

local planeSprite = nil
local scopeSprite = nil
local boatSprite = nil

-- A function to set up our game environment.

-- should be newEnemyAt ?
function newBoatAt(x, y)
  local boatPng = gfx.image.new("images/sub")
  assert(boatPng)
  local boat = gfx.sprite.new(boatPng)
  boat:moveTo(x, y)
  boat:setScale(0.25)
  return boat
end

function drawCircle(sprite, x, y, w, h)
  local width = 2
  gfx.setColor(gfx.kColorBlack)
  gfx.setLineWidth(width)
  gfx.drawCircleAtPoint(sprite.radius + width, sprite.radius + width, sprite.radius)
end

function newScopeAt(x, y)
  local r = 120
  local width = 2
  local scope = gfx.sprite.new()

  scope.draw = drawCircle
  scope.radius = r

  scope:setSize((r * 2) + width + 1, (r * 2) + width + 1)
  scope:moveTo(x, y)

  -- scope:setCollideRect(1, 1, 10, 10)
  -- scope.dx = math.random(5)

  return scope
end

function myGameSetUp()
  -- Set up the player sprite.
  -- The :setCenter() call specifies that the sprite will be anchored at its center.
  -- The :moveTo() call moves our sprite to the center of the display.

  local planePng = gfx.image.new("images/plane.png")
  assert(planePng) -- make sure the image was where we thought

  gfx.clear()

  -- planeSprite = gfx.sprite.new(planePng)
  -- planeSprite:moveTo(0, 0) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
  -- planeSprite:add() -- This is critical!

  gfx.setBackgroundColor(gfx.kColorWhite)

  boatSprite = newBoatAt(200, 120)
  boatSprite:add()
  -- printTable(boatSprite)

  scopeSprite = newScopeAt(200, 120)
  scopeSprite:add()


  -- printTable(scope)

  -- We want an environment displayed behind our sprite.
  -- There are generally two ways to do this:
  -- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
  -- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
  --       and call :setZIndex() with some low number so the background stays behind
  --       your other sprites.

  -- local backgroundImage = gfx.image.new("images/background")
  -- assert(backgroundImage)

  -- gfx.sprite.setBackgroundDrawingCallback(
  --   function( x, y, width, height )
  --     -- x,y,width,height is the updated area in sprite-local coordinates
  --     -- The clip rect is already set to this area, so we don't need to set it ourselves
  --     backgroundImage:draw( 0, 0 )
  --   end
  -- )
end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

myGameSetUp()

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

  -- Poll the d-pad and move our player accordingly.
  -- (There are multiple ways to read the d-pad; this is the simplest.)
  -- Note that it is possible for more than one of these directions
  -- to be pressed at once, if the user is pressing diagonally.

  -- if playdate.buttonIsPressed(playdate.kButtonUp) then
  --   planeSprite:moveBy(0, -2)
  -- end
  -- if playdate.buttonIsPressed(playdate.kButtonRight) then
  --   planeSprite:moveBy(2, 0)
  -- end
  -- if playdate.buttonIsPressed(playdate.kButtonDown) then
  --   planeSprite:moveBy(0, 2)
  -- end
  -- if playdate.buttonIsPressed(playdate.kButtonLeft) then
  --   planeSprite:moveBy(-2, 0)
  -- end

  -- planeSprite:setVisible(false)

  -- use the crank to handle up / down motions as well.
  local newScale = playdate.getCrankTicks(10) / 100 + boatSprite:getScale()
  -- print(newScale)
  if (newScale >= 0.25)
  then
    boatSprite:setScale(newScale)
  end

  -- Call the functions below in playdate.update() to draw sprites and keep
  -- timers updated. (We aren't using timers in this example, but in most
  -- average-complexity games, you will.)

  gfx.sprite.update()
  playdate.timer.updateTimers()
end
