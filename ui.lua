local UI = {labels={}, buttons={}, deco={}}

function UI:new()
	local res = {}
	setmetatable(res, self)
	self.__index = self
	res.labels = {}
	res.buttons = {}
	res.deco = {}
	return res
end

function UI.new_button(x, y, imgPath, action, scale)
	local res = {}
	res.x = x
	res.y = y
	res.tex = love.graphics.newImage(imgPath)
	res.scale = scale or 0
	res.w = res.tex:getWidth()*res.scale
	res.h = res.tex:getHeight()*res.scale
	res.action = action or function () print("No action defined.") end
	return res
end

function UI.new_label(x, y, text, color, font, align)
	res = {}
	res.x = x
	res.y = y
	res.text = text or "No text given"
	res.color = color or {255,0,255}
	res.font = font or defaultFont
	res.align = align or "left"
	return res
end

function UI.new_deco(x, y, w, h, color, mode)
	local res = {}
	res.x = x
	res.y = y
	res.w = w
	res.h = h
	res.color = color
	res.mode = mode or "fill"
	return res
end

--========================================--
-- This function has been taken from https://love2d.org/wiki/BoundingBox.lua
function UI.check_collision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end
--========================================--

function UI:draw_labels()
	for i, l in ipairs(self.labels) do
		local text = l.text
		local textOffX = 0
		local textOffY = 0
		if l.align == "right" then
			textOffX = l.font:getWidth(text)
		elseif l.align == "center" then
			textOffX = l.font:getWidth(text)/2
		end
		love.graphics.setColor(l.color)
		love.graphics.setFont(l.font)
		love.graphics.print(text, l.x-textOffX, l.y-textOffY)
	end
end

function UI:draw_buttons()
	love.graphics.setColor(255,255,255)
	for i, b in ipairs(self.buttons) do
		love.graphics.draw(b.tex, b.x, b.y, 0, b.scale, b.scale)
	end
end

function UI:draw_deco()
	for i, d in ipairs(self.deco) do
		love.graphics.setColor(d.color)
		love.graphics.rectangle(d.mode, d.x, d.y, d.w, d.h)
	end
end

function UI:update_buttons(mouseX, mouseY)
	for i, b in ipairs(self.buttons) do
		if self.check_collision(b.x, b.y, b.w, b.h, mouseX, mouseY, 1, 1) then
			b.action()
		end
	end
end

function UI:draw()
	if self.deco[1] ~= nil then
		self:draw_deco()
	end
	if self.buttons[1] ~= nil then
		self:draw_buttons()
	end
	if self.labels[1] ~= nil then
		self:draw_labels()
	end
end

function UI:update(mouseX, mouseY)
	if self.buttons[1] ~= nil then
		self:update_buttons(mouseX, mouseY)
	end
end

return UI