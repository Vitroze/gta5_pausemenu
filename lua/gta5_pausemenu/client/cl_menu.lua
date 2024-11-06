local function getImageModel()

    if not file.Exists("gta5_pausemenu", "DATA") then
        file.CreateDir("gta5_pausemenu")
    end

    LocalPlayer().sOldModel = LocalPlayer().sOldModel or LocalPlayer():GetModel()
    local sFileName = ("gta5_pausemenu/spawnicon_player_%s.png"):format(LocalPlayer().sOldModel:lower():sub(1, -5):Replace("/", "_"))

    if not file.Exists(sFileName, "DATA") then
        local lookAtPos, cameraPos = Vector(0, 0, 65), Vector(50, 0, 60)
        local eEntity = ClientsideModel(LocalPlayer():GetModel())
        if not IsValid(eEntity) then return end
        eEntity:SetNoDraw(true) 
        local rtPlayer = GetRenderTarget("ModelIconRenderTarget_" .. os.time(), 512, 512)

        render.PushRenderTarget(rtPlayer)
        render.Clear(0, 0, 0, 255) 
        render.ClearDepth()

 
        cam.Start3D(cameraPos, (lookAtPos - cameraPos):Angle(), 20, 0, 0, 512, 512)
            eEntity:DrawModel()  
        cam.End3D()

        local tData = {
            x = 0,
            y = 0,
            w = 512,
            h = 512,
            format = "png",
            alpha = true
        }
        local tImageData = render.Capture(tData)

        eEntity:Remove()
        render.PopRenderTarget()

        file.Write(sFileName, tImageData)

        return ("data/gta5_pausemenu/spawnicon_player_%s.png"):format(LocalPlayer().sOldModel:lower():sub(1, -5):Replace("/", "_"))
    elseif LocalPlayer().sOldModel ~= LocalPlayer():GetModel() then
        LocalPlayer().sOldModel = LocalPlayer():GetModel()
        file.Delete(sFileName)
        return getImageModel()
    else
        return ("data/gta5_pausemenu/spawnicon_player_%s.png"):format(LocalPlayer().sOldModel:lower():sub(1, -5):Replace("/", "_"))
    end
end



local fTitle_GAME = VLib:CreateFonts("Pricedown", true, 30, 700, {
    antialias = true,
    shadow = true,
})
local fInfo_Game = VLib:CreateFonts("Arial", true, 18, 500, {
    antialias = true,
    shadow = true,
})
local fOnglets_Game = VLib:CreateFonts("Montserrat", true, 20, 500, {
    antialias = true,
    shadow = false,
})

