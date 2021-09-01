if SERVER then
	AddCSLuaFile()

	resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_liar.vmt")
end

function ROLE:PreInitialize()
	self.color = Color(155, 160, 120, 255)

	self.abbr = "liar" -- abbreviation
	self.survivebonus = 1                   -- points for surviving longer
	self.preventFindCredits = true          -- can't take credits from bodies
	self.preventKillCredits = true		    -- does not get awarded credits for kills
	self.preventTraitorAloneCredits = true  -- no credits.
	self.preventWin = false                 -- cannot win unless he switches roles
	self.scoreKillsMultiplier       = 2     -- gets points for killing enemies of their team
	self.scoreTeamKillsMultiplier   = -8    -- loses points for killing teammates
	self.defaultEquipment = INNO_EQUIPMENT  -- here you can set up your own default equipment
	self.disableSync = true 			    -- dont tell the player about his role

	-- settings for this roles teaminteraction
	self.unknownTeam = true -- Doesn't know his teammates -> Is innocent also disables voicechat
	self.defaultTeam = TEAM_INNOCENT -- Is part of team innocent

	-- ULX convars
	self.conVarData = {
		pct = 0.17,                         -- necessary: percentage of getting this role selected (per player)
		maximum = 1,                        -- maximum amount of roles in a round
		minPlayers = 8,                     -- minimum amount of players until this role is able to get selected
		credits = 0,                        -- the starting credits of a specific role
		shopFallback = SHOP_DISABLED,       -- Setting wether the role has a shop and who's shop it will use if no custom shop is set
		togglable = true,                   -- option to toggle a role for a client if possible (F1 menu)
		random = 33                         -- percentage of the chance that this role will be in a round (if set to 100 it will spawn in all rounds)
	}
end

function ROLE:Initialize()
	roles.SetBaseRole(self, ROLE_INNOCENT)
end

if SERVER then

	-- Add a convar to make the liar see himself as an Innocent
	hook.Add("TTT2SpecialRoleSyncing", "TTT2RoleLiarMod", function(ply, tbl)
		-- hide the role from all players (including himself)
		for liar in pairs(tbl) do
			if liar:GetSubRole() == ROLE_LIAR and liar:GetNWBool("SpawnedAsLiar", -1) == -1 then
				-- show innocent for himself
				if ply == liar then
					tbl[liar] = {ROLE_INNOCENT, TEAM_INNOCENT}
					
				-- show none for everyone else
				else
					tbl[liar] = {ROLE_NONE, TEAM_NONE}
				end
			end
		end
	end)

	-- Add that the Liar will be confirmed as an Traitor
	hook.Add("TTTCanSearchCorpse", "TTT2LiarChangeCorpseToTraitor", function(ply, corpse)
		-- Check if the Corpse is valid and if the Role was Liar
		if IsValid(corpse) and corpse.was_role == ROLE_LIAR then
			-- Make the Role show as Traitor
			corpse.was_role = ROLE_TRAITOR

			-- Make the Role Colour be that of an Traitor
			corpse.role_color = TRAITOR.color

			-- Save the Corpse's true role for reference
			corpse.is_liar_corpse = true
		end
	end)

	-- Add that the Liar will be shown as an Traitor on the Scoreboard
	hook.Add("TTT2ConfirmPlayer", "TTT2LiarChangeRoleToTraitor", function(confirmed, finder, corpse)
		-- Check if the corse is valid and if the Role was Liar
		if IsValid(confirmed) and corpse and corpse.is_liar_corpse then
			-- Make the Role show as Traitor on the scoreboard
			confirmed:ConfirmPlayer(true)
			SendRoleListMessage(ROLE_TRAITOR, TEAM_TRAITOR, {confirmed:EntIndex()})
			events.Trigger(EVENT_BODYFOUND, finder, corpse)

			return false
		end
	end)
end
