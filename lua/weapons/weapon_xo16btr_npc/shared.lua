if (!file.Exists("autorun/vj_base_autorun.lua","LUA")) then return end
---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.Base = "weapon_vj_base"
SWEP.PrintName = "XOTBR-16A2 Chaingun"
SWEP.Author = "DrVrej"
SWEP.Contact = "http://steamcommunity.com/groups/vrejgaming"
SWEP.Purpose = "This weapon is made for Players and NPCs"
SWEP.Instructions = "Controls are like a regular weapon."
SWEP.Category = "VJ Base Dummies"
	-- Main Settings ---------------------------------------------------------------------------------------------------------------------------------------------
SWEP.ViewModel = "" -- The view model (First person)
SWEP.WorldModel = "models/weapons/w_tf_bigfuckinggun.mdl" -- The world model (Third person, when a NPC is holding it, on ground, etc.)
SWEP.HoldType = "ar2" -- List of holdtypes are in the GMod wiki

SWEP.MadeForNPCsOnly = true -- Is this weapon meant to be for NPCs only?