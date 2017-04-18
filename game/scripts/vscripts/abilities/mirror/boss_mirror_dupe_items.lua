
LinkLuaModifier("modifier_boss_mirror_dupe_items", "abilities/mirror/boss_mirror_dupe_items.lua", LUA_MODIFIER_MOTION_NONE)


boss_mirror_dupe_items = class({})

function boss_mirror_dupe_items:GetIntrinsicModifierName()
  return "modifier_boss_mirror_dupe_items"
end


modifier_boss_mirror_dupe_items = class({})

function modifier_boss_mirror_dupe_items:DeclareFunctions()
  return {
    MODIFIER_EVENT_ON_ATTACKED
  }
end

function modifier_boss_mirror_dupe_items:OnAttacked(keys)
  local attacker = keys.attacker
  local target = keys.target
  local caster = self:GetCaster()

  if caster ~= target then
    return
  end

  self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor('cooldown'))

  for slot=DOTA_ITEM_SLOT_1,DOTA_ITEM_SLOT_6 do
    local theirItem = target:GetItemInSlot(slot)
    local oldItem = caster:GetItemInSlot(slot)

    if oldItem then
      caster:RemoveItem(oldItem)
    end

    if theirItem then
      local ourItem = caster:AddItemByName(theirItem:GetAbilityName())

      if ourItem:RequiresCharges() then
        local charges = theirItem:GetCurrentCharges()
        ourItem:SetCurrentCharges(charges)
      end
    end
  end
end
