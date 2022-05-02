AddCSLuaFile()
if SERVER then
    util.AddNetworkString("phase_effectson")
end
resource.AddFile( "sound/activate.wav" )
resource.AddFile( "sound/end.wav" )
resource.AddFile( "sound/exit.wav" )
resource.AddFile( "sound/loop.wav" )
resource.AddFile( "sound/atlas_eject_propulsion_01.wav" )
resource.AddFile( "sound/atlas_eject_propulsion_03.wav" )
resource.AddFile( "sound/atlas_eject_propulsion_03.wav" )
resource.AddFile( "sound/diaggstitanBtembark01.wav" )
resource.AddFile( "sound/diaggstitanBtembark02.wav" )
resource.AddFile( "sound/diaggstitanBtembark03.wav" )
resource.AddFile( "sound/diaggstitanBtembark04.wav" )
resource.AddFile( "sound/o2scrcoremeltdownexplosion.wav" )

if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID( "ui/menu/items/phaseshift" )
end
SWEP.BounceWeaponIcon = false
SWEP.PrintName = "Phase Dash"
SWEP.Author = "Benji"
SWEP.Purpose = "Allows the user to become invulnerable and invisible by entering an alternate dimension."
SWEP.Category = "Titanfall"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawCrosshair = false
SWEP.Spawnable = false
SWEP.m_WeaponDeploySpeed = 10
SWEP.ViewModel = Model( "models/weapons/c_slam.mdl" )
SWEP.WorldModel = nil
SWEP.ViewModelFOV = 40
SWEP.UseHands = true
SWEP.BobScale = 0.3
SWEP.SwayScale = 0.5
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false
SWEP.AdminOnly = false

function SWEP:CanBePickedUpByNPCs()
	return false
end

function SWEP:PrimaryAttack()
    if !Titan_InTitan(self:GetOwner()) then
        self:GetOwner():SetActiveWeapon(oldtitanabilitywep)
        self:GetOwner():ChatPrint("You're not a Titan! You can't use this ability!")
    else
        if SERVER then
            net.Start("phase_effectson", false )
                net.WriteBool( true )
            net.Send(self:GetOwner())
        end

        self:SendWeaponAnim(263) -- normal press
        function particle()
            if ( IsFirstTimePredicted() ) then
                local fx = EffectData()
                fx:SetOrigin(self:GetOwner():GetPos()+Vector(0,0,45))
                fx:SetScale(1)
                util.Effect("cball_explode",fx)
            end
        end
        self:ShootEffects(self)
        self:SetRenderMode( RENDERMODE_TRANSCOLOR )
            self:GetOwner():SetRenderMode( RENDERMODE_TRANSCOLOR ) 
            self:SetColor( Color(255, 255, 255, 0) )
            self:GetOwner():SetColor( Color(255, 255, 255, 0) )
            self:EmitSound( "activate.wav" )
            local PhaseDashOrigRun = self:GetOwner():GetRunSpeed()
            local PhaseDashOrigWalk = self:GetOwner():GetWalkSpeed()
            self:GetOwner():SetRunSpeed(PhaseDashOrigRun * 1.5)
            self:GetOwner():SetWalkSpeed(PhaseDashOrigRun * 1.5)
            self:GetOwner():EmitSound( "loop.wav" )
            self:SetNextPrimaryFire( CurTime()+1)
            particle()
        if ( SERVER ) then
            self:GetOwner():CrosshairDisable()
            self:GetOwner():SetNoTarget(true)
            self:GetOwner():GodEnable()
        end
        timer.Simple(0.5,function() 
            self:GetOwner():SetRunSpeed(PhaseDashOrigRun)
            self:GetOwner():SetWalkSpeed(PhaseDashOrigWalk)
        end)
        timer.Simple(1.5,function() 
            if self:IsValid() == true then 
                self:EmitSound( "end.wav" ,100) 
            end 
        end)
        timer.Simple(2.5,function()
            if self:IsValid() == true then
                self:SetRenderMode( RENDERMODE_NORMAL ) 
                    self:GetOwner():SetRenderMode( RENDERMODE_NORMAL ) 
                    self:SetColor( Color(255, 255, 255, 255) )
                    self:GetOwner():SetColor( Color(255, 255, 255, 255) )
                    self:EmitSound( "exit.wav" )
                    self:GetOwner():StopSound( "loop.wav",30 )
                    particle()
                if ( SERVER ) then
                    self:GetOwner():CrosshairEnable()
                    self:GetOwner():SetNoTarget(false)
                    self:GetOwner():GodDisable()
                    self:GetOwner():SetActiveWeapon(oldtitanabilitywep)

                end
            end
        end)
    end
end

function SWEP:Deploy()
    self:PrimaryAttack( true )
end

function SWEP:ShouldDropOnDie() return true end

function SWEP:GetViewModelPosition(EyePos, EyeAng)
        
		EyeAng:RotateAroundAxis(EyeAng:Right(), -10 )
		EyeAng:RotateAroundAxis(EyeAng:Up(), -1 )
		EyeAng:RotateAroundAxis(EyeAng:Forward(), 40 )

	local Right 	= EyeAng:Right() 
	local Up 		= EyeAng:Up()
	local Forward 	= EyeAng:Forward()

	EyePos = EyePos + 2 * Right 
	EyePos = EyePos + -5 * Forward 
	EyePos = EyePos + 3 * Up 
	
	return EyePos, EyeAng
end

function SWEP:Reload()
	self:SetHoldType( "normal" )
    self:SendWeaponAnim(261)
end

function SWEP:SecondaryAttack() 

end

hook.Add("PlayerSpawn","phasereset",function(ply)
    ply:SetRenderMode( RENDERMODE_NORMAL ) 
    ply:SetColor( Color(255, 255, 255, 255) )
    ply:SetRunSpeed(400)
    ply:SetWalkSpeed(200)
    ply:SetCrouchedWalkSpeed(0.30000001192093)
end)