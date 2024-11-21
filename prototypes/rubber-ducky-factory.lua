local ducky_factory_scale = .3

local function scale_object(object)
	--log(dump(field))
	if object.scale == nil then
		object.scale = 1
	end
	object.scale = object.scale * ducky_factory_scale
	if object.shift ~= nil then
		object.shift[1] = object.shift[1] * ducky_factory_scale
		object.shift[2] = object.shift[2] * ducky_factory_scale
	end
end

local function scale_all(entity)
	for id,field in pairs(entity) do
		--log(id)
		if string.ends(id,"sprite")
		or string.ends(id,"animation")
		or id == "door_animation_up"
		or id == "door_animation_down"
		then
			scale_object(field)
		end
		
		if string.ends(id,"sprites")
		then
			for _,spritelist in pairs(field) do
				for _,sprite in pairs(spritelist) do
					scale_object(sprite)
				end
			end
		end
	end
end

local function scale_numbers(numbers,mult)
	for i,number in pairs(numbers) do
		if type(number) == 'table' then
			scale_numbers(numbers[i])
		end
		if type(number) == 'number' then
			numbers[i] = number * ducky_factory_scale
			if mult ~= nil then
				numbers[i] = numbers[i] * mult
			end
		end
	end
	return numbers
end

local transparent = {
	filename = "__rubber-ducky__/graphics/transparent.png",
	width = 50,
	height = 50
}


local rubber_ducky_factory_entity = util.table.deepcopy(data.raw['rocket-silo']['rocket-silo'])
rubber_ducky_factory_entity.name = "rubber-ducky-factory"
rubber_ducky_factory_entity.rocket_entity = "rocket-ducky"
rubber_ducky_factory_entity.minable = {mining_time = 5, result = "rubber-ducky-factory"}
rubber_ducky_factory_entity.fixed_recipe = nil
rubber_ducky_factory_entity.collision_box = {{-1.2, -1.2}, {1.2, 1.2}}
rubber_ducky_factory_entity.selection_box = {{-1.5, -1.5}, {1.5, 1.5}}

scale_numbers(rubber_ducky_factory_entity.hole_clipping_box)



rubber_ducky_factory_entity.allowed_effects = {"consumption","speed", "pollution"}

scale_all(rubber_ducky_factory_entity)
rubber_ducky_factory_entity.door_back_sprite.filename = "__rubber-ducky__/graphics/door-back.png"
rubber_ducky_factory_entity.door_front_sprite.filename = "__rubber-ducky__/graphics/door-front.png"
rubber_ducky_factory_entity.hole_light_sprite = transparent
rubber_ducky_factory_entity.rocket_glow_overlay_sprite = transparent

rubber_ducky_factory_entity.alarm_sound = nil
rubber_ducky_factory_entity.raise_rocket_sound.filename = "__rubber-ducky__/quack.ogg"
rubber_ducky_factory_entity.times_to_blink = 3
rubber_ducky_factory_entity.door_opening_speed = 2 * 1 / (4.25 * 60)
rubber_ducky_factory_entity.light_blinking_speed = 10 * 1 / (3 * 60)
scale_numbers(rubber_ducky_factory_entity.door_back_open_offset)
scale_numbers(rubber_ducky_factory_entity.door_front_open_offset)

local rubber_ducky_factory_item = util.table.deepcopy(data.raw['item']['rocket-silo'])
rubber_ducky_factory_item.name = "rubber-ducky-factory"
rubber_ducky_factory_item.place_result = "rubber-ducky-factory"
rubber_ducky_factory_item.icon = "__rubber-ducky__/graphics/rubber-ducky-factory-icon.png"

local rubber_ducky_factory_recipe =  {
    type = "recipe",
    name = "rubber-ducky-factory",
		category = "crafting",
    enabled = false,
    ingredients =
    {
			{type="item", name="assembling-machine-3", amount=1},
			{type="item", name="rocket-silo", amount=1}
    },
    energy_required = 1,
    results = {{type="item", name="rubber-ducky-factory", amount=1}},
  }

	
rocket_ducky = util.table.deepcopy(data.raw['rocket-silo-rocket']['rocket-silo-rocket'])
rocket_ducky.name = "rocket-ducky"
scale_all(rocket_ducky)
rocket_ducky.rocket_sprite.filename = "__rubber-ducky__/graphics/rocket-ducky.png"
rocket_ducky.rocket_shadow_sprite.filename = "__rubber-ducky__/graphics/rocket-ducky-shadow.png"
rocket_ducky.rocket_shadow_sprite.width = 672
rocket_ducky.rocket_shadow_sprite.height = 216

rocket_ducky.rocket_glare_overlay_sprite = transparent
rocket_ducky.rocket_smoke_top1_animation = transparent
rocket_ducky.rocket_smoke_top2_animation = transparent
rocket_ducky.rocket_smoke_top3_animation = transparent
rocket_ducky.rocket_smoke_bottom1_animation = transparent
rocket_ducky.rocket_smoke_bottom2_animation = transparent
rocket_ducky.rocket_flame_animation = transparent
rocket_ducky.rocket_flame_left_animation = transparent
rocket_ducky.rocket_flame_right_animation = transparent

rocket_ducky.rising_speed = 2*1 / (7 * 60)
rocket_ducky.engine_starting_speed = 10*1 / (5.5 * 60)
rocket_ducky.flying_speed = 4 / (2000 * 60)
--rocket_ducky.flying_acceleration = 0.001
rocket_ducky.rocket_rise_offset = {0, -1.1}
rocket_ducky.rocket_launch_offset = {0, -2}
--rocket_ducky.rocket_render_layer_switch_distance = .1
--rocket_ducky.full_render_layer_switch_distance = .1
-- rocket_ducky.effects_fade_in_start_distance = 4.5
-- rocket_ducky.effects_fade_in_end_distance = 7.5
-- rocket_ducky.shadow_fade_out_start_ratio = 0.25
-- rocket_ducky.shadow_fade_out_end_ratio = 0.75

rocket_ducky.rocket_visible_distance_from_center = 2.75 * ducky_factory_scale

rocket_ducky.rocket_above_wires_slice_offset_from_center = -3 * ducky_factory_scale
--rocket_ducky.rocket_air_object_slice_offset_from_center = -5.5 * ducky_factory_scale

-- rubber_ducky_factory_entity.type= "assembling-machine"
-- rubber_ducky_factory_entity.fluid_boxes = util.table.deepcopy(data.raw['assembling-machine']['assembling-machine-3'].fluid_boxes)
-- rubber_ducky_factory_entity.crafting_categories = {"basic-crafting", "crafting", "advanced-crafting", "crafting-with-fluid","rocket-building"}

data:extend(
	{
		rubber_ducky_factory_entity,
		rubber_ducky_factory_item,
		rubber_ducky_factory_recipe,
		rocket_ducky,
	})

-- local golden_ducky_factory_entity = util.table.deepcopy(rubber_ducky_factory_entity)
-- golden_ducky_factory_entity.name = "golden-ducky-factory"
-- golden_ducky_factory_entity.fluid_boxes = util.table.deepcopy(data.raw['assembling-machine']['assembling-machine-3'])

-- data:extend(
	-- {
		-- golden_ducky_factory_entity,
		-- rubber_ducky_factory_item,
		-- rubber_ducky_factory_recipe,
		-- rocket_ducky,
	-- })
