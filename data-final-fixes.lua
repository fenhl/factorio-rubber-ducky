
require("red-wizard-utilities")
require("add_ingredient_to_ducky")
string = require('__stdlib2__/stdlib/utils/string')
local function find_downstream_items(including)
	log("looking for items including " .. including)
	for _,recipe in pairs(data.raw['recipe']) do
		if recipe.ingredients ~= nil then
			for _,ingredient in pairs(recipe.ingredients) do
				if ingredient[1] == including then
				
					log("found downstream recipe: " .. recipe.name .. " requires " .. including)
					if recipe.results ~= nil 
					and recipe.results[1] ~= nil 
					and recipe.results[1].name ~= nil
					then
						if skip_downstream_items[recipe.results[1].name] == nil then
							skip_downstream_items[recipe.results[1].name] = 1
							find_downstream_items(recipe.results[1].name)
						end
					end
				end
			end
		end
	end
end


skip_ingredient_name = {}
skip_ingredient_name['rubber-ducky'] = 1
skip_ingredient_name['infinity-chest'] = 1
skip_ingredient_name['infinity-pipe'] = 1
skip_ingredient_name['electric-energy-interface'] = 1


local custom_ingredient_names = string.split(settings.startup["rubber-ducky-skip-items"].value," ");
log(dump(custom_ingredient_names))
for _,i in pairs(custom_ingredient_names) do
	skip_ingredient_name[i] = 1
end



-- if ifmod("Krastorio2") then
	-- skip_ingredient_name['uranium-rounds-magazine'] = 1
	-- skip_ingredient_name['imersite-rounds-magazine'] = 1
-- end

skip_ingredient_prefix = {}
skip_ingredient_prefix['creative-mod'] = 1
skip_ingredient_prefix['bpl-'] = 1
skip_ingredient_prefix['ee-'] = 1


local test = string.starts(" test ",'h');

custom_ingredient_names = string.split(settings.startup["rubber-ducky-skip-item-prefixes"].value," ");
for _,i in pairs(custom_ingredient_names) do

	skip_ingredient_prefix[i] = 1
end


skip_downstream_items = {}

find_downstream_items("rubber-ducky")
find_downstream_items("rubber-ducky-science-pack")

if settings.startup["rubber-ducky-vanilla-recipe"].value then
	require("prototypes/vanilla-rubber-ducky.lua")
else
	rubber_ducky_ingredients = {}

	rubber_ducky_ingredients['raw-fish'] = {type="item", name="raw-fish", amount=1}

	log("Adding rubber ducky ingredients from recipes")
	for _,r in pairs(data.raw['recipe']) do
		--log(dump(r))
		
		add_recipe_to_ducky(r)
	end
	log(" ")
	log("Adding rubber ducky ingredients from items")
	for _,r in pairs(data.raw['item']) do

		 if r['subgroup'] == "raw-resource"
		 or r['subgroup'] == "vulcanus-processes"
		 or r['subgroup'] == "fulgora-processes"
		 or r['subgroup'] == "barrel" then
			add_item_to_ducky(r)
		end

		if r.burnt_result ~= nil then
			add_ingredient_to_ducky(r.burnt_result)
		end
		if r.spoil_result ~= nil then
			add_ingredient_to_ducky(r.spoil_result)
		end
	end
	log(" ")
	log("Adding rubber ducky ingredients from plants")
	for _,r in pairs(data.raw['plant']) do
		if r.minable ~= nil and r.minable.results ~= nil then
			for _,result in pairs(r.minable.results) do
				add_ingredient_to_ducky(result.name)
			end
		end
	end
	log(" ")
	log("Adding rubber ducky ingredients from asteroids")
	for _,r in pairs(data.raw['asteroid-chunk']) do
		if r.minable ~= nil and r.minable.result ~= nil then
			add_ingredient_to_ducky(r.minable.result)
		end
	end

end

if settings.startup["rubber-ducky-exclude-wood"].value then
	rubber_ducky_ingredients['wood'] = nil
	rubber_ducky_ingredients['wooden-chest'] = nil
	rubber_ducky_ingredients['small-electric-pole'] = nil
end


local max_ingredients_per_part = 250
local max_ducky_parts = 10000
if settings.startup["rubber-ducky-debug-mode"].value then
	max_ingredients_per_part = 2
	max_ducky_parts = 3
end
local i = 0;
local j = 1;
local rubber_ducky_parts = {}
rubber_ducky_parts[1] = {}

--Dump to file
local datafile = "\nrubber_ducky_ingredients = {}\n"

for _,ingredient in pairs(rubber_ducky_ingredients) do
	--datafile = datafile .. "rubber_ducky_ingredients['"..ingredient[1].."'] = {'".. ingredient[1] .. "',1}\n"
	--datafile = datafile .. ", " .. ingredient[1]
end
--log(datafile)


local ingredient_count = 0
for _,ingredient in pairs(rubber_ducky_ingredients) do
	i = i + 1
	
	if i > max_ingredients_per_part then
		i = 1
		j = j + 1
	end
	
	if j > max_ducky_parts then
		break
	end
	ingredient_count = ingredient_count + 1
	if rubber_ducky_parts[j] == nil then
		rubber_ducky_parts[j] = {}
	end
	table.insert(rubber_ducky_parts[j], ingredient)
end


--data.raw['recipe']['rubber-ducky']['ingredients'] = rubber_ducky_ingredients
-- rubber_ducky_parts[1]['lubricant'] = {'lubricant',1}

for i,part in pairs(rubber_ducky_parts) do

	local part_recipe = util.table.deepcopy(data.raw['recipe']['rubber-ducky-part'])
	part_recipe.name = "rubber-ducky-part-" .. i
	part_recipe.ingredients = part
	part_recipe.hidden = false
	part_recipe.results = {{type="item", name="rubber-ducky-part-" .. i, amount=1}}
	local part_item = util.table.deepcopy(data.raw['item']['rubber-ducky-part'])
	part_item.name = "rubber-ducky-part-" .. i
	part_item.localised_name = {"item-name.rubber-ducky-part", tostring(i), tostring(count(part_recipe.ingredients))}
	--log(dump(part_item))
	data:extend(
		{
			part_item,
			part_recipe
		}
	)
	table.insert(data.raw['recipe']['rubber-ducky']['ingredients'], {type="item", name=part_item.name, amount=1})
	table.insert(data.raw['technology']['rubber-ducky']['effects'], {
		type = "unlock-recipe",
		recipe = part_recipe.name
	})
end

data.raw['item']['rubber-ducky-part'] = nil;
data.raw['recipe']['rubber-ducky-part'] = nil;

data.raw['item']['rubber-ducky'].localised_name = {"item-name.rubber-ducky", tostring(ingredient_count)}