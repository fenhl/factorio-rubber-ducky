--v1.4

rw_util = {}

function dump(o,tabs)
	if tabs == nil then
		tabs = 0
	end
	
	local s = ''
	
	if type(o) == 'table' then
		local pad = ''
		for a=1, tabs do
			pad = pad .. ' '
		end 
		s = s .. '\n' .. pad .. '{\n'
		for k,v in pairs(o) do
			s = s .. pad .. '  ['..k..'] = ' .. dump(v,tabs+2) .. '\n'
		end
		return s .. pad .. '}'
		else 
			if type(o) == 'string' then
				return s .. '"' .. tostring(o) .. '"'
			elseif type(o) == 'number' then
				return s .. tostring(o)
			else
				return s .. type(o) .. ' ' .. tostring(o)
		end
	end
end

function ifmod(modname)
	if mods and mods[modname] then
		return true
	end
	if game and game.active_mods[modname] then
		return true
	end
	return false
end

rw_util.ammo_category = function(name)
  if not data.raw["ammo-category"][name] then
    data:extend{{type = "ammo-category", name = name, localised_name = {name}}}
  end
  return name
end

if ifmod("stdlib2") then
	if string == nil then
		string = require('__stdlib2__/stdlib/utils/string')
	end
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end
function string.ends(String,Ends)
   return string.sub(String,0 - string.len(Ends))==Ends
end

function count(the_table)
	local i = 0
	for _ in pairs(the_table) do
		i = i + 1
	end
	return i
end
--do_debugger =1
function debugger(t)
	if do_debugger == nil then return end
	if type(t) == "table" then
		t = dump(t)
	end
	if game ~= nil then
		if t == nil then
			t = "nil"
		end
		game.print("DEBUGGER " .. t)
	end
	log("DEBUGGER " .. t)
end


--
-- Red Wizard Entity Tracker
--
if rw_entity == nil then
	rw_entity = {}
	rw_entity.data = {}
	--storage.rw_entity_data = {}
end

rw_entity.onPlaceEntity = function (event)
	if storage.rw_entity_data == nil then return end;
	local entity = event.created_entity or event.entity
	debugger("rw_entity.onPlaceEntity " .. entity.name)
	for name,data in pairs(storage.rw_entity_data) do
		if data.names[entity.name] ~= nil then
			data.entities[entity.unit_number] = entity
			if data.place_callback ~= nil then
				data.place_callback(entity)
			end
			debugger(name .. ": " .. table_size(data.entities))
		end
	end
end

rw_entity.onRemoveEntity = function (event)
	--debugger("rw_entity.onRemoveEntity")
	local entity = event.entity
	if storage.rw_entity_data == nil then return end;
	for name,data in pairs(storage.rw_entity_data) do
		if data.names[entity.name] ~= nil then
			if data.entities ~= nil then
				data.entities[entity.unit_number] = nil
			end
			if data.remove_callback ~= nil then
				data.remove_callback(entity)
			end
		end
		--debugger(dump(data))
	end
end

