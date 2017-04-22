
-- Entry Function
function Spawn(entityKeyValues)
  local disabled = false
  if disabled then
    return
  end

  thisEntity:SetContextThink('StopFightingYourselfThink', partial(Think, thisEntity), 1)
  print("Starting AI for " .. thisEntity:GetUnitName() .. " " .. thisEntity:GetEntityIndex())

  ABILITY_dupe_heroes = thisEntity:FindAbilityByName('boss_stopfightingyourself_dupe_heroes')
end

function Think(state, target)
  -- NOTE: I'm thinking too long
  -- BUG: Not attacking
  -- BUG: illusions do not get deleted correctly
  if not thisEntity:IsAlive() then
    if thisEntity.illusions then
      for i, illusion in ipairs(thisEntity.illusions) do
        illusion:ForceKill(false)
        if not illusion:IsNull() then
          illusion:RemoveSelf()
        end
      end
      thisEntity.illusions = nil
    end
    return 0
  end

  -- Leash
  if not GLOBAL_origin then
    GLOBAL_origin = thisEntity:GetAbsOrigin()
  else
    local distance = (GLOBAL_origin - thisEntity:GetAbsOrigin()):Length()
    if distance > 1000 then
      ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = GLOBAL_origin, --Optional.  Only used when targeting the ground
        Queue = 0 --Optional.  Used for queueing up abilities
      })
      return 5
    end
  end

  if thisEntity:IsIdle() and IsHeroInRange(thisEntity:GetAbsOrigin(), 900) then
    UseRandomItem()

    IllusionsCast()

    ExecuteOrderFromTable({
      UnitIndex = thisEntity:entindex(),
      OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
      Position = GLOBAL_origin + RandomVector(400),
      Queue = true
    })
  end


  return 0.1
end

function UseRandomItem()
  local item = thisEntity:GetItemInSlot(RandomInt(DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6))

  if item ~= nil and item:IsItem() and not item:IsRecipe() then
    if item:IsFullyCastable() and item:IsOwnersManaEnough() then
      local target = ClosestHeroInRange(thisEntity:GetAbsOrigin(), 1000)
      --local range = item:GetCastRange(thisEntity:GetAbsOrigin(), target)
      --local range = item:GetCastRange(nil, nil)

      if target then
        UseAbility(item, thisEntity, target, 800)
        return true
      end
    end
  end
end

function IllusionsCast()
  if ABILITY_dupe_heroes:IsFullyCastable() then
    ExecuteOrderFromTable({
      UnitIndex = thisEntity:entindex(),
      OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
      AbilityIndex = ABILITY_dupe_heroes:entindex(), --Optional.  Only used when casting abilities
    })
  end
end

function UseAbility(ability, caster, target, maxRange)
  local randomPosition = RandomVector(maxRange) + caster:GetAbsOrigin()
  local behavior = ability:GetBehavior()

  -- Ability's behavior is
  if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE) ~= 0 then
    -- passive
  elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_AUTOCAST) ~= 0 and not ability:GetAutoCastState() then
    ExecuteOrderFromTable({
      UnitIndex = caster:entindex(),
      OrderType = DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO,
      AbilityIndex = ability:entindex(), --Optional.  Only used when casting abilities
      Queue = 0 --Optional.  Used for queueing up abilities
    })
  elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
    -- point
    if randomPosition then
      ExecuteOrderFromTable({
        UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
        AbilityIndex = ability:entindex(), --Optional.  Only used when casting abilities
        Position = randomPosition,
        Queue = true --Optional.  Used for queueing up abilities
      })
    end
  elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
    -- no target
    ExecuteOrderFromTable({
      UnitIndex = caster:entindex(),
      OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
      AbilityIndex = ability:entindex(), --Optional.  Only used when casting abilities
      Queue = 0 --Optional.  Used for queueing up abilities
    })
  elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
    -- target
    ExecuteOrderFromTable({
      UnitIndex = caster:entindex(),
      OrderType = order,
      TargetIndex = target:entindex(), --Optional.  Only used when targeting units
      AbilityIndex = ability:entindex(), --Optional.  Only used when casting abilities
      Queue = 0 --Optional.  Used for queueing up abilities
    })
  elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) ~= 0 and not ability:IsActivated() then
    -- toggle
    ExecuteOrderFromTable({
      UnitIndex = caster:entindex(),
      OrderType = DOTA_UNIT_ORDER_CAST_TOGGLE,
      AbilityIndex = ability:entindex(), --Optional.  Only used when casting abilities
      Queue = 0 --Optional.  Used for queueing up abilities
    })
  end
end

function RandomHeroInRange(position, range)
  return FindUnitsInRadius(
    DOTA_TEAM_NEUTRALS,
    position,
    nil,
    range,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER,
    false
  )[1]
end

function ClosestHeroInRange(position, range)
  return FindUnitsInRadius(
    DOTA_TEAM_NEUTRALS,
    position,
    nil,
    range,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_CLOSEST,
    false
  )[1]
end

function IsHeroInRange(position, range)
  return FindUnitsInRadius(
    DOTA_TEAM_NEUTRALS,
    position,
    nil,
    range,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO,
    DOTA_UNIT_TARGET_FLAG_NONE,
    FIND_ANY_ORDER,
    false
  )[1] ~= nil
end

function RandomTreeInRange(range)
  return FindByNameWithin(nil, "ent_dota_tree", thisEntity:GetAbsOrigin(), range)
end
