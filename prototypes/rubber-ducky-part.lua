local rubber_ducky_part_item = {
			type = "item",
			name = "rubber-ducky-part",
			localised_name = {"item-name.rubber-ducky-part"},
			icon = "__rubber-ducky-fenhl__/graphics/rubber-ducky-part.png",
			icon_size = 64, icon_mipmaps = 1,
			subgroup = "rubber-ducky",
			order = "z[rubber-ducky]-b",
			stack_size = 5,
			weight = 1000000,
    }
local rubber_ducky_part_recipe = {
    type = "recipe",
    name = "rubber-ducky-part",
		--localised_name = {"item-name.rubber-ducky-part"},
    energy_required = 1,
    enabled = false,
    category = "advanced-crafting",
    ingredients =
    {

    },
    results = {{type="item", name="rubber-ducky-part", amount=1}},
  }

if settings.startup["rubber-ducky-debug-mode"].value then
	rubber_ducky_part_recipe.enabled = true
	rubber_ducky_part_recipe.hidden = false
end
data:extend(
{
	rubber_ducky_part_item,
	rubber_ducky_part_recipe,
})