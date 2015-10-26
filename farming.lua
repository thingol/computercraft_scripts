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
