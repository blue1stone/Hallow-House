local Light = {}

function Light:init()
	self.isOn = false
	self.x = WIDTH / 2
	self.y = HEIGHT / 2
	self.IMG = love.graphics.newImage("art/light.png")
	self.SCALE = 7
	self.W = self.IMG:getWidth() * self.SCALE
	self.H = self.IMG:getHeight() * self.SCALE
	self.BGCOLOR = {0,8,22, 254}
	self.LIGHTCOLOR = {250,250,255,254}
	self.blinkTime = -4
	self.isBlinking = false
	self.fullPower = 330
	self.power = self.fullPower
	self.powerLevel = "high"
	self.toggleSound = love.audio.newSource("sound/flash.wav", "static")
	self.blinkSound = love.audio.newSource("sound/blink.wav", "static")
end

function Light:blink()
	self.blinkTime = 2.5
	self.power = self.power - 2
	self.isBlinking = true
end

function Light:update(mouseX, mouseY, dt)
	self.x = mouseX or self.x
	self.y = mouseY or self.y
	self.blinkTime = self.blinkTime - dt
end

function Light:draw()
	if self.isOn then
		love.graphics.setColor(self.LIGHTCOLOR)
		love.graphics.draw(self.IMG, self.x-self.W/2, self.y-self.H/2, 0, self.SCALE, self.SCALE)
		love.graphics.setColor(self.BGCOLOR)
		love.graphics.rectangle("fill", self.x-WIDTH, self.y-HEIGHT, WIDTH*2, HEIGHT-self.H/2)
		love.graphics.rectangle("fill", self.x-WIDTH, self.y+self.H/2, WIDTH*2, HEIGHT-self.H/2)
		love.graphics.rectangle("fill", self.x-WIDTH, self.y-self.H/2, WIDTH-self.W/2, self.H)
		love.graphics.rectangle("fill", self.x+self.W/2, self.y-self.H/2, WIDTH-self.W/2, self.H)
	elseif not self.isOn then
		love.graphics.setColor(self.BGCOLOR)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	end
	if self.blinkTime > 0 then
		love.graphics.setColor(250,250,255,100*self.blinkTime)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	end
end

return Light