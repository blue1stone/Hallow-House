local Room = {}


function Room:init()
self.rooms = {

["r1"] = {
	draw = {
		{ID = "big_drawer", x = 10, y = 350, SCALE = 6},
		{ID = "tv", x = 470, y = 315, SCALE = 7},
		{ID = "drawer", x = 300, y = 530, SCALE = 6},
		{ID = "bed", x = 840, y = 500, SCALE = 7},
		{ID = "painting", x = 720, y = 230, SCALE = 7},
		{ID = "clock", x = 1000, y = 70, SCALE = 4},
		{ID = "window", x = 155, y = 60, SCALE = 7},
	},
	spawners = {
		{SPAWNS = "clown_1", cool = 10, SCARESCALE = 20, activePos = {}},
		{SPAWNS = "clown_2", cool = 30, SCARESCALE = 20, activePos = {}},
		{SPAWNS = "clown_3", cool = 20, SCARESCALE = 20, activePos = {}},
		{SPAWNS = "clown_4", cool = 40, SCARESCALE = 25, activePos = {}},
	},
	positions = {
		["clown_1"] = {
			{xOrig = 30, yOrig = 350, x = 30, y = 350, r=0.1, VEC = {0, -0.25}, END = {0, -130}, SCALE = 4},
			{xOrig = 150, yOrig = 550, x = 150, y = 550, r=math.pi/2, VEC = {0.25, 0}, END = {160, 0}, SCALE = 4},
			{xOrig = 150, yOrig = 400, x = 150, y = 400, r=math.pi/2+0.1, VEC = {0.25, 0}, END = {160, 0}, SCALE = 4},
		},
		["clown_2"] = {
			{xOrig = 850, yOrig = 680, x = 850, y = 680, r=-1.5, VEC = {-0.25, 0}, END = {-120, 0}, SCALE = 3},
			{xOrig = 1200, yOrig = 605, x = 1200, y = 605, r=-math.pi/4, VEC = {0, -0.25}, END = {0, -175}, SCALE = 3},
			{xOrig = 740, yOrig = 230, x = 740, y = 230, r=0, VEC = {0, -0.25}, END = {0, -120}, SCALE = 3},
		},
		["clown_3"] = {
			{xOrig = 550, yOrig = 355, x = 550, y = 355, r=0, VEC = {0, -0.25}, END = {0, -105}, SCALE = 4},
			{xOrig = 670, yOrig = 550, x = 670, y = 550, r=math.pi/2, VEC = {0.25, 0}, END = {130, 0}, SCALE = 4},
			{xOrig = 305, yOrig = 535, x = 305, y = 535, r=0, VEC = {0, -0.25}, END = {0, -110}, SCALE = 4},
		},
		["clown_4"] = {
			{xOrig = 605, yOrig = 50, x = 600, y = 50, r=math.pi/2, VEC = {0.25, 0}, END = {100, 0}, SCALE = 4},
			{xOrig = 135, yOrig = 200, x = 135, y = 200, r=-math.pi/2, VEC = {-0.25, 0}, END = {-100, 0}, SCALE = 4},
			{xOrig = 990, yOrig = 200, x = 990, y = 200, r=-math.pi/2, VEC = {-0.25, 0}, END = {-100, 0}, SCALE = 4},
			{xOrig = 1125, yOrig = 470, x = 1125, y = 470, r=-math.pi, VEC = {0, 0.25}, END = {0, 100}, SCALE = 4},
		},
	},
	wall = {
		IMG = love.graphics.newImage("art/wall.png"),
		SCALE = 5,
	},
	scaringMonster = nil,
},

}

end

