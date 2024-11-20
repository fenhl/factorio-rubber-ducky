
local golden_ducky_item = util.table.deepcopy(data.raw['item']['rubber-ducky'])
golden_ducky_item.name = "golden-ducky"
golden_ducky_item.place_result = nil

local golden_ducky_recipe = util.table.deepcopy(data.raw['recipe']['rubber-ducky'])
golden_ducky_recipe.name = "golden-ducky"
golden_ducky_recipe.result = "golden-ducky"
golden_ducky_recipe.category = "crafting-with-fluid"
golden_ducky_recipe.enabled = false

golden_ducky_recipe.ingredients =
    {
			{"rubber-ducky",1},
			{"lubricant",1},
    }

local golden_ducky_tech = {
    type = "technology",
    name = "golden-ducky",
    icon_size = 64, icon_mipmaps = 1,
    icon = "__rubber-ducky__/graphics/rubber-ducky.png",
    effects =
    {
      {
        type = "unlock-recipe",
        recipe = "golden-ducky"
      }
    },
    prerequisites = {"rubber-ducky"},
    unit =
    {
			count = 1000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"production-science-pack", 1},
        {"utility-science-pack", 1},
        {"space-science-pack", 1},
				{"rubber-ducky-science-pack", 1},
      },
      time = 60
    },
  }




-- data:extend(
  -- {
		-- golden_ducky_item,
		-- golden_ducky_recipe,
		-- golden_ducky_tech,
	-- }
-- )