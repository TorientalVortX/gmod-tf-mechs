local TitanHud = Material("ui/titan_cockpit_hud")

local abilitysweps = {"weapon_phase_dash"}
hook.Add("PlayerSwitchWeapon", "abilitytest", function(ply, old, new)
	if !Titan_InTitan(ply) then return end
	if table.HasValue( abilitysweps, new ) then
		oldtitanabilitywep = old
	end
end)

hook.Add("Think", "TitanThink", function()

	for k,v in pairs( player.GetAll() ) do
		local speed 
		speed = Titan.MoveSpeed
		
		if !v.DefaultJumpPower then v.DefaultJumpPower = v:GetJumpPower() end
		if Titan_InTitan( v ) then	
			local mult = Titan.MoveSpeed / 100
			v:SetRunSpeed( speed * v.TitanClassSpeed )
			v:SetWalkSpeed( (speed * v.TitanClassSpeed)/1.5 )
			v:SetJumpPower(0 + v.TitanSpecialJump )
			v:SetCrouchedWalkSpeed( 0.3 )
			if v:GetBloodColor() != BLOOD_COLOR_MECH then
				v.OrigBlood = v:GetBloodColor()
				v:SetBloodColor( BLOOD_COLOR_MECH )
			end
			v:SetModelScale( 3.5,0 )
			v:SetViewOffsetDucked( Vector(0,0,98) )
			v:SetViewOffset( Vector(0,0,225	) )
		--else
			--v:SetStepSize(18)
			--v:SetRunSpeed( speed ) 
		--	v:SetWalkSpeed( speed/2 ) 
		--	v:SetJumpPower( v.DefaultJumpPower )
		--	v:SetCrouchedWalkSpeed( 0.3 )
		--	if v.OrigBlood and v:GetBloodColor() != v.OrigBlood then
		--		v:SetBloodColor( v.OrigBlood )
			--end

		end
	end
end	)

local noDmgTypes = {DMG_CRUSH, DMG_VEHICLE, DMG_FALL, DMG_DROWN, DMG_POISON, DMG_RADIATION, DMG_NERVEGAS, DMG_ACID}
local noRstTypes = {DMG_BLAST, DMG_BLAST_SURFACE, DMG_ENERGYBEAM}
local noDmgWeapons = {"tfa_tf_sniper", "tfa_tf_p2011"}
hook.Add( "EntityTakeDamage", "titantakedamage", function( ent, dmginfo )
	
	if !IsValid(ent) or !ent:IsPlayer() then return end
	if !Titan_InTitan( ent ) then return end

	rdmg = dmginfo:GetDamage()

	if table.HasValue( noDmgTypes, dmginfo:GetDamageType() ) or table.HasValue( noDmgWeapons, dmginfo:GetAttacker():GetActiveWeapon() ) then
		mult = 0
	else
		if !Titan_InTitan(dmginfo:GetAttacker()) and !table.HasValue( noRstTypes, dmginfo:GetDamageType() ) then
			mult = 0.5
		else
			mult = 1
		end
	end

	dmginfo:SetDamage( rdmg * mult )
	dmginfo:SetDamageForce(Vector(0,0,0))
end )

function Titan_Embark( ply, ent )
	if Titan_InTitan(ply) then 
		ent.USED = false
		return 
	else
		ply.TitanEjecting = 0	
		ply:SetLayerPlaybackRate( 1, 0.5 )
		ply.TitanDashDelay = CurTime()
		ply.StepNCrunchDelay = CurTime()
		ply.TitanDashUnits = 100
		ply.TitanHealth = ent:Health()
		ply.TitanPos = ent:GetPos()
		ply.TitanAng = ent:GetAngles()
		ply.OrigJump = ply:GetJumpPower()
		ply.OrigViewDucked = ply:GetViewOffsetDucked()
		ply.OrigView = ply:GetViewOffset()
		ply.OrigStep = ply:GetStepSize()
		ply:SetStepSize(130)
		ply:SetModelScale(3.5)
		ply:SetModel( ply.TitanClassModel )
		ply:SetSkin( ent:GetSkin() )
		ply:SetPos( ply.TitanPos )
		ply:SetEyeAngles( ply.TitanAng )
		ply:SetHealth( ply.TitanHealth )
		if ply.HasExosuit == true then
			ply.HasExosuit = false
			ply.ResetExo = true
		end
		ent:Remove()
	end
