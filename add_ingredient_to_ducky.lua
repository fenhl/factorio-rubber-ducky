local function is_valid_ingredient(item_name,input)
	log("attempting to check "..item_name);
	if rubber_ducky_ingredients[item_name] then
		log("skipping already added: " .. item_name)
		return false end
		
	for n,_ in pairs(skip_ingredient_prefix) do
		if string.starts(item_name,n) then
			log("skipping prefix match " .. n .. ": " .. item_name)
			return false end
	end
	
		
	if skip_ingredient_name[item_name] then
		log("skipping name match: " .. item_name)
		return false end
		
	if skip_downstream_items[item_name] then
		log("skipping downstream item: " .. item_name)
		return false end
		
	if input ~= nil
	and input.hidden then
		log("skipping hidden recipe: " .. item_name)
		return false end
	
	return true
end


function add_ingredient_to_ducky(input)
	local item_name
	local item_object
	local recipe_name
	local recipe_object

	if(input.type)=="recipe" then
		if input['results'] ~= nil 
		and input['results'][1] ~= nil then
			item_name = input['results'][1].name
		end
		if input.normal ~= nil
		and input.normal['results'] ~= nil then
			item_name = input.normal['results'][1].name
		end
		if data.raw['item'][item_name] ~= nil then
			item_object = data.raw['item'][item_name]
		end
		if data.raw['module'][item_name] ~= nil then
			item_object = data.raw['module'][item_name]
		end
		recipe_name = input['name']
		recipe_object = input
		if data.raw['fluid'][item_name] ~= nil then
			log("skipping fluid: " .. recipe_name)
			--log(dump(input))
			return false 
		end
		
		if input.enabled ~= nil and input.enabled ~= true and rw_tools.get_recipe_tech(input.name) == nil then
			log("skipping impossible to unlock recipe : " .. recipe_name)
			--log(dump(input))
			return false 
		end
	else
		item_name = input['name']
		item_object = input
	end
	
	if item_name == nil then
		return false
	end
	
	if not is_valid_ingredient(item_name,item_object) then
		return false
	end

	if recipe_name ~= nil
	and not is_valid_ingredient(recipe_name,recipe_object) then
		return false
	end
	--log(dump(item_object))
	log("adding: " .. item_name)
	--log(dump(input))
	rubber_ducky_ingredients[item_name] = {type="item", name=item_name, amount=1}
end