-- ==========================================
-- GiftItToMe - Extension for UnitFlagManager
-- ==========================================

local files = {};
	
-- Better Builder Charges support
if Modding.IsModActive("c6477d9f-6bad-4d24-9e76-49cda4f0a966") then
	table.insert(files, "UnitFlagManager_BuilderCharges.lua");
end

-- Barbarian Clans support
local barbMode = GameConfiguration.GetValue("GAMEMODE_BARBARIAN_CLANS");

if barbMode ~= nil and barbMode then
	table.insert(files, "UnitFlagManager_BarbarianClansMode.lua");
end

-- Check if FortifAI is active (get into compatibility mode)
if Modding.IsModActive("20d1d40c-3085-11e9-b210-d663bd873d93") then
	-- FortifAI context (compatibility with FortifAI)
	-- ATTENTION: FortifAI _MUST_ loaded first!
	-- See modinfo <LoadOrder> for this file!
	table.insert(files, "UnitFlagManager_FAI.lua");
else
	-- Basegame context
	table.insert(files, "UnitFlagManager.lua");
end

for _, file in ipairs(files) do
	include(file)
	if Initialize then
		print("Loading " .. file .. " as base file");
		break
	end
end

-- Add a log event for loading this
print("Loading UnitFlagManager_GITM.lua");

-- Update unit flag on demand/event for religious units
function FAI_OnUpdateUnitFlagReligious(playerID, unitID, unitX, unitY)
	-- Fetch player and unit
	local pPlayer = Players[playerID];
	local pUnit = pPlayer:GetUnits():FindID(unitID);

	-- If they are also real, continue
	if (pUnit ~= nil and pUnit:GetUnitType() ~= -1 and pUnit:GetReligionType() > 0 and pUnit:GetReligiousStrength() > 0) then
	-- Get current flag instance
		local flagInstance = GetUnitFlag(playerID, unitID);

		-- If its real, destroy the current flag-instance
		if flagInstance ~= nil then
			-- Update the unit instance
			flagInstance:UpdateReligion();
		end
	end
end

-- Our custom initialize
function Initialize_GITM_UniFlagManager()
	-- Log execution
	print("UnitFlagManager_GITM.lua: Initialize_GITM_UniFlagManager")

	-- Append our own lua-event
	LuaEvents.UpdateUnitFlagReligious.Add(FAI_OnUpdateUnitFlagReligious);
end

-- Our initialize
Initialize_GITM_UniFlagManager();
