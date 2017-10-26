local Monster = {}

function Monster:init()
self.monsters = {

["clown_1"] = {
		IMG = love.graphics.newImage("art/clown_1.png"),
		SCARESOUND = love.audio.newSource("sound/clown_1.wav", "static")
	},
["clown_2"] = {
		IMG = love.graphics.newImage("art/clown_2.png"),
		SCARESOUND = love.audio.newSource("sound/clown_2.wav", "static")
	},
["clown_3"] = {
		IMG = love.graphics.newImage("art/clown_3.png"),
		SCARESOUND = love.audio.newSource("sound/clown_3.wav", "static")
	},
["clown_4"] = {
		IMG = love.graphics.newImage("art/clown_4.png"),
		SCARESOUND = love.audio.newSource("sound/clown_4.wav", "static")
	},

}
end

return Monster