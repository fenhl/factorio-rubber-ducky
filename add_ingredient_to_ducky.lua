local function is_valid_ingredient(item_name,input)
	debugger("attempting to check "..item_name);
	if rubber_ducky_ingredients[item_name] then
		debugger("skipping already added: " .. item_name)
		return false end
		
	for n,_ in pairs(skip_ingredient_prefix) do
		if string.starts(item_name,n) then
			debugger("skipping prefix match " .. n .. ": " .. item_name)
			return false end
	end
	
		
	if skip_ingredient_name[item_name] then
		debugger("skipping name match: " .. item_name)
		return false end
		
	if skip_downstream_items[item_name] then
		debugger("skipping downstream item: " .. item_name)
		return false end
		
	if input ~= nil
	and input.hidden then
		debugger("skipping hidden recipe: " .. item_name)
		return false end
	
	return true
end


function add_item_to_ducky(input)
	local item_name
	local item_object
	local recipe_name
	local recipe_object

	item_name = input['name']
	item_object = input

	add_ingredient_to_ducky(item_name, item_object, recipe_name, recipe_object)
end


function add_recipe_to_ducky(input)
	if input['results'] ~= nil then
		for _,result in pairs(input['results']) do
			local item_name
			local item_object
			local recipe_name
			local recipe_object

			item_name = result['name']
			if data.raw['item'][item_name] ~= nil then
				item_object = data.raw['item'][item_name]
			end
			if data.raw['module'][item_name] ~= nil then
				item_object = data.raw['module'][item_name]
			end
			recipe_name = input['name']
			recipe_object = input
			if data.raw['fluid'][item_name] ~= nil then
				debugger("skipping fluid: " .. recipe_name)
				--debugger(dump(input))
			elseif input.enabled ~= nil and input.enabled ~= true and rw_tools.get_recipe_tech(input.name) == nil then
				debugger("skipping impossible to unlock recipe : " .. recipe_name)
				--debugger(dump(input))
			else
				add_ingredient_to_ducky(item_name, item_object, recipe_name, recipe_object)
			end
		end
	end
end


function add_ingredient_to_ducky(item_name, item_object, recipe_name, recipe_object)
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
	--debugger(dump(item_object))
	debugger("adding: " .. item_name)
	--debugger(dump(input))
	rubber_ducky_ingredients[item_name] = {type="item", name=item_name, amount=1}
end