end

function Titan_Disembark( ply, ent )
	if !Titan_InTitan(ply) then return
	else
		ply:Freeze(true)
		timer.Simple(1, function()
			NewTitanHP = ply:Health()
			ply:SetModelScale( 1,0 )
			ply:SetViewOffset( Vector(0,0,64) )
			ply:SetViewOffsetDucked( Vector(0,0,28) )
			ply:SetJumpPower( 1 )
			ply:SetStepSize( 18 )
			ply.DisembarkPos = ply:GetPos()
			ply.DisembarkAng = ply:GetAngles()
			ply.NewDisembarkPos = ply.DisembarkPos+(ply:GetUp() * 170)+(ply:GetForward() * 100)
			ply:KillSilent()
			ply:Spawn()
			ply:SetPos(ply.NewDisembarkPos)
			ply:SetEyeAngles(ply.DisembarkAng)
			NewTitan = ents.Create(ply.TitanEntity)
			NewTitan:Spawn()
			NewTitan:Activate()
			NewTitan:SetHealth(NewTitanHP)
			NewTitan:SetPos(ply.DisembarkPos+Vector(0,0,20))
			NewTitan:SetAngles(ply.DisembarkAng)
			if ply.ResetExo == true then
				ply.HasExosuit = true
				ply.ResetExo = false
			end
		end)
	end
end

function Titan_PreEject( ply )

	if !Titan_InTitan(ply) or ply.TitanEjecting == 1 then return end
	ply.TitanEjecting = 1
	ply:EmitSound( "buttons/blip1.wav", 75, 100, 1 )
	ply:Freeze( true )
	ply:StripWeapons()
	ply:GodEnable()
	timer.Simple( 0.4, function() ply:EmitSound( "buttons/blip1.wav", 75, 100, 1 ) end )
	timer.Simple( 0.8, function() ply:EmitSound( "buttons/lightswitch2.wav", 75, 100, 1 ) end )
	timer.Simple( 1, function() ply:EmitSound( "phx/explode03.wav", 75, 100, 1 ) end )
	timer.Simple( 1.5, function() ply:EmitSound( "ambient/wind/wind_hit1.wav", 75, 100, 1 ) end )
	timer.Simple( 1, function()
		if !Titan_InTitan(ply) then return end
		ply.TitanEjecting = 0
		ply:GodDisable()
		ply:Freeze( false )
		ply:SetLayerPlaybackRate( 1, 1 )
		ply:SetModelScale( 1,0 )
		ply:SetViewOffset( Vector(0,0,64) )
		ply:SetViewOffsetDucked( Vector(0,0,28) )
		ply:SetJumpPower( 1 )
		ply:SetStepSize( 18 )
		ply.ResetPos = ply:GetPos()
		ply:KillSilent()
		util.BlastDamage( ply, ply, ply.ResetPos, 500, 500 )
		ply:Spawn()
		ply:SetPos(ply.ResetPos)
		ply:SetVelocity(Vector(0,0,2000))
		if ply.ResetExo == true then
			ply.HasExosuit = true
			ply.ResetExo = false
		end
		ParticleEffect("AP_impact_dirt", ply.ResetPos, Angle(0,0,0))
	end )
end 

function TitanAddonPanic( ply )
	ply:SetModelScale( 1,0 )
	ply:SetViewOffset( Vector(0,0,64) )
	ply:SetViewOffsetDucked( Vector(0,0,28) )
	ply:SetJumpPower( 1 )
	ply:SetStepSize( 18 )
	ply:Kill()
	ply:Spawn()
