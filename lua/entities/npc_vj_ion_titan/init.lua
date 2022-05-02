AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/burd/atlas_pm/atlas_pm.mdl"}
ENT.StartHealth = 10000 

function ENT:FollowPlayerCode(key, activator, caller, data)
	if self.Dead == true then return end
	if Titan_InTitan(activator) then 
		self.USED = false
		return 
	else
		if IsValid(activator) && activator:IsPlayer() && activator:Alive() then
			if self.FollowingPlayer == false then
				activator:StripWeapons()
				activator:Give("weapon_fluence") 
				TitanDUC = 50
				TitanClassSpeed = 1.25
				TitanEntity = "npc_vj_ion_titan"
				TitanClassModel = "models/burd/atlas_pm/atlas_pm.mdl"
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


