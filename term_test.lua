local status =
  window.create(term.current(), 1, 1, 51, 3)
local main =
  window.create(term.current(), 1, 4, 51, 16)
  
term.clear()

status.write("Layer: " .. 9 .. ", row: " ..  20 .. ", column: " .. 8)

main.setCursorPos(4,4)
main.write("bla bla")
