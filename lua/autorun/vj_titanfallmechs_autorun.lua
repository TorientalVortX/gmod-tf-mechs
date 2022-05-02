------------------ Addon Information ------------------
local PublicAddonName = "Titanfall 2 Titans"
local AddonName = "titanfallmechs"
local AddonType = "Interactive NPCs"
-- local AutorunFile = "autorun/vj_as_autorun.lua"
-------------------------------------------------------
local VJExists = file.Exists("lua/autorun/vj_base_autorun.lua","GAME")
if VJExists == true then
	include('autorun/vj_controls.lua')

	local vCat = "Titanfall" -- Category, you can also set a category individually by replacing the vCat with a string value
	VJ.AddNPC_HUMAN("Vanguard-class Titan", "npc_vj_vanguard_titan", {"weapon_xo16btr_npc"}, vCat) -- Adds a NPC to the spawnmenu but with a list of weapons it spawns with
	VJ.AddNPC_HUMAN("Ion-class Titan", "npc_vj_ion_titan", {"weapon_xo16btr_npc"}, vCat)
	VJ.AddNPC_HUMAN("Scorch-class Titan", "npc_vj_scorch_titan", {"weapon_xo16btr_npc"}, vCat)
	VJ.AddNPC_HUMAN("Ronin-class Titan", "npc_vj_ronin_titan", {"weapon_xo16btr_npc"}, vCat)
	VJ.AddNPC_HUMAN("CNG-3889 'Carnage'", "npc_vj_ronin_carnage_titan", {"weapon_xo16btr_npc"}, vCat)
	VJ.AddNPCWeapon("XOBTR-16A2 Chaingun (NPC)", "weapon_xo16btr_npc") -- Adds a weapon to the NPC weapon list
	
	-- Precache Models --
	util.PrecacheModel("models/example_model.mdl")
	

	
-- !!!!!! DON'T TOUCH ANYTHING BELOW THIS !!!!!! -------------------------------------------------------------------------------------------------------------------------
	AddCSLuaFile(AutorunFile)
	VJ.AddAddonProperty(AddonName,AddonType)
else
	if (CLIENT) then
		chat.AddText(Color(0,200,200),PublicAddonName,
		Color(0,255,0)," was unable to install, you are missing ",
		Color(255,100,0),"VJ Base!")
	end
	timer.Simple(1,function()
		if not VJF then
			if (CLIENT) then
				VJF = vgui.Create("DFrame")
				VJF:SetTitle("ERROR!")
				VJF:SetSize(790,560)
				VJF:SetPos((ScrW()-VJF:GetWide())/2,(ScrH()-VJF:GetTall())/2)
				VJF:MakePopup()
				VJF.Paint = function()
					draw.RoundedBox(8,0,0,VJF:GetWide(),VJF:GetTall(),Color(200,0,0,150))
				end
				
				local VJURL = vgui.Create("DHTML",VJF)
				VJURL:SetPos(VJF:GetWide()*0.005, VJF:GetTall()*0.03)
				VJURL:Dock(FILL)
				VJURL:SetAllowLua(true)
				VJURL:OpenURL("https://sites.google.com/site/vrejgaming/vjbasemissing")
			elseif (SERVER) then
				timer.Create("VJBASEMissing",5,0,function() print("VJ Base is Missing! Download it from the workshop!") end)
			end
		end
	end)
end