function GTA5_PauseMenu:GetLangAuto(pPlayer)
    local sLang = IsValid(pPlayer) and pPlayer:GetInfo("gmod_language") or GetConVar("gmod_language"):GetString()

    if not file.Exists("gta5_pausemenu/shared/languages/" .. sLang .. ".lua", "LUA") then
        sLang = "en"
    end

    return sLang
end
