--[[
	Surfaces (Factorio Mod)
    Copyright (C) 2016  Simon Crawley

    This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
]]

require("config")
require("script.enum")
require("script.lib.struct")
require("script.lib.pair-data")
require("script.lib.surfaces")
require("script.lib.pair-util")
require("script.lib.api-util")
require("script.lib.util")

events = {}
local eventmgr = {}

-- This function is called every game tick, it's primary purpose is to act as a timer for each of the handles in the event manager
-- It uses data from enum to determine whether a function is due to be called and iterates sequentually
function events.on_tick(event)
	for k, v in pairs(enum.eventmgr.handle) do
		if event.tick % v.tick == 0 then
			eventmgr_call(event, v.func)
		end
	end
end

-- This function is called whenever an entity is built by the player
function events.on_built_entity(event)
	if pairdata.get(event.created_entity) ~= nil then
		global.task_queue = global.task_queue or {}
		table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.trigger_create_paired_entity, event.created_entity))
	end
end

-- This function is called whenever an entity is built by a construction robot
function events.on_robot_built_entity(event)
	if pairdata.get(event.created_entity) ~= nil then
		global.task_queue = global.task_queue or {}
		table.insert(global.task_queue, struct.TaskSpecification(enum.eventmgr.task.trigger_create_paired_entity, event.created_entity))
	end
end

-- This function is called whenever a chunk is generated
function events.on_chunk_generated(event)
	if surfaces.is_from_this_mod(event.surface) then
		surfaces.chunk_generator_corrections(event.surface, event.area)
	end
end

-- This function is called just before an entity is deconstructed by the player
function events.on_preplayer_mined_item(event)
	if pairdata.get(event.entity) ~= nil then
		pairutil.destroy_paired_entity(event.entity)
	end
end

-- This function is called just before an entity is deconstructed by a construction robot
function events.on_robot_pre_mined(event)
	if pairdata.get(event.entity) ~= nil then
		pairutil.destroy_paired_entity(event.entity)
	end
end

function eventmgr_call(event, function_name)
	return eventmgr[tostring(function_name)](event)
end

function events.on_player_mined_item(event)

end

function events.on_robot_mined(event)

end

function events.on_marked_for_deconstruction(event)
	
end

function events.on_canceled_deconstruction(event)

end

function events.on_player_driving_changed_state(event)
	
end

function events.on_put_item(event)

end

function events.on_player_rotated_entity(event)

end

function events.on_trigger_created_entity(event)

end

function events.on_picked_up_item(event)

end

function events.on_sector_scanned(event)
	
end

function events.on_entity_died(event)

end

-- This function is called whenever a train changes state from moving to stopping or stopping to stopped, etc.
function events.on_train_changed_state(event)
	--if front carriage is nearby a intersurface train stop and train state is stopped
	--if event.train.state == defines.trainstate.wait_station
end

-- Calls the function associated with each handle
--[[eventmgr_call = function(handle, event)
	local handles = enum.eventmgr.handle
	if handle == handles.access_shaft_teleportation.id then
		update_players_using_access_shafts(event)
	elseif handle == handles.access_shaft_update.id then
		check_player_collision_with_access_shafts(event)
	elseif handle == handles.transport_chest_update.id then
		update_transport_chest_contents(event)
	elseif handle == handles.fluid_transport_update.id then
		update_fluid_transport_contents(event)
	elseif handle == handles.taskmgr.id then
		execute_first_task_in_waiting_queue(event)
	end
end]]

-- This function looks at the global table containing players who are using an access shaft and teleports them to the destination access shaft if one exists
function eventmgr.update_players_using_access_shafts(event)
	global.players_using_access_shafts = global.players_using_access_shafts or {}
	for name, data in pairs(global.players_using_access_shafts) do
		local player = data.player_entity
		if player.walking_state.walking == true or data.destination_access_shaft == nil then
			global.players_using_access_shafts[name] = nil
		else
			if data.time_waiting >= config.teleportation_time_waiting then
				if util.is_valid(data.destination_access_shaft) then
					surfaces.transport_player_to_access_shaft(player, data.destination_access_shaft)
				end
				global.players_using_access_shafts[name] = nil
			end
			data.time_waiting = data.time_waiting + enum.eventmgr.handle.access_shaft_teleportation.tick
		end
	end
end

-- This function checks whether any players are near an access shaft and adds them to the global table for players using access shafts if they are within range of one and not moving
function eventmgr.check_player_collision_with_access_shafts(event)
	global.players_using_access_shafts = global.players_using_access_shafts or {}
	for index, player in ipairs(game.players) do
		if not(player.walking_state.walking) and global.players_using_access_shafts[player.name] == nil then
			local access_shaft = surfaces.find_nearby_access_shaft(player, config.teleportation_check_range, player.surface)
			if util.is_valid(access_shaft) then
				local paired_access_shaft = pairutil.find_paired_entity(access_shaft)
				if util.is_valid(paired_access_shaft) then
					global.players_using_access_shafts[player.name] = {time_waiting = 0, player_entity = player, destination_access_shaft = paired_access_shaft}
				end
			end
		end
	end
