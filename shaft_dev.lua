--[[

Copyright (c) 2015, Marius Hårstad Bauer-Kjerkreit
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--]]


local height
local width
local depth

local last_sn_goods = 0
local junk = {
            ["minecraft:cobblestone"] = true,
            ["minecraft:dirt"] = true,
            ["minecraft:gravel"] = true,
      }

local horizontal_move = {
            ["left"] = turtle.turnLeft,
            ["right"] = turtle.turnRight,
      }
local vertical_move = {
            ["up"] = turtle.up,
            ["down"] = turtle.down,
      }
local vertical_dig = {
            ["up"] = turtle.digUp,
            ["down"] = turtle.digDown,
      }
local horizontal="left"
local vertical="down"
local tArgs = { ... }

local function print_usage()
  print("\nUsage:")
  print("  shaft.lua <height> <width> <depth> [vertical direction: up/down] [horizontal direction: left/right]")
end

if #tArgs < 3 then
  print("\nToo few arguments!\n")
  print_usage()
  return
else
  height = tonumber(math.floor(tArgs[1]/3))
  width = tonumber(tArgs[2])
  depth = tonumber(tArgs[3])
end

if #tArgs >= 4 then
  if tArgs[4] == "up" or tArgs[4] == "down" then
    vertical = tArgs[4]
  else
    print("Argument vertical direction has illegal value")
  end
end

if #tArgs == 5 then
  if tArgs[5] == "left" or tArgs[5] == "right" then
    horizontal = tArgs[5]
  else
    print("Argument horizontal direction has illegal value")
  end
end

-- utility functions
local function fwd ()
  local retval = turtle.forward()

  if not retval then
    while turtle.dig() do end
    turtle.forward()
  end
end

local function next_layer (layer)
  print("going to layer " .. layer .. " of " .. height)
  turtle.select(1)
  turtle.turnLeft()
  turtle.turnLeft()
  for i=1,3 do
    vertical_move[vertical]()
    vertical_dig[vertical]()
  end
end

local function next_row (row)
  print("going to row " .. row .. " of " .. width)
  turtle.select(1)
  horizontal_move[horizontal]()
  turtle.dig()
  fwd()
  horizontal_move[horizontal]()
  turtle.digUp()
  turtle.digDown()

  if horizontal == "left" then
    horizontal = "right"
  else
    horizontal = "left"
  end
end

local function clean_inventory ()
  io.write("cleaning inventory")

  for slot=1,16 do
    turtle.select(slot)
    local item_detail = turtle.getItemDetail()

    if item_detail and junk[item_detail.name] then
        turtle.dropDown()
    end
    io.write(".")
  end

  print("done")
  turtle.select(1)
end

local function compact_inventory ()
  io.write("compacting inventory")
  for o_slot=1,16 do
    turtle.select(o_slot)
    local item_detail = turtle.getItemDetail()
    if item_detail then
      for i_slot=o_slot + 1, 16 do
        turtle.select(i_slot)
        if turtle.getItemDetail() and
            turtle.getItemDetail().name == item_detail.name then
          turtle.transferTo(o_slot)
          turtle.select(o_slot)
          break
        end
      end
    else
      for i_slot=o_slot + 1, 16 do
        turtle.select(i_slot)
        if turtle.getItemDetail() then
          turtle.transferTo(o_slot)
          turtle.select(o_slot)
          break
        end
      end
    end
    io.write(".")
  end
  turtle.select(1)
  print("done")
end

-- init
local function init ()
  print("initializing...")
  print("digging: "..vertical.." and "..horizontal..", ".. height*3 .. "x" .. width .. "x" .. depth .. " (HxWxD)")
  turtle.dig()
  fwd()
  turtle.digUp()
  turtle.digDown()
end

-- main loop
function main ()
  for c_h=1,height do
    for c_w=1,width do
      for c_d=2,depth do
        turtle.select(1)
        turtle.dig()
        fwd()
        turtle.select(1)
        turtle.digUp()
        turtle.select(1)
        turtle.digDown()
      end
      if c_w~=width then
        next_row(c_w + 1)
      end
    end
    if c_h~=height then
      clean_inventory()
      -- compact_inventory()
      next_layer(c_h + 1)
    end
  end
  clean_inventory()
  print("shaft complete")
  print("fuel remaining: " .. turtle.getFuelLevel())
end

-- program starts here
init()
main()
