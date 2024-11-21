require("red-wizard-utilities")

local function setRocketRecipe(machine)



end

local function onTick(event)
	if storage.initialized == false or storage.initialized==nil then
--		rw_entity.track({name = "rubber-ducky-factory"})
		rw_entity.init()
		storage.initialized = true
	end
	storage.rw_entity_data = storage.rw_entity_data or {}
	if storage.rw_entity_data['rubber-ducky-factory'] ~= nil then
		ducky_factories = storage.rw_entity_data['rubber-ducky-factory'].entities
	end
	if ducky_factories ~= nil then
		for _,machine in pairs(ducky_factories) do
			if machine.valid then
				storage.rocket_factories = storage.rocket_factories or {}
				--insert the proto ducky when rocket is ready
				local new_status = machine.rocket_silo_status
				if machine.rocket_silo_status == defines.rocket_silo_status.rocket_ready
				and storage.rocket_factories[machine.unit_number] ~= nil
				and machine.rocket_silo_status ~= storage.rocket_factories[machine.unit_number].status
				then
					debugger("rocket " .. machine.rocket_silo_status)
					--machine.launch_rocket()
					local output_inventory = machine.get_inventory(defines.inventory.rocket_silo_rocket)
					if output_inventory.valid then
						output_inventory.insert({name="proto-ducky"})
						--output_inventory.resize(0)
					else
						--delay to next tick
						new_status = storage.rocket_factories[machine.unit_number].status
					end
					--local output_inventory = machine.get_inventory(defines.inventory.rocket_silo_result)
					--output_inventory.insert({name="rubber-ducky"});
				end
				if storage.rocket_factories[machine.unit_number] == nil then
					storage.rocket_factories[machine.unit_number] = {}
				end
				storage.rocket_factories[machine.unit_number].status = new_status
			end
		end
	end

end

script.on_configuration_changed(function()
	debugger("Tracking sweatshops")
	
	rw_entity.init()
end)

--storage.initialized = false
rw_entity.track({name = "rubber-ducky-factory"})

-- script.on_event(defines.events.on_player_joined_game,function()
	-- debugger("Tracking sweatshops")
	-- rw_entity.track({name = "rubber-ducky-factory"})
	-- --rw_entity.init()
	-- storage.initialized = true
-- end)


local initialized = false



script.on_event(defines.events.on_tick, onTick)

