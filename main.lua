local Screen = require('src/UsersScreen') --referencia pra classe UserScreen
local myScreen --referencia pra instancia de UserScreen

function love.load()
	myScreen = Screen.new()
end

function love.update(dt)
	myScreen:update(dt)
end

function love.draw()
	myScreen:draw()
end

function love.keypressed(key)
  myScreen:keypressed(key)
end

function love.mousemoved(...)
  myScreen:mousemoved(...)
end

function love.mousepressed(...)
  myScreen:mousepressed(...)
end

function love.mousereleased(...)
  myScreen:mousereleased(...)
end

function love.resize(w,h)
  myScreen:resize(w,h)
end