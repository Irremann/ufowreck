local max_charge = 500000
local power_per_use = max_charge / 50
local power_restore = power_per_use * 0.5

technic.register_power_tool("ufowreck:freezer", max_charge)
technic.register_power_tool("ufowreck:heater", max_charge)
technic.register_power_tool("ufowreck:teleporter", max_charge)

minetest.register_tool("ufowreck:freezer", {
	description = "Freezer",
	inventory_image = "freezer.png",
	paramtype = "light",
	light_source = 12,
	stack_max = 1,
	liquids_pointable = true,
	wear_represents = "technic_RE_charge",
	on_refil = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
	local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge then
			return
		end

	if pointed_thing.type ~= "node" then
		return
	end

	local pos = pointed_thing.under

	if minetest.is_protected(pos, user:get_player_name()) then
		minetest.record_protection_violation(pos, user:get_player_name())
		return
	end

	local charge_to_take = power_per_use
	local node = minetest.get_node(pos)
	local r = 3 -- radius
	
	if meta.charge >= charge_to_take and (not (pos == nil)) then

	-- remove flora (grass, flowers etc.)
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:flora"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "air"})
	end

	-- replace dirt
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:soil"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:permafrost"})
	end

	-- replace water, leaves, tree
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - r, z = pos.z - r},
		{x = pos.x + r, y = pos.y + r, z = pos.z + r},
		{"group:water", "group:leaves", "group:tree", "default:cactus"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:ice"})
	end

	-- replace lava
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - r, z = pos.z - r},
		{x = pos.x + r, y = pos.y + r, z = pos.z + r},
		{"default:lava_source"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:obsidian"})
	end

	-- replace fake_fire:embers
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - r, z = pos.z - r},
		{x = pos.x + r, y = pos.y + r, z = pos.z + r},
		{"fake_fire:embers"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:coalblock"})
	end

	minetest.sound_play({name="blaster_long"},{gain=1,pos=pos,max_hear_distance=20,loop=false})

		meta.charge = meta.charge - charge_to_take
		itemstack:set_metadata(minetest.serialize(meta))
		technic.set_RE_wear(itemstack, meta.charge, max_charge)
		return itemstack
	end
	end,
})

minetest.register_tool("ufowreck:heater", {
	description = "Heater",
	inventory_image = "heater.png",
	paramtype = "light",
	light_source = 12,
	stack_max = 1,
	liquids_pointable = true,
	wear_represents = "technic_RE_charge",
	on_refil = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
	local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge then
			return
		end

	if pointed_thing.type ~= "node" then
		return
	end

	local pos = pointed_thing.under

	if minetest.is_protected(pos, user:get_player_name()) then
		minetest.record_protection_violation(pos, user:get_player_name())
		return
	end

	local charge_to_take = power_per_use
	local node = minetest.get_node(pos)
	local r = 3 -- radius

	if meta.charge >= charge_to_take and (not (pos == nil)) then

	-- remove flora (grass, flowers etc.) and leaves and water
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:water", "group:leaves", "group:flora", "default:snow"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "air"})
	end

	-- replace dirt
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"group:soil"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:sand"})
	end

	-- replace snow and ice
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"default:ice", "default:snowblock", "default:cave_ice"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:water_source"})
	end

	-- replace tree
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - r, z = pos.z - r},
		{x = pos.x + r, y = pos.y + r, z = pos.z + r},
		{"group:tree", "default:cactus"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "fake_fire:embers"})
	end

	-- replace obsidian
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - r, z = pos.z - r},
		{x = pos.x + r, y = pos.y + r, z = pos.z + r},
		{"default:obsidian"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:lava_source"})
	end

	-- replace gravel
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - r, z = pos.z - r},
		{x = pos.x + r, y = pos.y + r, z = pos.z + r},
		{"default:gravel", "default:cobble", "default:mossycobble"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:stone"})
	end

	-- replace permafrost
	local res = minetest.find_nodes_in_area(
		{x = pos.x - r, y = pos.y - 1, z = pos.z - r},
		{x = pos.x + r, y = pos.y + 2, z = pos.z + r},
		{"default:permafrost", "default:permafrost_with_moss", "default:permafrost_stones", "default:dirt_with_snow"})
	
	for n = 1, #res do
		minetest.swap_node(res[n], {name = "default:dirt_with_grass"})
	end

	minetest.sound_play({name="blaster_long"},{gain=1,pos=pos,max_hear_distance=20,loop=false})

		meta.charge = meta.charge - charge_to_take
		itemstack:set_metadata(minetest.serialize(meta))
		technic.set_RE_wear(itemstack, meta.charge, max_charge)
		return itemstack
	end
	end,
})

