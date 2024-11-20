local proto_ducky = 
{
	type = "item",
	name = "proto-ducky",
	icon = "__rubber-ducky__/graphics/proto-ducky.png",
	icon_size = 64, icon_mipmaps = 1,

	--subgroup = "rubber-ducky",
	--order = "z[rubber-ducky]-a",
	stack_size = 1,
	--place_result = "rubber-ducky",
	rocket_launch_product = {"rubber-ducky", 1},
}
	
data:extend(
	{
		proto_ducky,
	}
)