end

hook.Add( "DrawOverlay", "TitanMaterialHUD", function()
	for k,v in pairs( player.GetAll() ) do
		if Titan_InTitan( v ) then	
			DrawMaterialOverlay( "models/props_c17/fisheyelens", -0.06 )
		end
	end
end )

local ExecutionDamage = {DMG_CLUB, DMG_SLASH, DMG_GENERIC}
hook.Add( "PostEntityTakeDamage", "titanexecution", function( ply, dmginfo )
	if !Titan_InTitan(ply) or !Titan_InTitan(enemy) or !enemy:IsPlayer() or !ply:IsPlayer() then return end
	enemy = dmginfo:GetAttacker()
	local plyPos = ply:GetPos()
	local enemyPos = enemy:GetPos()
	--print(plyPos:Distance(enemyPos))
	if ply:Health() <= 2500 and table.HasValue(ExecutionDamage, dmginfo:GetDamageType()) and plyPos:Distance(enemyPos) < 200 then
		ply:Freeze( true )
		ply:GodEnable()
		--plyanim = ply:LookupSequence( "Seq_Preskewer" )
		--ply:DoAnimationEvent( plyanim )
		enemy:Freeze( true )
		enemy:GodEnable()
		--enemyanim = enemy:LookupSequence( "Seq_Baton_Swing" )
		--enemy:DoAnimationEvent( enemyanim )
		ply:ChatPrint("Execution started as victim! No animations yet!")
		enemy:ChatPrint("Execution started as attacker! No animations yet!")
		timer.Simple(0.2,function() ply:GodDisable() ply:TakeDamage(ply:Health()+2500, enemy) enemy:Freeze( false ) enemy:GodDisable() ply:ChatPrint("Execution over!") enemy:ChatPrint("Execution over!") end)
	end
end )

hook.Add("DoPlayerDeath", "titandeath", function(ply, atk, dmg)
	if !Titan_InTitan(ply) then return end
	ply:SetLayerPlaybackRate( 1, 1 )
	ply:SetModelScale( 1,0 )
	ply:SetViewOffset( Vector(0,0,64) )
	ply:SetViewOffsetDucked( Vector(0,0,28) )
	ply:SetJumpPower( 1 )
	ply:SetStepSize( 18 )
	ply.ResetPos = ply:GetPos()
	ParticleEffect("AP_impact_dirt", ply.ResetPos, Angle(0,0,0))
	ply:EmitSound( "phx/explode01.wav", 150, 100, 1 )
	util.BlastDamage( ply, ply, ply.ResetPos, 50, 500 )
end)

hook.Add("PostPlayerDeath", "titandeath", function(ply, atk, dmg)
	if !Titan_InTitan(ply) then return end
	ply:Spawn()
end)

hook.Add("PlayerSpawn", "nontitansetup", function(ply, transit)
	ply.RodeoStarted = 0
	ply.CurrentlyRodeoing = 0
end)

hook.Add("CanExitVehicle", "PlayerMotion", function( veh, ply )
    if veh == RodeoSeat then
		return false
	else
		return true
	end
end )