rw_entity.init = function (event)
	debugger("rw_entity.init")

	storage.rw_entity_data = {}
	for name,data in pairs(rw_entity.data) do
		if storage.rw_entity_data[name] == nil then
			storage.rw_entity_data[name] = data
		end
	end
	debugger(storage.rw_entity_data)
	for name,data in pairs(storage.rw_entity_data) do
		
		data.entities = {}
		for _,surface in pairs(game.surfaces) do
		
			local entities = surface.find_entities_filtered{name = data.names}
			--debugger(#rubber_ducky_machines)
			for _,entity in pairs(entities) do
				data.entities[entity.unit_number] = entity
			end
		end
	end
end

rw_entity.track = function (data)  -- name, names, entities, place_callback, remove_callback
	if data.names == nil then
		data.names = {}
		data.names[data.name] = data.name
	else
		local new_names = {}
		for _,name in pairs(data.names) do
			new_names[name] = name
		end
		data.names = new_names
	end
	if rw_entity.data == nil then
		rw_entity.data = {}
	end
	if rw_entity.data[data.name] == nil then
		rw_entity.data[data.name] = {}
	end
	rw_entity.data[data.name].name = data.name
	rw_entity.data[data.name].names = data.names
	rw_entity.data[data.name].place_callback = data.place_callback
	rw_entity.data[data.name].remove_callback = data.remove_callback
	
	if rw_entity.data[data.name].entities == nil then
		rw_entity.data[data.name].entities = {}
	end
	debugger("tracking " .. data.name)
	debugger(rw_entity.data)
	if event_handler ~= nil then
		event_handler.add_lib({events = {
			[defines.events.on_built_entity] = rw_entity.onPlaceEntity,
			[defines.events.on_robot_built_entity] = rw_entity.onPlaceEntity,
			[defines.events.script_raised_revive] = rw_entity.onPlaceEntity,
			[defines.events.script_raised_built] = rw_entity.onPlaceEntity,
			[defines.events.on_entity_spawned] = rw_entity.onPlaceEntity,
		}})
		event_handler.add_lib({events = {
			[defines.events.on_pre_player_mined_item] = rw_entity.onRemoveEntity,
			[defines.events.on_robot_pre_mined] = rw_entity.onRemoveEntity,
			[defines.events.on_entity_died] = rw_entity.onRemoveEntity,
			[defines.events.script_raised_destroy] = rw_entity.onRemoveEntity,
		}})		
		event_handler.add_lib({on_configuration_changed = rw_entity.init})
		--event_handler.add_lib({on_load = rw_entity.init})
	else
		script.on_event({defines.events.on_built_entity,
									 defines.events.on_robot_built_entity,
									 defines.events.script_raised_revive,
									 defines.events.script_raised_built,
									 --defines.events.on_entity_cloned,
									 defines.events.on_entity_spawned,
									}, rw_entity.onPlaceEntity)

		script.on_event({defines.events.on_pre_player_mined_item,
									 defines.events.on_robot_pre_mined,
									 defines.events.on_entity_died,
									 defines.events.script_raised_destroy,
									}, rw_entity.onRemoveEntity)
		--script.on_configuration_changed(rw_entity.init)
	end
end

--
-- END Red Wizard Entity Tracker
--

--
-- Red Wizard Tools
--
if rw_tools == nil then
	rw_tools = {}
end
--clones entity, item, and recipe
rw_tools.deep_entity_clone = function(entity,new_name)
	local object = {}
	object.entity = util.table.deepcopy(entity)
	object.entity.name = new_name

	if object.entity.minable.result ~= nil then
		object.item = util.table.deepcopy(data.raw['item'][object.entity.minable.result])
		orig_item_name = object.item.name
		object.item.name = new_name
		object.entity.minable.result = new_name
		object.item.place_result = new_name
	end
	
	if object.item ~= nil then
		if data.raw['recipe'][orig_item_name] ~= nil then
			object.recipe = util.table.deepcopy(data.raw['recipe'][orig_item_name])
		end
	end
	if object.recipe ~= nil then
		orig_recipe_name = object.recipe.name
		object.recipe.name = new_name
		object.recipe.result = new_name
	end
	
	for key,tech in pairs(data.raw['technology']) do
		if tech.effects ~= nil then
			for _,unlock in pairs(tech.effects) do
				if unlock.type == "unlock-recipe" and unlock.recipe == orig_recipe_name then

					table.insert(data.raw['technology'][key].effects, {type="unlock-recipe",recipe=new_name})
				end
			end
		end
	end
	return object
end


rw_tools.shift_circuit_point = function(entity,x,y)
	local cp = entity.circuit_wire_connection_point 
	for _,cpw in pairs(entity.circuit_connector_sprites) do
		if cpw.shift ~= nil then
			cpw.shift[1] = cpw.shift[1]+x
			cpw.shift[2] = cpw.shift[2]+y
		end
	end
	cp.wire.red[1] = cp.wire.red[1] + x
	cp.shadow.red[1] = cp.shadow.red[1] + x
	cp.wire.green[1] = cp.wire.green[1] + x
	cp.shadow.green[1] = cp.shadow.green[1] + x
	cp.wire.red[2] = cp.wire.red[2] + y
	cp.shadow.red[2] = cp.shadow.red[2] + y
	cp.wire.green[2] = cp.wire.green[2] + y
	cp.shadow.green[2] = cp.shadow.green[2] + y
end

rw_tools.get_recipe_tech = function(name)
	for key,tech in pairs(data.raw['technology']) do
		if tech.effects ~= nil then
			for _,unlock in pairs(tech.effects) do
				if unlock.type == "unlock-recipe" and unlock.recipe == name then
					return tech
				end
			end
		end
	end
	return nil
end

rw_tools.round = function(value,prec)


end

rw_tools.extend_or_update = function(objs)
	for _,obj in pairs(objs) do
		log("checking for collisions " .. obj.type .. " " .. obj.name);
		local existing = nil
		if data.raw[obj.type][obj.name] ~= nil then
			log("collision detected with " .. obj.name .. "(" .. obj.type .. ")")
			data.raw[obj.type][obj.name] = obj
		else
			data:extend({obj})
		end
		
	end
end


--
-- END Red Wizard Tools
--