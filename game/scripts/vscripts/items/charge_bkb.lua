--[[ ============================================================================================================
	Charge BKB: Combines magic_wand functionality with BKB functionality, and charges decay with time.
	Written by RamonNZ
	Version 1.01
	Credit: Some original code from Rook
	RamonNZ: The code below starts when you activate the BKB:
================================================================================================================= ]]

require( "libraries/Timers" )	--needed for the timers.

function modifier_charge_bkb_datadriven_on_spell_start(keys)

--RamonNZ: Wand Effect: Idea: May as well keep the small wand heal effect in addition to the BKB effect. Can be commented out if not wanted or just set to 0 in the kv.
	local amount_to_restore = keys.ability:GetCurrentCharges() * keys.RestorePerCharge --RestorePerCharge
	keys.caster:Heal(amount_to_restore, keys.caster)
	keys.caster:GiveMana(amount_to_restore)
--RamonNZ: BKB Effect:
	local modifier_duration = keys.ChargeImmunityTime*keys.ability:GetCurrentCharges()
--	keys.Duration = modifier_duration		--if only life were this simple
	keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_charge_bkb_datadriven_active", nil)
	keys.caster:EmitSound("DOTA_Item.BlackKingBar.Activate")
	print ("--> bkb_datadriven_active length = ", modifier_duration)
	keys.caster:AddNewModifier(keys.caster, keys.ability, "modifier_charge_bkb_datadriven_active", {duration = modifier_duration})
--	keys.ability:ApplyDataDrivenModifier(keys.caster,keys.ability, "modifier_charge_bkb_datadriven_active", {duration = modifier_duration})	--In case AddNewModifier has problems this will do the same thing
	keys.ability:SetCurrentCharges(0)	--or use code keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges()-1) if we want to just remove 1 charge
end



--[[ ============================================================================================================
	RamonNZ: This code adds charges when abilities are used by enemies. 
	Known Bugs (by Rook): Because OnAbilityExecuted does not pass in information about the ability that was just executed,
	this code cannot use ProcsMagicStick() to determine if Magic Stick should gain a charge.  For now, every cast
	ability awards a charge.
	RamonNZ: In addition to above, another limitation/bug of the code is that the regular magic wand/stick adds charges if a neutral creep uses an ability nearby, but this doesn't seem to trigger on neutrals, nor does it seem possible.
================================================================================================================= ]]
function modifier_charge_bkb_datadriven_aura_on_ability_executed(keys)
	if keys.caster:GetTeam() ~= keys.unit:GetTeam() and keys.caster:CanEntityBeSeenByMyTeam(keys.unit) then
		 --Rook's code: Search for a Charge_BKB in the aura creator's inventory.  If there are multiple Charge_BKBs in the player's inventory, the oldest one that's not full receives a charge.
		local oldest_unfilled_wand = nil
		
		for i=0, 5, 1 do
			local current_item = keys.caster:GetItemInSlot(i)
			if current_item ~= nil and current_item:GetName() == "item_charge_bkb" and current_item:GetCurrentCharges() < keys.MaxCharges then
				if oldest_unfilled_wand == nil or current_item:GetEntityIndex() < oldest_unfilled_wand:GetEntityIndex() then
					oldest_unfilled_wand = current_item
				end
			end
		end
		
		--RamonNZ: Increment the Magic Wand's current charges by 1, but only if CurrentCharges are less than MaxCharges
		if oldest_unfilled_wand ~= nil then
			if oldest_unfilled_wand:GetCurrentCharges() < MaxCharges then
				oldest_unfilled_wand:SetCurrentCharges(oldest_unfilled_wand:GetCurrentCharges() + 1)
			end
		end
		--RamonNZ: start the charges decay timer & first remove it if there's already one in play (we don't want more than one in play removing charges)
		--RamonNZ: this resets the decay timer every time it gains a charge. Seems fair. Otherwise you could theoretically gain a charge and lose it like 1 second later which would be unfortunate.
		Timers:RemoveTimer("charges_decay_timer")
		Timers:CreateTimer("charges_decay_timer", {
		useGameTime = true,
		endTime = keys.ChargeDecayTime,
		callback = function()
			if keys.ability:GetCurrentCharges() > 0 then
				print ("--> -1 Charge_BKB charge")
				keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges()-1) 
			end
			return keys.ChargeDecayTime
		end})
	end
end


--[[ ============================================================================================================
	RamonNZ: This code creates the decay timer when item is created
================================================================================================================= ]]
function modifier_charge_bkb_datadriven_on_created(keys)
	--RamonNZ: start the charges decay timer & remove it if there's already one in play (we don't want more than one in play removing charges)
	Timers:RemoveTimer("charges_decay_timer")
	Timers:CreateTimer("charges_decay_timer", {
	useGameTime = true,
	endTime = keys.ChargeDecayTime,
	callback = function()
		if keys.ability:GetCurrentCharges() > 0 then
			print ("--> -1 Charge_BKB charge")
			keys.ability:SetCurrentCharges(keys.ability:GetCurrentCharges()-1) 
		end
		return keys.ChargeDecayTime
	end})
end
