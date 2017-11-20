local HUD = {}

function HUD:init()
	self.imgs = {}
	self.imgs["battery_high"] = love.graphics.newImage("art/battery_high.png")
	self.imgs["battery_medium"] = love.graphics.newImage("art/battery_medium.png")
	self.imgs["battery_low"] = love.graphics.newImage("art/battery_low.png")
	self.imgs["battery_empty"] = love.graphics.newImage("art/battery_empty.png")
	self.imgs["vignette"] = love.graphics.newImage("art/vignette.png")
	self.IMGSCALE = 2
end

function HUD:update(dt)
	if Light.isOn then
		Light.power = Light.power - dt
	end
	if Light.power > Light.fullPower/3*2 then
		Light.powerLevel = "high"
	elseif Light.power > Light.fullPower/3 then
		Light.powerLevel = "medium"
	elseif Light.power > 0 then
		Light.powerLevel = "low"
	else
		Light.powerLevel = "empty"
		Light.isOn = false
	end
end

function HUD:draw()
	love.graphics.setColor(255,255,255,200)
	local activeImg = self.imgs["battery_"..Light.powerLevel]
	local imgX = WIDTH - activeImg:getWidth() * self.IMGSCALE - 20
	love.graphics.draw(activeImg, imgX, 20, 0, self.IMGSCALE, self.IMGSCALE)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(self.imgs["vignette"], 0, 0)
	love.graphics.setColor(240,240,240,255)
	love.graphics.setFont(timeFont)
	local mins = Room.time/60-(Room.time/60)%1
	local hours = mins/60-(mins/60)%1
	mins = mins-hours*60
	if mins < 10 then
		mins = "0"..mins
	end
	hours = "0"..hours
	love.graphics.print(hours..":"..mins.." am", 20, 10)
	local cool = Light.blinkTime+5-(Light.blinkTime+5)%1
	if cool < 0 then
		cool = 0
	end
	love.graphics.print(cool, WIDTH-200, 25)
end

return HUD