hook.Add("PlayerTick", "titanmoverules", function(ply, movedata, command)

	if !Titan_InTitan(ply) and Titan_InTitan(ply:GetGroundEntity()) and ply:GetGroundEntity():Alive() then
		if ply:KeyDown(IN_USE) and ply.RodeoStarted == 0 then
			RodeoFriendly = 1
			ply.CurrentlyRodeoing = 1
			ply.RodeoStarted = 1
			ply.RodeoTimer = 0
			RodeoFriendlyDelay = CurTime()
			RodeoVictim = ply:GetGroundEntity()
			RodeoAttacker = ply
			RodeoSeat = ents.Create('prop_vehicle_prisoner_pod')
			RodeoSeat:SetModel('models/nova/airboat_seat.mdl')
			RodeoSeat:Spawn()
			RodeoSeat:Activate()
			RodeoSeat:SetCollisionGroup(COLLISION_GROUP_WORLD)
			RodeoSeat:SetNotSolid(false)
			RodeoSeat:DrawShadow(false)
			RodeoSeat:SetColor(Color(0, 0, 0, 0))
			RodeoSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
			ply:SetAllowWeaponsInVehicle(true)
			timer.Simple(0.1, function() ply:EnterVehicle( RodeoSeat ) end)
			TitanRodeo()
		end
	end

    --print("Starting Rodeo!")
	--plyPos = ply:GetPos()
	--victimPos = RodeoVictim:GetPos()
	--ply:SetVelocity(RodeoVictim:GetVelocity())
	--if ply:KeyDown( IN_JUMP ) then
		--ply:ConCommand("+jump")
		--print("Ending rodeo!")
		--timer.Simple(0.1, function() ply:ConCommand("-jump") ply:SetVelocity(((ply:GetForward() * -1) * 300) + (ply:GetUp() * 1) * 30) end)
		--timer.Simple(0.4, function() ply:SetCollisionGroup(OldCollisionGroup) end)
		--ply.CurrentlyRodeoing = 0
		--ply.RodeoStarted = 0
	--end
	--if plyPos:Distance(victimPos) > 500 then
		--ply.CurrentlyRodeoing = 0
		--ply.RodeoStarted = 0
	--end

	if Titan_InTitan(ply) and StepNCrunchDelay < CurTime() and ply:KeyDown( IN_SPEED ) and ply:OnGround() then
		if ply:GetGroundEntity() and ply:GetGroundEntity():Health() > 0 then
			CrushDamage = DamageInfo()
			CrushDamage:SetDamage(500)
			CrushDamage:SetDamageType(1)
			ply:GetGroundEntity():TakeDamageInfo(CrushDamage)
			ply:EmitSound("physics/flesh/flesh_bloody_break.wav", 100, 100, 1, 0)
			StepNCrunchDelay = CurTime() + 0.1
		end
	end

	if Titan_InTitan(ply) then
		if ply.TitanDashDelay < CurTime() and ply.TitanBonusDash then
			ply.TitanDashUnits = math.Clamp(ply.TitanDashUnits+0.1+ply.TitanBonusDash, 0, 100)
		else
			if ply.TitanDashDelay < CurTime() then
				ply.TitanDashUnits = math.Clamp(ply.TitanDashUnits+0.1, 0, 100)
			end
		end
		ply:SetArmor(ply.TitanDashUnits)
		if ply:KeyDown( IN_JUMP ) and ply:OnGround() and ply:GetVelocity() ~= Vector(0,0,0) and ply.TitanDashUnits >= ply.TitanDUC and ply.TitanDashDelay < CurTime() then
			ply.TitanDashDelay = CurTime() + 0.7
			ply.TitanDashUnits = ply.TitanDashUnits - ply.TitanDUC
			ply.OldDashVeloc = ply:GetVelocity()
			ply:SetVelocity( Vector(ply.OldDashVeloc.x * 5, ply.OldDashVeloc.y * 5, ply.OldDashVeloc.z) )
			ply:SetGravity(100)
			timer.Simple(0.4, function() ply:SetGravity(1) end)
		end
	end
end)

