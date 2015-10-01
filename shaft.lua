local function print_usage()
  print("\nUsage:")
  print("  shaft.lua <height> <width> <depth>")
end

local height
local width
local depth

local last_sn_goods = 0
local junk = {
            ["minecraft:cobblestone"] = true,
            ["minecraft:dirt"] = true,
            ["minecraft:gravel"] = true, 
      }

local dir_fn = {
            ["left"] = turtle.turnLeft,
            ["right"] = turtle.turnRight,
      }
local direction="left"

local tArgs = { ... }

if #tArgs < 3 then
  print("\nToo few arguments!\n")
  print_usage()
  return
else
  height = tonumber(math.floor(tArgs[1]/3))
  width = tonumber(tArgs[2])
  depth = tonumber(tArgs[3])
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

-- utility functions
local function next_row (row)
  print("going to row " .. row .. " of " .. width)
  turtle.select(1)
  dir_fn[direction]()
  turtle.dig()
  turtle.forward()
  dir_fn[direction]()
  turtle.digUp()
  turtle.digDown()
  
  if direction == "left" then
    direction = "right"
  else
    direction = "left"
  end
end
  
local function next_layer (layer)
  print("going to layer " .. layer .. " of " .. height)
  turtle.select(1)
  turtle.turnLeft()
  turtle.turnLeft()
  turtle.down()
  turtle.digDown()
  turtle.down()
  turtle.digDown()
  turtle.down()
  turtle.digDown()
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

-- turtle.getItemDetail([number slotNum])
-- turtle.transferTo(number slot [, number quantity])

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
