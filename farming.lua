-- TODO: adapt for crops of heights other than one, e.g. sugar cane
-- TODO: create better output during a run

local function next_bed ()
  turtle.back()
  for i=1,3 do turtle.up() end
  turtle.forward()
end

local function process_block (fname)
  local block_present, block_data = turtle.inspectDown()

  if block_present then
    if block_data.name == "minecraft:" .. fname then
      if block_data.metadata == 7 then
        print("found one")
        turtle.digDown()
        turtle.select(1)
        turtle.placeDown()
      end
    end
  end
end

local function process_row (length, fname)
  for i=1,length do
    process_block(fname)
    turtle.forward()
  end
  turtle.turnRight()
end

local function process_bed (side0, side1, fname)
  process_row(side0, fname)
  process_row(side1, fname)
  process_row(side0, fname)
  process_row(side1, fname)
end

local function return_to_start (beds)
  turtle.back()
  for i=1,(beds-1)*3 do
    turtle.down()
  end
  turtle.forward()
end

function farm (beds, side0, side1, sleep_period, fname)
  while true do
    process_bed(side0, side1, fname)
    for i=2,beds do
      next_bed()
      process_bed(side0, side1, fname)
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
