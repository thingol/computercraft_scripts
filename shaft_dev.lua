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
  print("  shaft.lua <height> <width> <depth>")
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

-- utility functions
local function fwd ()
  local retval = turtle.forward()
  
  if not retval then
    while turtle.dig() do end
    turtle.forwad()
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
  turtle.forward()
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
  print("digging shaft with dimensions: " .. height*3 .. "x" .. width .. "x" .. depth .. " (HxWxD)")
  turtle.dig()
  turtle.forward()
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
        turtle.forward()
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