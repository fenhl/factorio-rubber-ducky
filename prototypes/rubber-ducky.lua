local rubber_ducky_entity =  {
    type = "fish",
    name = "rubber-ducky",
    icon = "__rubber-ducky__/graphics/rubber-ducky.png",
    icon_size = 64, icon_mipmaps = 1,
    flags = {"placeable-neutral", "placeable-player", "not-on-map","placeable-off-grid"},
    minable = {mining_time = 0.4, result = "rubber-ducky", count = 1},
    --mined_sound = sounds.mine_fish,
    max_health = 200,
    subgroup = "creatures",
    order = "b-a",
    collision_box = {{-0.75, -0.75}, {0.75, 0.75}},
    selection_box = {{-0.5, -0.3}, {0.5, 0.3}},
    pictures =
    {
      {
        filename = "__rubber-ducky__/graphics/rubber-ducky-entity.png",
        priority = "extra-high",
        width = 74,
        height = 60,
				scale = .5
      }
    },
    autoplace = { influence = 0.01 },
    protected_from_tile_building = false,
  }
	
local rubber_ducky_item = {
			type = "item",
			name = "rubber-ducky",
			icon = "__rubber-ducky__/graphics/rubber-ducky.png",
			icon_size = 64, icon_mipmaps = 1,

			subgroup = "rubber-ducky",
			order = "z[rubber-ducky]-a",
			stack_size = 100,
			place_result = "rubber-ducky",
			rocket_launch_product = {"rubber-ducky-science-pack", 1},
		}
local rubber_ducky_recipe =  {
    type = "recipe",
    name = "rubber-ducky",
		category = "rocket-building",
    --enabled = true,
    ingredients =
    {
    },
    energy_required = 1,
    result = "rubber-ducky"
  }
local rubber_ducky_tech = {
    type = "technology",
    name = "rubber-ducky",
    icon_size = 64, icon_mipmaps = 1,
    icon = "__rubber-ducky__/graphics/rubber-ducky.png",
    effects =
    {
    },
    prerequisites = {"space-science-pack"},
    unit =
    {
			count = 200,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1}
      },
      time = 60
    },
  }
rubber_ducky_tech.effects['rubber-ducky'] = 
{
	type = "unlock-recipe",
	recipe = "rubber-ducky"
}
rubber_ducky_tech.effects['rubber-ducky-factory'] = 
{
	type = "unlock-recipe",
	recipe = "rubber-ducky-factory"
}

data:extend(
  {
		rubber_ducky_entity,
		rubber_ducky_item,
		rubber_ducky_recipe,
		rubber_ducky_tech,
		{
			name = "rubber-ducky",
			type = "item-subgroup",
			group= "intermediate-products",
			order = "z",
		}
	}
)