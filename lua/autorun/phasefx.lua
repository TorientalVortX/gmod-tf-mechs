AddCSLuaFile()

hook.Add( "PlayerSwitchWeapon", "WeaponSwitchExample", function( ply, oldWeapon, newWeapon ) 
    if SERVER then
        if ply:IsValid() == true and ply:GetActiveWeapon():IsValid() == true then
            if ply:GetRenderMode() == RENDERMODE_TRANSCOLOR and ply:GetActiveWeapon():GetPrintName() == "Phase Shift" then
                return true
            end
        end
    end
end)

net.Receive( "phase_effectson", function()
            if CLIENT then
                ply = LocalPlayer()
                hook.Add( "RenderScreenspaceEffects", "phasefx", function()
                    if ply:IsValid() == true and ply:GetActiveWeapon():IsValid() == true then
                        if ply:GetActiveWeapon():GetPrintName() == "Phase Dash" then
                            DrawMaterialOverlay( "models/shadertest/predator", 0.075 )
                
                            DrawColorModify({
                                [ "$pp_colour_addr" ] = 0,
                                [ "$pp_colour_addg" ] = 0,
                                [ "$pp_colour_addb" ] = 0,
                                [ "$pp_colour_brightness" ] =  -0.6,
                                [ "$pp_colour_contrast" ] = -2,
                                [ "$pp_colour_colour" ] = 0,
                                [ "$pp_colour_mulr" ] = 0,
                                [ "$pp_colour_mulg" ] = 0,
                                [ "$pp_colour_mulb" ] = 0
                            })
                        end
                    end
                end )
                timer.Simple(2.5,function()
                    hook.Add( "RenderScreenspaceEffects", "phasefx", function()
                        if ply:IsValid() == true and ply:GetActiveWeapon():IsValid() == true then
                            if ply:GetActiveWeapon():GetPrintName() == "Phase Shift" then
                                DrawMaterialOverlay( "models/shadertest/predator", 0. )
                    
                                DrawColorModify({
                                    [ "$pp_colour_addr" ] = 0,
                                    [ "$pp_colour_addg" ] = 0,
                                    [ "$pp_colour_addb" ] = 0,
                                    [ "$pp_colour_brightness" ] =  0,
                                    [ "$pp_colour_contrast" ] = 1,
                                    [ "$pp_colour_colour" ] = 1,
                                    [ "$pp_colour_mulr" ] = 0,
                                    [ "$pp_colour_mulg" ] = 0,
                                    [ "$pp_colour_mulb" ] = 0
                                })
                            end
                        end
                    end )
                end)
        end
end )
