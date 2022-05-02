AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/azimuth/titanfall_2/bt/npc/npc_titanbt7274.mdl"} -- NEEDS TO BE AN NPC MODEL
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
				activator:Give("tf_xotbr16") -- WEAPONS THAT THE PLAYER GETS. YOU CAN COPY PASTE MULTIPLE LINES.
				TitanDUC = 33
				TitanClassSpeed = 1.35 -- SPEED MULTIPLIER. 1.25 IS ATLAS SPEED.
				TitanEntity = "npc_vj_vanguard_titan" -- CURRENTLY UNUSED. IT'S FOR THE PLANNED EMBARK FEATURE
				TitanClassModel = "models/azimuth/titanfall_2/bt/titanbt7274_player.mdl" -- THIS IS THE PLAYERMODEL, NOT THE NPC MODEL. THIS IS WHAT THE PLAYER IS SET TO.
				TitanSpecialJump = 0
				self:EmitSound( "diag_gs_titanBt_embark_0"..math.random(1,4)..".wav", 75, 100)
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
