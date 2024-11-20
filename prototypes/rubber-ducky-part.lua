local rubber_ducky_part_item = {
			type = "item",
			name = "rubber-ducky-part",
			localised_name = {"item-name.rubber-ducky-part"},
			icon = "__rubber-ducky__/graphics/rubber-ducky-part.png",
			icon_size = 64, icon_mipmaps = 1,
			flags = {"hidden"},
			subgroup = "rubber-ducky",
			order = "z[rubber-ducky]-b",
			stack_size = 5
    }
local rubber_ducky_part_recipe = {
    type = "recipe",
    name = "rubber-ducky-part",
		--localised_name = {"item-name.rubber-ducky-part"},
    energy_required = 1,
    enabled = false,
    hidden = true,
    category = "rocket-building",
    ingredients =
    {

    },
    result= "rubber-ducky-part"
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