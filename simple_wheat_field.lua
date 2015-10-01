local sleep_period = 1200

local function process_block ()
  local block_present, block_data = turtle.inspectDown()
  
  if block_present then
    if block_data.name == "minecraft:wheat" then
      if block_data.metadata == 7 then
        print("found one")
        turtle.digDown()
        turtle.select(1)
        turtle.placeDown()
      else
        print("not ready")
      end
    else
      print("we got lost, quitting")
    end
  else
    print("we got lost, quitting")
  end
end


function main_loop () 
  while true do
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.turnRight()
    --
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.turnRight()
    --
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.turnRight()
    --
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.forward()
    process_block()
    turtle.turnRight()
    print("sleeping for " .. sleep_period / 60 .. " minutes")
    sleep(sleep_period)
  end
end
