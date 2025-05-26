function GTA5_PauseMenu:GetValueMoney()
    return DarkRP.formatMoney(LocalPlayer():getDarkRPVar("money"))
end 

function GTA5_PauseMenu:RegisterPanel(tPanel)
    if not tPanel or not tPanel.sName or not tPanel.Open or not tPanel.iOrder then
        error("Invalid panel registration: " .. tostring(tPanel))
        return
    end

    if not GTA5_PauseMenu.Meta.Panels then
        GTA5_PauseMenu.Meta.Panels = {}
    end

    GTA5_PauseMenu.Meta.Panels[tPanel.iOrder] = tPanel


end

function GTA5_PauseMenu:GetPanel(sName)
    if not GTA5_PauseMenu.Meta.Panels then
        return nil
    end

    for _, tPanel in pairs(GTA5_PauseMenu.Meta.Panels) do
        if tPanel.sName == sName then
            return tPanel
        end
    end

    return nil
end

function GTA5_PauseMenu:GetPanels()
    if not GTA5_PauseMenu.Meta.Panels then
        return {}
    end

    return GTA5_PauseMenu.Meta.Panels 
end