function Room:loadRoom(room)
	self.activeRoom = deepcopy(self.rooms[room])
	for i, s in ipairs(self.activeRoom.spawners) do
		local monId = s.SPAWNS
		s.activePos = self.activeRoom.positions[monId][math.random(1,#self.activeRoom.positions[monId])]
	end
	self.time = 0
	Light.power = Light.fullPower
	Light.isOn = false
	Light.blinkTime = -4
end

function Room:update(dt)
	local updateMonsters = true
	if self.activeRoom.scaringMonster then 
		updateMonsters = false
	end
	if updateMonsters then
		for i, s in ipairs(self.activeRoom.spawners) do
			local m = Monster.monsters[s.SPAWNS]
			local W = Monster.monsters[s.SPAWNS]["IMG"]:getWidth() * s.activePos.SCALE
			local H = Monster.monsters[s.SPAWNS]["IMG"]:getHeight() * s.activePos.SCALE
			if not (s.cool > 0) then
				if (check_collision(s.activePos.x, s.activePos.y, W, H, Light.x-Light.W/2, Light.y-Light.H/2, Light.W, Light.H)) and (Light.isBlinking) then
					if s.cool <= 0 then
						local monId = s.SPAWNS
						s.activePos.x = s.activePos.xOrig
						s.activePos.y = s.activePos.yOrig
						s.activePos = self.activeRoom.positions[monId][math.random(1,#self.activeRoom.positions[monId])]
						s.cool = 40
					end
				elseif not ((s.activePos.x-s.activePos.xOrig == s.activePos.END[1]) and (s.activePos.y-s.activePos.yOrig == s.activePos.END[2])) then
					s.activePos.x = s.activePos.x + s.activePos.VEC[1]
					s.activePos.y = s.activePos.y + s.activePos.VEC[2]
				elseif (s.activePos.x-s.activePos.xOrig == s.activePos.END[1]) and (s.activePos.y-s.activePos.yOrig == s.activePos.END[2]) then
					self.activeRoom.scaringMonster = s
					Monster.monsters[self.activeRoom.scaringMonster.SPAWNS]["SCARESOUND"]:play()
				end
			end
			s.cool = s.cool - dt
		end
	elseif not updateMonsters then
		self.activeRoom.scaringMonster.SCARESCALE = self.activeRoom.scaringMonster.SCARESCALE + 0.2
		if self.activeRoom.scaringMonster.SCARESCALE >= 40 then
			inLost = true
		end
	end
	
	
	self.time = self.time + dt*100
	if self.time >= 21600 then
		inPlay = false
		inWin = true
	end
	Light.isBlinking = false
end

function Room:draw()
	love.graphics.setColor(255,255,255,255)
	do
		local wall = self.activeRoom.wall
		local wallW = wall["IMG"]:getWidth() * wall.SCALE
		local wallH = wallW
		for i = 0, WIDTH/wallW do
			for j = 0, HEIGHT/wallH do
				love.graphics.draw(self.activeRoom.wall["IMG"], wallW*i, wallH*j, 0, wall.SCALE, wall.SCALE)
			end
		end
	end
	for i, s in ipairs(self.activeRoom.spawners) do
		love.graphics.draw(Monster.monsters[s.SPAWNS]["IMG"], s.activePos.x, s.activePos.y, s.activePos.r, s.activePos.SCALE, s.activePos.SCALE)
	end
	for i, d in ipairs(self.activeRoom.draw) do
		love.graphics.draw(Object.objects[d.ID]["IMG"], d.x, d.y, 0, d.SCALE, d.SCALE)
	end
	if self.activeRoom.scaringMonster then
		love.graphics.setColor(0,8,22,255)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
		love.graphics.setColor(255,255,255,255)
		local monX = WIDTH / 2 - Monster.monsters[self.activeRoom.scaringMonster.SPAWNS]["IMG"]:getWidth() * self.activeRoom.scaringMonster.SCARESCALE / 2
		local monY = HEIGHT / 4 - 6 * self.activeRoom.scaringMonster.SCARESCALE
		love.graphics.draw(Monster.monsters[self.activeRoom.scaringMonster.SPAWNS]["IMG"], monX, monY, 0, self.activeRoom.scaringMonster.SCARESCALE, self.activeRoom.scaringMonster.SCARESCALE)
	end
end

return Room