AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/orge/orge.mdl"} -- NEEDS TO BE AN NPC MODEL
ENT.StartHealth = 12500 -- THIS WILL DETERMINE PLAYER HP AS WELL

function ENT:FollowPlayerCode(key, activator, caller, data)
	if self.Dead == true then return end
	if Titan_InTitan(activator) then 
		self.USED = false
		return 
	else
		if IsValid(activator) && activator:IsPlayer() && activator:Alive() then
			if self.FollowingPlayer == false then
				--RIGHT HERE ARE ALL THE CUSTOM STATS FOR THE TITAN WHEN IT'S ADDED
				activator:StripWeapons()
				activator:Give("rw_sw_nade_incendiary") -- WEAPONS THAT THE PLAYER GETS. YOU CAN COPY PASTE MULTIPLE LINES.
				activator:GiveAmmo(9999, 10, true)
				TitanDUC = 100
				TitanClassSpeed = 1.1 -- SPEED MULTIPLIER. 1.25 IS ATLAS SPEED.
				TitanEntity = "npc_vj_scorch_titan" -- CURRENTLY UNUSED. IT'S FOR THE PLANNED EMBARK FEATURE
				TitanClassModel = "models/orge/orge.mdl" -- THIS IS THE PLAYERMODEL, NOT THE NPC MODEL. THIS IS WHAT THE PLAYER IS SET TO.
				TitanSpecialJump = 0
				Titan_Embark( activator, self )
			end
		end
	end
end

function ENT:Think()
	self:SetModelScale(3.5,0)
	local ply = self:GetEquiper()
	if IsValid( ply ) then
		local e = ply:KeyDown( IN_USE )
		if !e or ply:GetPos():Distance( self:GetPos() + self:GetForward()*-72 ) > 50 then
			self:SetEquiper(nil)
			self:SetPercent(0)
		end
	end
end
