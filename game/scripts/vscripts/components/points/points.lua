-- Taken from bb template
if PointsManager == nil then
  DebugPrint ( '[points/PointsManager] Creating new PointsManager object.' )
  PointsManager = class({})
end

function PointsManager:Init ()
  DebugPrint ( '[points/PointsManager] Initialize.' )

  PointsManager.haveBadguysWon = false
  PointsManager.haveGoodguysWon = false
  PointsManager.goodguysName = "Radiant"
  PointsManager.badguysName = "Dire"

  if GameRules.GameLength == "long" then
    CustomNetTables:SetTableValue( "team_scores", "limit", { value = 200 } )
  elseif GameRules.GameLength == "short" then
    CustomNetTables:SetTableValue( "team_scores", "limit", { value = 50 } )
  else
    -- default to 100 in case of no selection / invalid selection
    CustomNetTables:SetTableValue( "team_scores", "limit", { value = 100 } )
  end

  -- set initial values for current scores
  CustomNetTables:SetTableValue( "team_scores", "score", { goodguys = 0,
                                                           badguys = 0
                                                         })

  -- Start Thinking
  Timers:CreateTimer(0, Dynamic_Wrap(PointsManager, "Think"))
end

function PointsManager:Think ()
  DebugPrint("[points/PointsManager] Thinking..")

  local interval = 5 -- when do we want to check for win conditions
  local limit = CustomNetTables:GetTableValue("team_scores", "limit").value
  local scores = CustomNetTables:GetTableValue("team_scores", "score")
  local goodguys = scores.goodguys
  local badguys = scores.badguys

  DebugPrintTable(limit)
  DebugPrintTable(scores)
  DebugPrint("haveGoodguysWon: " .. tostring(PointsManager.haveGoodguysWon))
  DebugPrint("haveBadguysWon: " .. tostring(PointsManager.haveBadguysWon))

  -- DEBUG
  PointsManager:IncrementScore(PointsManager.goodguysName)

  if PointsManager.haveGoodguysWon or PointsManager.haveBadguysWon then return end

  if goodguys >= limit then
    PointsManager:onTeamWin(PointsManager.goodguysName)
  elseif badguys >= limit then
    PointsManager:onTeamWin(PointsManager.badguysName)
  end

  return interval
end

function PointsManager:onTeamWin (side)
  --GameRules.SetMode(DOTA_GAMERULES_STATE_POST_GAME)
  DebugPrint("[points/PointsManager] " .. side .. " wins!")

  if side == PointsManager.goodguysName then
    haveGoodguysWon = true
  elseif side == PointsManager.badguysName then
    haveBadguysWon = true
  end

  CustomGameEventManager:Send_ServerToAllClients("points_won", {
    who=side
  })
end


function PointsManager:UpdateScore (score)
end

function PointsManager:SetScore (side, newScore)
  --DebugPrint("[points/PointsManager] Set Score of " .. side .. " to " .. newScore .. ".")

  local score = CustomNetTables:GetTableValue("team_scores", "score")

  if side == PointsManager.goodguysName then
    score.goodguys = newScore
  elseif side == PointsManager.badguysName then
    score.badguys = newScore
  end

  CustomNetTables:SetTableValue("team_scores", "score", score)
end

function PointsManager:IncrementScore (side)
  --DebugPrint("[points/PointsManager] Increase Score of " .. side .. " by one.")

  local score = CustomNetTables:GetTableValue("team_scores", "score")

  if side == PointsManager.goodguysName then
    score.goodguys = score.goodguys + 1
  elseif side == PointsManager.badguysName then
    score.badguys = score.badguys + 1
  end

  CustomNetTables:SetTableValue("team_scores", "score", score)
end