minetest.register_tool("ufowreck:teleporter", {
	description = "Teleporter",
	inventory_image = "teleporter.png",
	paramtype = "light",
	light_source = 12,
	stack_max = 1,
	liquids_pointable = true,
	wear_represents = "technic_RE_charge",
	on_refil = technic.refill_RE_charge,
	range = 200,
	on_use = function(itemstack, user, pointed_thing)
		local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge then
			return
		end
		local charge_to_take = power_per_use		

	if meta.charge >= charge_to_take then		
		local failure = false
		if(pointed_thing.type == "node") then
			failure = not teleport(user, pointed_thing)
		else
			failure = true
		end
		if failure then
			minetest.sound_play( {name="teletool_fail", gain=0.5}, {pos=user:getpos(), max_hear_distance=4}, true)
		end

		meta.charge = meta.charge - charge_to_take
		itemstack:set_metadata(minetest.serialize(meta))
		technic.set_RE_wear(itemstack, meta.charge, max_charge)
		return itemstack
	end
	end,
})

function teleport(player, pointed_thing)
	local pos = pointed_thing.above
	local src = player:getpos()
	local dest = {x=pos.x, y=math.ceil(pos.y)-0.5, z=pos.z}
	local over = {x=dest.x, y=dest.y+1, z=dest.z}
	local destnode = minetest.get_node({x=dest.x, y=math.ceil(dest.y), z=dest.z})
	local overnode = minetest.get_node({x=over.x, y=math.ceil(over.y), z=over.z})

	-- This trick prevents the player's head to spawn in a walkable node if the player clicked on the lower side of a node
	-- NOTE: This piece of code must be updated as soon the collision boxes of players become configurable
	if minetest.registered_nodes[overnode.name].walkable then
		dest.y = dest.y - 1
	end

	-- The destination must be collision free
	destnode = minetest.get_node({x=dest.x, y=math.ceil(dest.y), z=dest.z})
	if minetest.registered_nodes[destnode.name].walkable then
		return false
	end

	minetest.add_particlespawner({
		amount = 25,
		time = 0.1,
		minpos = {x=src.x-0.4, y=src.y+0.25, z=src.z-0.4},
		maxpos = {x=src.x+0.4, y=src.y+0.75, z=src.z+0.4},
		minvel = {x=-0.1, y=-0.1, z=-0.1},
		maxvel = {x=0, y=0.1, z=0},
		minexptime=1,
		maxexptime=1.5,
		minsize=1,
		maxsize=1.25,
		texture = "teletool_particle_departure.png",
	})
	minetest.sound_play( {name="teletool_teleport1", gain=1}, {pos=src, max_hear_distance=12}, true)

	player:setpos(dest)
	minetest.add_particlespawner({
		amount = 25,
		time = 0.1,
		minpos = {x=dest.x-0.4, y=dest.y+0.25, z=dest.z-0.4},
		maxpos = {x=dest.x+0.4, y=dest.y+0.75, z=dest.z+0.4},
		minvel = {x=0, y=-0.1, z=0},
		maxvel = {x=0.1, y=0.1, z=0.1},
		minexptime=1,
		maxexptime=1.5,
		minsize=1,
		maxsize=1.25,
		texture = "teletool_particle_arrival.png",
	})
	minetest.after(0.5, function(dest) minetest.sound_play( {name="teletool_teleport2", gain=1}, {pos=dest, max_hear_distance=12}, true) end, dest)

	return true
end


minetest.register_tool("ufowreck:broken_raygun", {
    description = "Broken Raygun",
    inventory_image = "amcaw_raygun.png",
	paramtype = "light",
	light_source = 12,
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		minetest.chat_send_player(user:get_player_name(), "This raygun is broken.")
	end,
})
	
minetest.register_craft({
	output = "ufowreck:freezer",
	recipe = {
	{"ufowreck:broken_raygun", "default:ice", "ufowreck:broken_raygun"},
	{"default:bronze_ingot", "technic:blue_energy_crystal", ""},
	{"ufowreck:broken_raygun", "", ""}
  }
})

minetest.register_craft({
	output = "ufowreck:heater",
	recipe = {
	{"ufowreck:broken_raygun", "bucket:bucket_lava", "ufowreck:broken_raygun"},
	{"default:bronze_ingot", "technic:red_energy_crystal", ""},
	{"ufowreck:broken_raygun", "", ""}
  }
})

minetest.register_craft({
	output = "ufowreck:teleporter",
	recipe = {
	{"ufowreck:broken_raygun", "pipeworks:teleport_tube_1", "ufowreck:broken_raygun"},
	{"default:bronze_ingot", "basic_materials:energy_crystal_simple", ""},
	{"ufowreck:broken_raygun", "", ""}
  }
})
