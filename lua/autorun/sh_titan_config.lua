
Titan = {}

Titan.MoveSpeed = 500

Titan.Models = {
	"models/azimuth/titanfall_2/bt/titanbt7274_player.mdl",
	"models/burd/atlas_pm/atlas_pm.mdl",
	"models/stryder/stryder.mdl",
	"models/orge/orge.mdl",
}


function Titan_InTitan( ply )
	if IsValid(ply) then
		return table.HasValue( Titan.Models, ply:GetModel() )
	end
	return false
end	

hook.Add( "PlayerFootstep", "Titan:PlayerFootstep", function( ply, pos, foot, sound, volume, filter )
	
	if Titan_InTitan( ply ) then
		if CLIENT then return true end
		ply:EmitSound( "vehicles/v8/vehicle_impact_medium"..math.random(3,4)..".wav", 75, 50, 0.2 )
		return true
	end
end)


