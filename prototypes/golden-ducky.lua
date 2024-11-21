
local golden_ducky_item = util.table.deepcopy(data.raw['item']['rubber-ducky'])
golden_ducky_item.name = "golden-ducky"
golden_ducky_item.place_result = nil

local golden_ducky_recipe = util.table.deepcopy(data.raw['recipe']['rubber-ducky'])
golden_ducky_recipe.name = "golden-ducky"
golden_ducky_recipe.results[1].name = "golden-ducky"
golden_ducky_recipe.category = "crafting-with-fluid"
golden_ducky_recipe.enabled = false

golden_ducky_recipe.ingredients =
    {
			{type="item", name="rubber-ducky", amount=1},
			{type="fluid", name="lubricant", amount=1},
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
        {type="item", name="automation-science-pack", amount=1},
        {type="item", name="logistic-science-pack", amount=1},
        {type="item", name="chemical-science-pack", amount=1},
        {type="item", name="production-science-pack", amount=1},
        {type="item", name="utility-science-pack", amount=1},
        {type="item", name="space-science-pack", amount=1},
				{type="item", name="rubber-ducky-science-pack", amount=1},
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