function GTA5_PauseMenu:OpenMenu()
    if IsValid(self.Menu) then
        self.Menu:Remove()
    end

    self.Menu = vgui.Create("DFrame")
    self.Menu:SetSize(ScrW(), ScrH())
    self.Menu:MakePopup()
    self.Menu:Center()

    self.Menu.Paint = function(selfMenu, w, h)
        Derma_DrawBackgroundBlur(self.Menu)
    end

    local DPanel_Info = vgui.Create("DPanel", self.Menu)
    DPanel_Info:SetSize(VLib:RX(1302), VLib:RY(74))
    DPanel_Info:SetPos(self.Menu:GetWide()/2 - DPanel_Info:GetWide() / 2, VLib:RY(96))

    DPanel_Info.Paint = function(selfPanel, w, h)
        draw.SimpleText("Grand Thef Auto V", fTitle_GAME, 0, 26, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
      --  draw.SimpleText("GTA5 Pause Menu", "VBFONT_Regular40", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(LocalPlayer():Nick(), fInfo_Game, VLib:RX(1212), VLib:RY(2), color_white, TEXT_ALIGN_RIGHT)
        draw.SimpleText(os.date("%A %H:%M"), fInfo_Game, VLib:RX(1212), VLib:RY(26), color_white, TEXT_ALIGN_RIGHT)
        draw.SimpleText(GTA5_PauseMenu:GetValueMoney(), fInfo_Game, VLib:RX(1212), VLib:RY(50), color_white, TEXT_ALIGN_RIGHT)

        draw.RoundedBox(0, VLib:RX(1233), VLib:RY(0), VLib:RX(69), VLib:RY(69), Color(0, 0, 0))
    end
    
    -- local DSpawnIcon = vgui.Create("SpawnIcon", DPanel_Info)
    -- DSpawnIcon:SetSize(VLib:RY(69), VLib:RY(69))
    -- DSpawnIcon:SetPos(VLib:RX(1233), VLib:RY(0))
    -- DSpawnIcon:SetModel(LocalPlayer():GetModel())
    -- DSpawnIcon:SetTooltip("")

    -- local DModelPanel_Player = vgui.Create("DModelPanel", DPanel_Info)
    -- DModelPanel_Player:SetSize(VLib:RY(69), VLib:RY(69))
    -- DModelPanel_Player:SetPos(VLib:RX(1233), VLib:RY(0))
    -- DModelPanel_Player:SetModel(LocalPlayer():GetModel())
    -- DModelPanel_Player:SetTooltip("")
    -- DModelPanel_Player:SetFOV(10)
    -- DModelPanel_Player.LayoutEntity = function(self, ent)
    --     ent:SetAngles(Angle(0, 45, 0))
    --     ent:SetPos(Vector(0, -2, -25))
    -- end


    local DImage_Player = vgui.Create("DImage", DPanel_Info)
    DImage_Player:SetSize(VLib:RY(69), VLib:RY(69))
    DImage_Player:SetPos(VLib:RX(1233), VLib:RY(0))
    DImage_Player:SetImage(getImageModel())

    local tButtons = {
        {
            sName = "Carte",
            sColorHover = Color(104, 179, 211, 255),
            PANEL = function() end,
        },
        {
            sName = "Infos",
            sColorHover = Color(0, 0, 0, 100),
            PANEL = function() end,
        },
        {
            sName = "Statistiques",
            sColorHover = Color(0, 0, 0, 100),
            PANEL = function() end,
        },
        {
            sName = "Paramètres",
            sColorHover = Color(0, 0, 0, 100),
            PANEL = function() end,
        },
        {
            sName = "Jeu",
            sColorHover = Color(0, 0, 0, 100),
            PANEL = function() end,
        },
        {
            sName = "En Ligne",
            sColorHover = Color(0, 0, 0, 100),
            PANEL = function() end,
        },
        {
            sName = "Quitter",
            sColorHover = Color(0, 0, 0, 100),
            PANEL = function() end,
        },
        -- ["Infos"] = {
        --     sColorHover = Color(0, 0, 0, 100),
        --     PANEL = function() end,
        -- },
        -- ["Statistiques"] = {
        --     sColorHover = Color(0, 0, 0, 100),
        --     PANEL = function() end,
        -- },
        -- ["Paramètres"] = {
        --     sColorHover = Color(0, 0, 0, 100),
        --     PANEL = function() end,
        -- },
        -- ["Jeu"] = {
        --     sColorHover = Color(0, 0, 0, 100),
        --     PANEL = function() end,
        -- },
        -- ["En Ligne"] = {
        --     sColorHover = Color(0, 0, 0, 100),
        --     PANEL = function() end,
        -- },
        -- -- ["Quitter"] = {
        -- --     sColorHover = Color(0, 0, 0, 100),
        -- --     PANEL = function() end,
        -- -- },
    }

    local DPanel_Buttons = vgui.Create("DPanel", self.Menu)
    DPanel_Buttons:SetSize(VLib:RX(1302), VLib:RY(47))
    DPanel_Buttons:SetPos(self.Menu:GetWide()/2 - DPanel_Buttons:GetWide() / 2, VLib:RY(173))
    DPanel_Buttons.Paint = function() end

    local DHorizontalScroller = vgui.Create("DHorizontalScroller", DPanel_Buttons)
    DHorizontalScroller:Dock(FILL)
    DHorizontalScroller:DockMargin(0, 0, 0, 0)
    DHorizontalScroller:DockPadding(0, 0, 0, 0)
    
    for _, tData in pairs(tButtons) do
        local DButton = vgui.Create("DButton", DHorizontalScroller)
        DButton:SetSize(VLib:RX(215), VLib:RY(47))
        DButton:Dock(LEFT)
        DButton:DockMargin(0, 0, 3, 0) 
        DButton:SetText("")
        DButton.bSelected = false
        -- DButton:SetFont(fInfo_Game)
        -- DButton:SetTextColor(color_white)
        DButton.Paint = function(selfButton, w, h)
            draw.RoundedBox(0, 0, 9, w, h - 9, selfButton.bSelected and Color(240, 240, 240) or Color(20, 21, 26, 255))

            if selfButton.bSelected then
                draw.RoundedBox(0, 0, 0, w, 9, tData.sColorHover)
            end

            draw.SimpleText(tData.sName, fOnglets_Game, w/2, h/2 + 9/2, selfButton.bSelected and color_black or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        DButton.DoClick = function(selfButton)

            tData.PANEL()

            for _, v in pairs(tButtons) do
                if not IsValid(v.Button) then continue end
                if v.Button == selfButton then continue end
                v.Button.bSelected = false
            end

            selfButton.bSelected = true
        end

        DHorizontalScroller:AddPanel(DButton)

        tButtons[_].Button = DButton
    end
end

GTA5_PauseMenu:OpenMenu()

-- if IsValid(GTA5_PauseMenu.Menu) then
--     GTA5_PauseMenu.Menu:Remove()
-- end