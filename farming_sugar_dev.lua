-- TODO: adapt for crops of heights other than one, e.g. sugar cane
-- TODO: create better output during a run

local function next_bed ()
  turtle.back()
  for i=1,4 do turtle.up() end
  turtle.forward()
end

local function process_block ()
  turtle.dig()
  turtle.suck()
  turtle.suckDown()
end

local function process_row (length)
  for i=1,length do
    process_block()
    turtle.forward()
  end
  turtle.turnRight()
end

local function process_bed (side0, side1)
  process_row(side0)
  process_row(side1)
  process_row(side0)
  process_row(side1)
end

local function return_to_start (beds)
  turtle.back()
  for i=1,(beds-1)*4 do
    turtle.down()
  end
  turtle.forward()
end

function farm (beds, side0, side1, sleep_period)
  while true do
    process_bed(side0, side1)
    for i=2,beds do
      next_bed()
      process_bed(side0, side1)
    end
    if beds > 1 then
      return_to_start(beds)
    end
    if sleep_period ~= 0 then
      print("sleeping for " .. sleep_period / 60 .. " minutes")
      sleep(sleep_period)
    end
  end
end
