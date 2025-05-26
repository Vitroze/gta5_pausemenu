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



local fTitle_GAME = VLib:CreateFonts("Monopol TRIAL Medium", true, 50, 600, {
    antialias = true,
    shadow = true,
})

local fInfo_Game = VLib:CreateFonts("Arial", true, 18, 500, {
    antialias = true,
    shadow = true,
})

local fOnglets_Game = VLib:CreateFonts("Roboto", true, 20, 500, {
    antialias = true,
    shadow = false,
})

local tDays = {
    ["Monday"] = "Lundi",
    ["Tuesday"] = "Mardi",
    ["Wednesday"] = "Mercredi",
    ["Thursday"] = "Jeudi",
    ["Friday"] = "Vendredi",
    ["Saturday"] = "Samedi",
    ["Sunday"] = "Dimanche"
}

local mRight = Material("gta5_pausemenu/right_arrow.png")
local mLeft = Material("gta5_pausemenu/left_arrow.png")
function GTA5_PauseMenu:OpenMenu()
    if IsValid(self.Menu) then
        self.Menu:Remove()
    end

    self.Menu = vgui.Create("DFrame")
    self.Menu:SetSize(ScrW(), ScrH())
    self.Menu:SetTitle("")
    self.Menu:MakePopup()
    self.Menu:Center()

    local iStartSysTime = SysTime()
    self.Menu.Paint = function(selfMenu, w, h)
        Derma_DrawBackgroundBlur(self.Menu, iStartSysTime)
    end

    self.Menu.OnRemove = function(selfMenu)
        if IsValid(selfMenu.oStation) then
            selfMenu.oStation:Stop()
        end

    end

    local DPanel_Info = vgui.Create("DPanel", self.Menu)
    DPanel_Info:SetSize(VLib:RX(1302), VLib:RY(74))
    DPanel_Info:SetPos(self.Menu:GetWide()/2 - DPanel_Info:GetWide() / 2, VLib:RY(96))

    local sDate = os.date("%A")
    sDate = tDays[sDate] or sDate
    DPanel_Info.Paint = function(selfPanel, w, h)
        draw.SimpleText("GtaCity RP", fTitle_GAME, 0, 26, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(LocalPlayer():Nick(), fInfo_Game, VLib:RX(1212), VLib:RY(2), color_white, TEXT_ALIGN_RIGHT)
        draw.SimpleText(("%s %s"):format(sDate, os.date("%H:%M")), fInfo_Game, VLib:RX(1212), VLib:RY(26), color_white, TEXT_ALIGN_RIGHT)
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

    local cHover = Color(104, 179, 211, 255)

    -- local tButtons = {
    --     {
    --         sName = "Carte",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "Infos",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "Statistiques",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "Paramètres",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "Jeu",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "En Ligne",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "GALERIE",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "BOUTIQUE",
    --         PANEL = function() end,
    --     },
    --     {
    --         sName = "Quitter",
    --         PANEL = function() end,
    --     },

    -- }

    surface.PlaySound("gta5_pausemenu/start.wav")

    local tButtons = GTA5_PauseMenu:GetPanels()
    
    local DPanel_Buttons = vgui.Create("DPanel", self.Menu)
    DPanel_Buttons:SetSize(VLib:RX(1302), VLib:RY(47))
    DPanel_Buttons:SetPos(self.Menu:GetWide()/2 - DPanel_Buttons:GetWide() / 2, VLib:RY(173))
    DPanel_Buttons.Paint = function() end
   -- DPanel_Buttons:SetVisible(false)

    local DDrigBaseButton = vgui.Create("DDragBase", DPanel_Buttons)
    DDrigBaseButton:SetSize(VLib:RX(218) * #tButtons, VLib:RY(47))
    DDrigBaseButton:SetPos(0, 0)
    DDrigBaseButton:SetDropPos( "6" )
    DDrigBaseButton:SetUseLiveDrag(false)

    local DButton_Right = vgui.Create("DButton", self.Menu)
    DButton_Right:SetSize(VLib:RX(20), VLib:RY(20))
    DButton_Right:SetPos(DPanel_Buttons:GetX() + DPanel_Buttons:GetWide() + VLib:RX(7), DPanel_Buttons:GetY() + DPanel_Buttons:GetTall()/2 - DButton_Right:GetTall()/2 + VLib:RY(9)/2)
    DButton_Right:SetText("")

    local iIDPanel = 1
    DButton_Right.DoClick = function(selfButton)
        if iIDPanel >= #tButtons then
            iIDPanel = 1
        else
            iIDPanel = iIDPanel + 1
        end

        tButtons[iIDPanel].Button:DoClick(true)
    end

    local cHoverMat = Color(146, 151, 153)
    DButton_Right.Paint = function(selfButton, w, h)
        surface.SetDrawColor(selfButton:IsHovered() and cHoverMat or color_white)
        surface.SetMaterial(mRight)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local DButton_Left = vgui.Create("DButton", self.Menu)
    DButton_Left:SetSize(VLib:RX(20), VLib:RY(20))
    DButton_Left:SetPos(DPanel_Buttons:GetX() - DButton_Left:GetWide() - VLib:RX(7), DPanel_Buttons:GetY() + DPanel_Buttons:GetTall()/2 - DButton_Left:GetTall()/2 + VLib:RY(9)/2)
    DButton_Left:SetText("")

    DButton_Left.DoClick = function(selfButton)
        if iIDPanel <= 1 then
            iIDPanel = #tButtons
        else
            iIDPanel = iIDPanel - 1
        end

        tButtons[iIDPanel].Button:DoClick(true)
    end

    DButton_Left.Paint = function(selfButton, w, h)
        surface.SetDrawColor(selfButton:IsHovered() and cHoverMat or color_white)
        surface.SetMaterial(mLeft)
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local DPanel_Main = vgui.Create("DPanel", self.Menu)
    DPanel_Main:SetSize(VLib:RX(1302), VLib:RY(645))
    DPanel_Main:SetPos(self.Menu:GetWide()/2 - DPanel_Main:GetWide() / 2, DPanel_Buttons:GetY() + DPanel_Buttons:GetTall() + VLib:RY(20))
    DPanel_Main.Paint = nil

    for iID, tData in pairs(tButtons) do
        local DButtonAction = vgui.Create("DButton", DDrigBaseButton)
        DButtonAction:SetSize(VLib:RX(215), VLib:RY(47))
        DButtonAction:Dock(LEFT)
        DButtonAction:DockMargin(0, 0, 3, 0) 
        DButtonAction:SetText("")
        DButtonAction.bSelected = false
        -- DButton:SetFont(fInfo_Game)
        -- DButton:SetTextColor(color_white)
        DButtonAction.Paint = function(selfButton, w, h)
            draw.RoundedBox(0, 0, 9, w, h - 9, selfButton.bSelected and Color(240, 240, 240) or Color(20, 21, 26, 255))

            if selfButton.bSelected then
                draw.RoundedBox(0, 0, 0, w, 9, cHover)
            end

            draw.SimpleText(tData.sName:upper(), fOnglets_Game, w/2, h/2 + VLib:RY(9)/2, selfButton.bSelected and color_black or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        DButtonAction.DoClick = function(selfButton, bNextButton)

            for _, v in pairs(tButtons) do
                if not IsValid(v.Button) then continue end

                v.Button.bSelected = false
            end
 
            selfButton.bSelected = true

            DPanel_Main:Clear()

            surface.PlaySound("gta5_pausemenu/ui_click.wav")

            iIDPanel = iID

            local iSoundDuration = SoundDuration("gta5_pausemenu/ui_click.wav")
            timer.Simple(iSoundDuration, function()
                surface.PlaySound("gta5_pausemenu/enter.wav")
            end)

            if bNextButton then
                local iX, iY = selfButton:LocalToScreen(self.Menu)
                
                if iX >= 1617 then

                    local iNewIDAnim = iID - 6

                    DDrigBaseButton.iOffset = VLib:RX(-218) * math.Clamp(iNewIDAnim, 0, 3)

                    DDrigBaseButton.iSysTimeStart = SysTime()
                elseif iX <= 309 then

                    local iNewIDAnim = iID - 1

                    DDrigBaseButton.iOffset = VLib:RX(-218) * math.Clamp(iNewIDAnim, 0, 3)

                    DDrigBaseButton.iSysTimeStart = SysTime()
                end
            end 
            
            if isfunction(tData.Open) then
                print("Opening panel: " .. tData.sName)
                tData:Open(DPanel_Main)
            end
        end

      --  DHorizontalScroller:AddPanel(DButtonAction)

        tButtons[iID].Button = DButtonAction
    end
    local function easedLerp(fraction, from, to)
        return Lerp(math.ease.InSine(fraction), from, to)
    end
    
    DDrigBaseButton.iSysTimeStart = SysTime()
    DDrigBaseButton.Think = function(selfPanel)
       -- selfPanel.x = easedLerp(CurTime() * 0.2, selfPanel.x, VLib:RX(-218) * math.Clamp(iID, 0, 3))

        if not selfPanel.x then
            selfPanel.x = 0
        end

        if not selfPanel.iOffset then
            selfPanel.iOffset = 0
        end

        selfPanel.x = easedLerp((SysTime() - selfPanel.iSysTimeStart) / 1, selfPanel.x, selfPanel.iOffset)
    end

    tButtons[1].Button:DoClick()

    self.Menu.Think = function(selfPanel)
        if selfPanel.iCooldown and selfPanel.iCooldown > CurTime() then return end


        if input.IsKeyDown(KEY_RIGHT) then

            iIDPanel = iIDPanel + 1
            if iIDPanel > #tButtons then
                iIDPanel = 1

                DDrigBaseButton.iOffset = 0

                DDrigBaseButton.iSysTimeStart = SysTime()
            end

            tButtons[iIDPanel].Button:DoClick(true)
            
            selfPanel.iCooldown = CurTime() + 0.25
        elseif input.IsKeyDown(KEY_LEFT) then

            iIDPanel = iIDPanel - 1
            if iIDPanel < 1 then
                iIDPanel = #tButtons
            end

            tButtons[iIDPanel].Button:DoClick(true)

            selfPanel.iCooldown = CurTime() + 0.25
        end


    end

    sound.PlayURL("https://dn720306.ca.archive.org/0/items/gta-v-pause-menu-main-menu-music-ost-grand-theft-auto/GTA%20V%20Pause%20Menu%20Main%20Menu%20Music%20-%20OST%20Grand%20Theft%20Auto.mp3", "noblock", function(station)
        print("Playing music station", oStation)
        if IsValid(oStation) then
            oStation:Play()
            oStation:SetVolume(0.25)
            oStation:EnableLooping(true)

            self.Menu.oStation = oStation
        end
    end, function(station)
        if not IsValid(station) then
            print("Failed to play music station")
        end
    end)
end

GTA5_PauseMenu:OpenMenu()

-- local frame = vgui.Create( "DFrame" )
-- frame:SetSize( 300, 500 )
-- frame:Center()
-- frame:MakePopup()

-- local dragbase = vgui.Create( "DDragBase", frame )
-- dragbase:Dock( FILL )
-- dragbase:MakeDroppable( "test" )
-- dragbase:SetDropPos( "6" )
-- dragbase:SetUseLiveDrag( false )

-- for i = 0, 10 do
-- 	local butt = dragbase:Add( "DButton" )
-- 	--butt:Dock( TOP )
-- 	butt:SetPos( 25, i * 25 )
-- 	butt:SetWidth( 100 )
-- 	butt:Droppable( "test" )
-- 	butt.id = i
-- 	butt.Think = function( s ) s:SetText( "ID: " .. i .. " ZPOS: " .. s:GetZPos() ) end
-- end

-- if IsValid(GTA5_PauseMenu.Menu) then
--     GTA5_PauseMenu.Menu:Remove()
-- end