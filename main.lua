love.graphics.setDefaultFilter("nearest")
math.randomseed(os.time())
Object = require("object")
Monster = require("monster")
Light = require("light")
Room = require("room")
HUD = require("hud")
UI = require("ui")
DEBUG = false

--========================================--
-- This function has been taken from https://love2d.org/wiki/BoundingBox.lua
function check_collision(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1 < x2+w2 and
	x2 < x1+w1 and
	y1 < y2+h2 and
	y2 < y1+h1
end
--========================================--

--========================================--
-- This function has been taken from http://lua-users.org/wiki/CopyTable
function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
--========================================--

function love.load()
	love.window.setTitle("Hallow House")
	love.window.setMode(1280, 720)
	WIDTH, HEIGHT = love.window.getMode()
	
	-- vars
	inMenu = true
	inPlay = false
	inWin = false
	inLost = false
	
	-- fonts
	menuFont = love.graphics.newFont(100)
	timeFont = love.graphics.newFont(40)
	nameFont = love.graphics.newFont(25)
	
	HUD:init()
	Light:init()
	Monster:init()
	Room:init()
	love.graphics.setBackgroundColor(0,20,55, 255)
	
	Menu = UI:new()
	Menu.labels[1] = UI.new_label(WIDTH/2+35, HEIGHT/2+20, "PLAY", {250,50,50,255}, menuFont, "center")
	Menu.labels[2] = UI.new_label(10, 10, "by Elias aka. BlueStone", {250,190,50,255}, nameFont, "left")
	Menu.buttons[1] = UI.new_button(WIDTH/2-125, HEIGHT/2, "art/button.png", function() inMenu = false; inInst = true end, 5)
	
	Win = UI:new()
	Win.labels[1] = UI.new_label(WIDTH/2, 5, "Congratulations!", {250,50,50,255}, menuFont, "center")
	Win.labels[2] = UI.new_label(WIDTH/2, HEIGHT/5*1+5, "You survived!", {250,50,50,255}, menuFont, "center")
	Win.labels[3] = UI.new_label(WIDTH/2, HEIGHT/5*2+5, "But always beware...", {250,50,50,255}, menuFont, "center")
	Win.labels[4] = UI.new_label(WIDTH/2, HEIGHT/5*3+5, "Happy Halloween!", {250,50,50,255}, menuFont, "center")
	Win.labels[5] = UI.new_label(WIDTH/2, HEIGHT/5*4+5, "MENU", {250,50,50,255}, menuFont, "center")
	Win.buttons[1] = UI.new_button(WIDTH/2-160, HEIGHT/5*4-5+5, "art/button.png", function() inMenu = true; inWin = false end, 5)
	
	Lost = UI:new()
	Lost.labels[1] = UI.new_label(WIDTH/2, 50, "You lost!", {10,10,10,255}, menuFont, "center")
	Lost.labels[2] = UI.new_label(WIDTH/2, HEIGHT/4*1+50, "Do you risk", {10,10,10,255}, menuFont, "center")
	Lost.labels[3] = UI.new_label(WIDTH/2, HEIGHT/4*2+50, "another try?", {10,10,10,255}, menuFont, "center")
	Lost.labels[4] = UI.new_label(WIDTH/2, HEIGHT/4*3+50, "MENU", {10,10,10,255}, menuFont, "center")
	Lost.buttons[1] = UI.new_button(WIDTH/2-160, HEIGHT/4*3+50-5, "art/button.png", function() inLost = false; inPlay = false; inMenu = true end, 5)
	
	Inst = UI:new()
	Inst.labels[1] = UI.new_label(WIDTH/2, 5, "INSTRUCTIONS", {250,50,50,255}, menuFont, "center")
	Inst.labels[2] = UI.new_label(WIDTH/2, HEIGHT/7*1+5, "Use your flashlight", {250,50,50,255}, menuFont, "center")
	Inst.labels[3] = UI.new_label(WIDTH/2, HEIGHT/7*2+5, "to flash the monsters.", {250,50,50,255}, menuFont, "center")
	Inst.labels[4] = UI.new_label(WIDTH/2, HEIGHT/7*3+5, "Watch your battery and", {250,50,50,255}, menuFont, "center")
	Inst.labels[5] = UI.new_label(WIDTH/2, HEIGHT/7*4+5, "survive until 6am.", {250,50,50,255}, menuFont, "center")
	Inst.labels[6] = UI.new_label(WIDTH/2, HEIGHT/7*5+5, "Good luck...", {250,50,50,255}, menuFont, "center")
	Inst.labels[7] = UI.new_label(WIDTH/2, HEIGHT/7*6+5, "START", {250,50,50,255}, menuFont, "center")
	Inst.buttons[1] = UI.new_button(WIDTH/2-160, HEIGHT/7*6+5-5, "art/button.png", function() inInst = false; inPlay = true; Room:loadRoom("r1") end, 5)
	
	Play = UI:new()
	Play.buttons[1] = UI.new_button(5, HEIGHT/2+35, "art/button_light.png", function() if Light.power>0 then Light.isOn = not Light.isOn; Light.toggleSound:play(); end end, 5)
	Play.buttons[2] = UI.new_button(5, HEIGHT/2+HEIGHT/4+20, "art/button_blink.png", function() if (Light.power > 0) and (Light.blinkTime <= -4) and (Light.isOn) then Light:blink(); Light.blinkSound:play(); end end, 5)
	
end

function love.touchpressed(id, x, y)
	local mouseX, mouseY = x, y
	if inPlay then
		if not Room.activeRoom.scaringMonster then
			Play:update(mouseX, mouseY)
		end
	end
	if inMenu then
		Menu:update(mouseX, mouseY)
	end
	if inWin then
		Win:update(mouseX, mouseY)
	end
	if inLost then
		Lost:update(mouseX, mouseY)
	end
	if inInst then
		Inst:update(mouseX, mouseY)
	end
end

function love.update(dt)
	local touches = love.touch.getTouches()
	local mouseX, mouseY
	if touches[1] then
		mouseX, mouseY = love.touch.getPosition(touches[1])
	end
	if inPlay then
		if touches[1] then
			if (mouseX < 165) and (mouseY > HEIGHT/2+35) then
				mouseX = nil
				mouseY = nil
			end
		end
		Room:update(dt)
		Light:update(mouseX, mouseY, dt)
		HUD:update(dt)
	end
end

function love.draw()
	if inPlay then
		Room:draw()
		if not DEBUG then
			if not Room.activeRoom.scaringMonster then
				Light:draw()
			end
		end
		if not Room.activeRoom.scaringMonster then
			HUD:draw()
			Play:draw()
		end
	end
	if inMenu then
		love.graphics.setColor(Light.BGCOLOR)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		Menu:draw()
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(Object.objects["logo"]["IMG"], 480, 20, 0, 6, 7)
		love.graphics.draw(Monster.monsters["clown_1"]["IMG"], 780, 220, 0, 16, 16)
		love.graphics.draw(Monster.monsters["clown_2"]["IMG"], 1, 90, 0, 16, 16)
	end
	if inWin then
		love.graphics.setColor(20,28,42, 255)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		Win:draw()
	end
	if inLost then
		love.graphics.setColor(150,20,20, 255)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		Lost:draw()
	end
	if inInst then
		love.graphics.setColor(Light.BGCOLOR)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		Inst:draw()
	end
end