--  The MIT License (MIT)
--  Copyright © 2016 Pietro Ribeiro Pepe.

--  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
--  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- IN CONSTRUCTION

local ScreenTransition = require ((...):match("(.-)[^%.]+$").."class").new("ScreenTransition")

local types = {
	fadeOutIn = {
		start = function(self)
			self._shader = require('lib/shader').fade
			self._shader:send('alpha',1)
			love.graphics.setShader(self._shader)
		end,
		update = function(self,dt)
			self._v = math.abs((self.timer-self.time/2)/(self.time/2))
		end,
		draw = function(self)
			self._shader:send('alpha',self._v)
			if self.timer>self.time/2 then
				self.fromScreen:draw()
			else
				self.toScreen:draw()
			end
		end
	},
	fadeCross = {
		start = function(self)
			self._shader = require('lib/shader').fade
			self._shader:send('alpha',1)
			love.graphics.setShader(self._shader)
		end,
		update = function(self,dt)
			self._v = self.timer/self.time
		end,
		draw = function(self)
			self._shader:send('alpha',self._v)
			self.fromScreen:draw()
			self._shader:send('alpha',1-self._v)
			self.toScreen:draw()
		end
	}
}

function ScreenTransition.new(menuBg, fromScreen, toScreen, time, id, direction, callback)
	local self = ScreenTransition.newObject()
  local dir = direction and direction or -1
	self.screens = {menuBg,fromScreen,toScreen}
  
  self.menuBg = menuBg
  self.fromScreen = fromScreen
  self.toScreen = toScreen
  
	fromScreen:setInteraction(false)
	toScreen:setInteraction(false)

	toScreen.view.y = -dir*love.graphics.getHeight()
	self.speed = -toScreen.view.y/time

  	self.callback = callback
  	self.timer = time
  	self.time = time
  	self.id = id
  	--types[id].start(self)
	return self
end

function ScreenTransition:update(dt)
	--[[
	self.timer = math.max(self.timer - dt,0)
	types[self.id].update(self,dt)
	if self.timer == 0 then
		love.graphics.setShader()
		if self.callback then self.callback() end
		self.toScreen:setInteraction(true)
	end]]
  self.timer = math.max(self.timer - dt,0)
	
	for i=1,#self.screens do self.screens[i]:update(dt) end
  if self.time > 0 then 
    self.menuBg.view.y = self.menuBg.view.y + self.speed*dt
  end
	self.toScreen.view.y = self.toScreen.view.y+self.speed*dt
  self.fromScreen.view.y = self.fromScreen.view.y+self.speed*dt
  if self.timer <= 0 then
    --self.menuBg.view.y = 0
    self.toScreen.view.y = 0
		self.toScreen:setInteraction(true)
		if self.callback then self.callback() end
  end
end

function ScreenTransition:draw()
	--local im = self.screens[2].background.image
	--self.screens[2].background.image = nil
	--Mover essas duas linhas para o setup das screens!!
	--self.screens[2].background.backgroundColor[4] = 0
	--self.screens[2].view.backgroundColor[4] = 0
	--
	for i,v in ipairs(self.screens) do v:draw() end
	--self.screens[2].background.image = im
end

function ScreenTransition:mousepressed(x,y,b)
end
function ScreenTransition:mousemoved(x,y,dx,dy)
end
function ScreenTransition:mousereleased(x,y,b)
end
function ScreenTransition:keypressed(...)
end

return ScreenTransition