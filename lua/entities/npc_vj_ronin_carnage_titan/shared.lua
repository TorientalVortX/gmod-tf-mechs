ENT.Base 			= "npc_vj_human_base" -- List of all base types: https://github.com/DrVrej/VJ-Base/wiki/Base-Types
ENT.Type 			= "ai"
ENT.PrintName 		= "CNG-3889 'Carnage'"
ENT.Author 			= "Benji"
ENT.Contact 		= ""
ENT.Purpose 		= "An NPC Titan capable of being embarked."
ENT.Instructions 	= "Click on the spawnicon to spawn it."
ENT.Category		= "Titans"

function ENT:SetupDataTables()
	
	self:NetworkVar( "Entity", 1, "Equiper", { 
		KeyName = "Equiper", 
		Edit = { type = "Entity", order = 1 } 
	} )
	
	self:NetworkVar( "Int", 1, "Percent", { 
		KeyName = "Percent", 
		Edit = { type = "Int", min = 0, max = 100, order = 1 } 
	} )
	
end	