function TitanRodeo( ply )
	if ply.CurrentlyRodeoing == 1 then
		RodeoSeat:SetPos(RodeoVictim:GetPos()+(RodeoVictim:GetUp() * 220)-(RodeoVictim:GetForward() * 65)+(RodeoVictim:GetRight() * 30))
		RodeoSeat:SetAngles(RodeoVictim:GetAngles()+Angle(0,-90,0))

		if RodeoAttacker:KeyDown(IN_WALK) and RodeoFriendly == 0 and RodeoFriendlyDelay < CurTime() then
			RodeoFriendly = 1
			RodeoAttacker:ChatPrint("You can now damage the titan you're rodeoing.")
			RodeoFriendlyDelay = CurTime()+1
		end

		if RodeoAttacker:KeyDown(IN_WALK) and RodeoFriendly == 1 and RodeoFriendlyDelay < CurTime() then
			RodeoFriendly = 0
			RodeoAttacker:ChatPrint("You can no longer damage the titan you're rodeoing.")
			RodeoFriendlyDelay = CurTime()+1
		end

		if RodeoAttacker:KeyDown(IN_JUMP) and ply.RodeoTimer < 100 then
			ply.RodeoTimer = math.Clamp(ply.RodeoTimer+5, 0, 100)
		end

		if RodeoAttacker:KeyDown(IN_JUMP) and ply.RodeoTimer >= 100 or !Titan_InTitan(RodeoVictim) then
			ply.RodeoStarted = 0
			ply.CurrentlyRodeoing = 0
			RodeoAttacker:SetAllowWeaponsInVehicle(false)
			RodeoAttacker:ChatPrint("Rodeo ended.")
			RodeoAttacker:SetPos(RodeoSeat:GetPos())
			RodeoAttacker:SetAngles(RodeoSeat:GetAngles())
			RodeoSeat:Remove()
			RodeoAttacker:SetVelocity(((RodeoAttacker:GetForward() * -1) * 300) + (RodeoAttacker:GetUp() * 1) * 30)
		end

		if !RodeoVictim:Alive() then
			ply.RodeoStarted = 0
			ply.CurrentlyRodeoing = 0
			RodeoAttacker:SetAllowWeaponsInVehicle(false)
			RodeoAttacker:ChatPrint("Rodeo ended.")
			RodeoSeat:Remove()
			RodeoAttacker:SetPos(RodeoVictim:GetPos()+(RodeoVictim:GetUp() * 2500)-(RodeoVictim:GetForward() * 205)+(RodeoVictim:GetRight() * 30))
			RodeoAttacker:SetAngles(RodeoVictim:GetAngles()+Angle(0,-90,0))
			RodeoAttacker:SetVelocity(((RodeoAttacker:GetForward() * -1) * 300) + (RodeoAttacker:GetUp() * 1) * 30)
		end
		if RodeoAttacker:GetVehicle() == RodeoSeat then
			RodeoAttacker:EnterVehicle( RodeoSeat )
		end
		if ply.ResetRodeo == 1 then
			RodeoSeat:Remove()
			ply.ResetRodeo = 0
			ply.RodeoStarted = 0
			ply.CurrentlyRodeoing = 0
			RodeoAttacker:SetAllowWeaponsInVehicle(false)
		end
	else
		if ply.ResetRodeo == 1 then
			RodeoSeat:Remove()
			ply.ResetRodeo = 0
			ply.RodeoStarted = 0
			ply.CurrentlyRodeoing = 0
			RodeoAttacker:SetAllowWeaponsInVehicle(false)
		end
	end
end

function RodeoReset( ply )
	ply.RodeoStarted = 0
	ply.CurrentlyRodeoing = 0
	ply.ResetRodeo = 1
end

function TitanTactical( ply )
	
end

function TitanUtility( ply )
	
end

function TitanOrdnance( ply )
	
end

function TitanCore( ply )
	
end

concommand.Add( "TitanEject", Titan_PreEject )
concommand.Add( "TitanDisembark", Titan_Disembark )
concommand.Add( "TitanAddonPanic", TitanAddonPanic )
concommand.Add( "TitanRodeoReset", RodeoReset )
concommand.Add( "TitanTactical", TitanTactical )
concommand.Add( "TitanUtility", TitanUtility )
concommand.Add( "TitanOrdnance", TitanOrdnance )
concommand.Add( "TitanCore", TitanCore )