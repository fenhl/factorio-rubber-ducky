local rubber_ducky_science_item = {
			type = "tool",
			name = "rubber-ducky-science-pack",
			icon = "__rubber-ducky__/graphics/rubber-ducky-science-pack.png",
			icon_size = 64, icon_mipmaps = 1,
			subgroup = "raw-resource",
			order = "z[rubber-ducky]-b",
			stack_size = 2000,
			subgroup = "science-pack",
			order = "z[rubber-ducky]",
			durability = 1,
			durability_description_key = "description.science-pack-remaining-amount-key",
			durability_description_value = "description.science-pack-remaining-amount-value"
		}

data:extend(
  {
		rubber_ducky_science_item,
	}
)