end

-- This function updates the contents of each transport and receiver chest in the map, providing that they are both valid and if they are not, they will be destroyed
function eventmgr.update_transport_chest_contents(event)
	global.transport_chests = global.transport_chests or {}
	for k, v in pairs(global.transport_chests) do
		if not(util.is_valid(v.input) and util.is_valid(v.output)) then
			util.destroy(v.input)
			util.destroy(v.output)
			table.remove(global.transport_chests, k)
		else
			local input = util.get_inventory(v.input, defines.inventory.chest)
			local output = util.get_inventory(v.output, defines.inventory.chest)
			for key, value in pairs(util.get_contents(input)) do
				local itemstack = struct.ItemStack(key, value)
				if util.can_insert(output, itemstack) then
					local remove_itemstack = struct.ItemStack(key, util.insert_itemstack(output, itemstack))
					util.remove_itemstack(input, remove_itemstack)
				end
			end
		end
	end
end

-- This function updates the contents of each intersurface fluid tank in the map, providing that they are both valid and if they are not, they will be destroyed
function eventmgr.update_fluid_transport_contents(event)
	global.fluid_transport = global.fluid_transport or {}
	for k, v in pairs(global.fluid_transport) do
		if not(util.is_valid(v.a) and util.is_valid(v.b)) then
			util.destroy(v.a)
			util.destroy(v.b)
			table.remove(global.fluid_transport, k)
		else
			local fluidbox_a, fluidbox_b = v.a.fluidbox[1], v.b.fluidbox[1]
			if not(fluidbox_a == nil and fluidbox_b == nil) then
				if fluidbox_a == nil then
					fluidbox_b.amount = fluidbox_b.amount/2
					v.a.fluidbox[1] = fluidbox_b
					v.b.fluidbox[1] = fluidbox_b
				elseif fluidbox_b == nil then
					fluidbox_a.amount = fluidbox_a.amount/2
					v.a.fluidbox[1] = fluidbox_a
					v.b.fluidbox[1] = fluidbox_a
				elseif fluidbox_a.type == fluidbox_b.type then
					local fluidbox_new = fluidbox_a
					fluidbox_new.amount = (fluidbox_new.amount + fluidbox_b.amount)/2
					v.a.fluidbox[1] = fluidbox_new
					v.b.fluidbox[1] = fluidbox_new
				end
			end
		end
	end
end

-- This function is used to avoid annoying desync errors when playing in multiplayer, it acts as a system to queue tasks such as creating entities and surfaces that need to happen on the same tick on all clients
function eventmgr.execute_first_task_in_waiting_queue(event)
	global.task_queue = global.task_queue or {}
	local tasks = enum.eventmgr.task
	for k, v in ipairs(global.task_queue) do
		if v.task == tasks.trigger_create_paired_entity then										-- Validates the entity prior to creation of it's pair, gathering the relative location for the paired entity
			local destination_surface = pairutil.validate_paired_entity(v.data.entity)
			if destination_surface then
				table.insert(global.task_queue, struct.TaskSpecification(
					tasks.trigger_create_paired_surface,
					{v.data.entity, destination_surface}))											-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.trigger_create_paired_surface then									-- Validates the paired surface, creating it if it does not yet exist
			local surface = pairutil.create_paired_surface(v.data.entity, v.data.pair_location)
			if surface == nil then																	-- If the surface has not yet been created
				table.insert(global.task_queue, v)													-- Insert a duplicate of this task at the back of the queue (avoids being discarded from the queue)
			elseif surface ~= false then															-- Ensures that data passed is valid and if not, the task is simply removed from the queue
				util.request_generate_chunks(surface, v.data.entity.position, 0)					-- Fixes a small bug with chunk generation
				table.insert(global.task_queue, struct.TaskSpecification(
					tasks.create_paired_entity,
					{v.data.entity, surface}))														-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.create_paired_entity then											-- Creates the paired entity
			local pair = pairutil.create_paired_entity(v.data.entity, v.data.paired_surface)
			if pair == nil or pair == false then													-- If the pair fails to be created for some unknown reason
				table.insert(global.task_queue, v)													-- Insert a duplicate of this task at the back of the queue (avoids being discarded from the queue)
			else																					-- Otherwise
				table.insert(global.task_queue, struct.TaskSpecification(
					tasks.finalize_paired_entity,
					{v.data.entity, pair}))															-- Insert the next task for this process-chain at the back of the queue
			end
		elseif v.task == tasks.finalize_paired_entity then											-- Performs final processing for the paired entity (example: intersurface electric poles are connected to one another)
			pairutil.finalize_paired_entity(v.data.entity, v.data.paired_entity)
		end
		table.remove(global.task_queue, k)															-- Remove the current task from the queue, it has finished executing
		break																						-- Exit loop, we have finished processing the first task in the queue
	end
end
