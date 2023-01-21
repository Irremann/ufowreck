local MIN_DISTANCE = 400
local MAX_DISTANCE = 1200
local MAX_TRIES = 20

local random_coords = function(pos, min, max)
	if pos == nil then return false end
	min = tonumber(min) or MIN_DISTANCE
	max = tonumber(max) or MAX_DISTANCE
	if min < 1 or max < min then return false end

	local x, y, z
	local count = 0
	repeat
		count = count + 1
		local r = (max - min + 1) * math.sqrt(math.random()) + min
		local theta = math.random() * 2 * math.pi

		x = math.floor(pos.x + r * math.cos(theta))
		z = math.floor(pos.z + r * math.sin(theta))
		y = minetest.get_spawn_level(x, z)

		if y ~= nil then
			local distance = math.sqrt( (pos.x - x)^2 + (pos.y - y)^2 + (pos.z - z)^2 )
			if distance < min or distance > max then y = nil end
		end

	until y ~= nil or count >= MAX_TRIES

	if y ~= nil then
		return {x = x, y = y, z = z}
	else
		return false
	end
end

minetest.register_node("ufowreck:pad", {
	description = "Alien Teleport",
	tiles = {
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png",
		"scifi_nodes_pad.png"
	},
	drawtype = "nodebox",
	paramtype = "light",
	groups = {cracky=1, oddly_breakable_by_hand=1},
	light_source = 5,
	on_rightclick = function(pos, node, clicker)
		minetest.add_particlespawner({
			amount = 25,
			time = 1.5,
			minpos = {x=pos.x-0.9, y=pos.y-0.3, z=pos.z-0.9},
			maxpos = {x=pos.x+0.9, y=pos.y-0.3, z=pos.z+0.9},
			minvel = {x=0, y=0, z=0},
			maxvel = {x=0, y=0, z=0},
			minacc = {x=-0,y=1,z=-0},
			maxacc = {x=0,y=2,z=0},
			minexptime = 0.5,
			maxexptime = 1,
			minsize = 2,
			maxsize = 5,
			collisiondetection = false,
			texture = "scifi_nodes_tp_part.png"
		})
		minetest.after(1, function()
			local new_pos = random_coords(pos, MIN_DISTANCE, MAX_DISTANCE)
			if new_pos then
				minetest.sound_play("travelnet_travel", {pos = pos, gain = 0.75, max_hear_distance = 10,});
				clicker:set_pos( new_pos )
				minetest.log("Player " .. clicker:get_player_name() .. " teleported from " .. minetest.pos_to_string(pos) .. " to " .. minetest.pos_to_string(new_pos))
			else
				minetest.log("Player " .. clicker:get_player_name() .. " at " .. minetest.pos_to_string(pos) .. " was not teleported: number of attempts expired")
			end
		end)
	end,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.9375, -0.5, -0.75, 0.875, -0.375, 0.75}, -- NodeBox1
			{-0.8125, -0.5, -0.875, 0.75, -0.375, 0.875}, -- NodeBox2
			{-0.875, -0.5, -0.8125, 0.8125, -0.375, 0.8125}, -- NodeBox3
			{-0.8125, -0.5, -0.75, 0.75, -0.3125, 0.75}, -- NodeBox4
		},
	sounds = default.node_sound_metal_defaults(),
	}
})

minetest.register_craft({
	output = "ufowreck:pad",
	recipe = {
	{"ufowreck:alien_metal", "ufowreck:alien_metal", "ufowreck:alien_metal"},
	{"ufowreck:alien_metal", "ufowreck:alien_control", "ufowreck:alien_metal"},
	{"ufowreck:alien_metal", "ufowreck:alien_metal", "ufowreck:alien_metal"}
  }
})
