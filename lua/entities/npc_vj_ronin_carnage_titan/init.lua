AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.Model = {"models/stryder/stryder.mdl"} -- NEEDS TO BE AN NPC MODEL
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
				activator.TitanDUC = 25
				activator.TitanBonusDash = 0.2
				activator.TitanBonus = 1
				activator.TitanClassSpeed = 1.5 -- SPEED MULTIPLIER. 1.25 IS ATLAS SPEED. 1.1 IS OGRE. 1.4 IS STRYDER
				activator.TitanEntity = "npc_vj_ronin_carnage_titan" -- CURRENTLY UNUSED. IT'S FOR THE PLANNED DISEMBARK FEATURE
				activator.TitanClassModel = "models/stryder/stryder.mdl" -- THIS IS THE PLAYERMODEL, NOT THE NPC MODEL. THIS IS WHAT THE PLAYER IS SET TO.
				activator.TitanSpecialJump = 0
				activator:Freeze(true)
				activator:GodEnable()
				activator:SetColor( Color(255, 255, 255, 0) )
				activator:SetRenderMode(RENDERMODE_TRANSCOLOR) 
				activator:StripWeapons() 
				activator:SetVelocity(Vector(0,0,0))
				timer.Simple(1, function() 
					--activator:SetColor( Color(255, 255, 255, 255) )
					--activator:SetRenderMode(RENDERMODE_NORMAL) 
					activator:Freeze(false) 
					activator:GodDisable() 
					Titan_Embark( activator, self ) 
					activator:Give("weapon_titan_fists")
					activator:Give("tf_xotbr16")
				end )
				
			end
		end
	end
end

function ENT:Think()
	self:SetSkin(2)
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
