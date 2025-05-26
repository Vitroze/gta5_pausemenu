hook.Add("VLib_Loaded", "VLib_Loaded:GTA5_PauseMenu", function()
    GTA5_PauseMenu = GTA5_PauseMenu or {}
    GTA5_PauseMenu.Version = "1.0.0"
    GTA5_PauseMenu.Config = GTA5_PauseMenu.Config or {}
    GTA5_PauseMenu.Meta   = GTA5_PauseMenu.Meta or {}

    local sDirectory = "gta5_pausemenu/"

    -- Client 
    VLib:loadFileClient(sDirectory .. "client/cl_function.lua")
    VLib:loadFileClient(sDirectory .. "client/cl_hook.lua")
    VLib:loadFileClient(sDirectory .. "client/cl_menu.lua")

    VLib:loadFileClient(sDirectory .. "client/tabs/cl_game.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_map.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_notify.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_online.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_settings.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_stats.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_leave.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_galerie.lua")
    VLib:loadFileClient(sDirectory .. "client/tabs/cl_boutique.lua")

    -- Server 
    VLib:loadFileServer(sDirectory .. "server/sv_function.lua")
    VLib:loadFileServer(sDirectory .. "server/sv_hook.lua")
    VLib:loadFileServer(sDirectory .. "server/sv_network.lua")

    -- Shared 
    VLib:loadFileShared(sDirectory .. "shared/sh_meta.lua")

    -- for _, vData in ipairs (file.Find(sDirectory .. "shared/languages/*.lua", "LUA")) do
    --     VLib:loadFileShared(sDirectory .. "shared/languages/" .. vData)
    -- end

    VLib:CheckVersion("gta5_pausemenu", GTA5_PauseMenu.Version, function(bGoodVersion, iVersionGitHub)
        if bGoodVersion then
            MsgC(Color(0, 255, 0), ("[GTA5_PauseMenu] You are running the latest version! (v%s) \n"):format(GTA5_PauseMenu.Version))
        else
            MsgC(Color(255, 0, 0), ("[GTA5_PauseMenu] There is a new version available! (v%s) \n"):format(iVersionGitHub))
        end
    end)

    resource.AddFile("resource/fonts/pricedown.ttf")
end)
resource.AddFile("resource/fonts/pricedown.ttf")
resource.AddFile("resource/fonts/monopolsemibold.ttf")
resource.AddFile("resource/fonts/monopoltrial_medium.ttf")
