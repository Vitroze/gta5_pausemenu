local PANEL = {}
PANEL.sName = "Carte"
PANEL.iOrder = 1

function PANEL:Open(DPanel)


    local DPanel_Map = vgui.Create("DPanel", DPanel)
    DPanel_Map:Dock(FILL)
    DPanel_Map.Paint = function() end 

    local myOverview = Gram.Renderers.OverviewFree:new()
    myMap = Gram.Map:new()
    listener = Gram.Beacons.Listener:new()
    listener:SetMapObject(myMap)  
    listener:Listen()    
    
    for k, v in pairs(Gram.Handlers) do 
        if string.find(k, "GtaCity::BlipPerso::") then
           print(k)
        end

        v.Sprite = type(v.Sprite) == "string" and Material(v.Sprite) or v.Sprite
        v:ReloadToListener(listener) 
    end     

    local overviewData = Gram.Overview.Load("rp_southside") -- game.GetMap()
    myOverview:SetOverviewData(overviewData)

    local mainEntry = overviewData and overviewData[1] or nil
    if mainEntry then
        local plyPos = LocalPlayer():GetPos() 
        myOverview._pos.x = plyPos.x
        myOverview._pos.y = plyPos.y
        myOverview:SetDistance(16000)
    else
        print("Pas d'overview data pour cette map !")
    end 

    myMap:SetRenderer(myOverview) 

    local dragging = false   
    local dragStartX, dragStartY = 0, 0 
    local savedPosX, savedPosY = 0, 0

    function DPanel_Map:OnMousePressed(mouseCode)
        if mouseCode == MOUSE_LEFT then
            dragging = true
            self:MouseCapture(true)
            dragStartX, dragStartY = gui.MouseX(), gui.MouseY()
            savedPosX, savedPosY = myOverview._pos.x, myOverview._pos.y
        end 
    end 

    function DPanel_Map:OnMouseReleased(mouseCode)
        if mouseCode == MOUSE_LEFT then
            dragging = false
            self:MouseCapture(false)
        elseif mouseCode == MOUSE_RIGHT then
            print("Clic droit sur la carte !") 
            local xPos, yPos = gui.MouseX(), gui.MouseY() + 20
 
            xPos, yPos = self:ScreenToLocal(xPos, yPos)

            local cX, cY = self:GetX() + self:GetWide() / 2, self:GetY() + self:GetTall() / 2
            local scale  = myOverview._scale 
            local px, py = myOverview._pos.x, myOverview._pos.y

            local dx = (xPos - cX) / scale
            local dy = (yPos - cY) / scale

            local worldX = px + dx
            local worldY = py - dy

            if bigMapFrame.bChooseBlip and IsValid(bigMapFrame.vFrame) then
                bigMapFrame.bChooseBlip = false

                bigMapFrame.vFrame:SetVisible(true)
                bigMapFrame.vFrame:MakePopup()
                
                bigMapFrame.vPos = Vector(worldX, worldY, 0)

                sInstruction = "pour démarrer le GPS"

                return
            end

            -- Gram.Handlers["waypoint"].ManualBeacons = { 
            --     {pos=Vector(worldX, worldY, 0)}
            -- }

            -- Gram.Handlers["waypoint"]:Reload()
        end
    end

    function DPanel_Map:Think()
        if dragging then
            local mx, my = gui.MouseX(), gui.MouseY()
            local dx = mx - dragStartX
            local dy = my - dragStartY
            local biggerSide = math.max(self:GetWide(), self:GetTall())
            local worldPerPixel = (myOverview._distance * 2) / biggerSide
            myOverview._pos.x = savedPosX - (dx * worldPerPixel)
            myOverview._pos.y = savedPosY + (dy * worldPerPixel)
        end
    end

    function DPanel_Map:Paint(w, h)  
        draw.RoundedBox(8, 0, 0, w, h, Color(0, 0, 0, 120))
        myMap:SetupDraw(0, 0, w, h)
        myMap:Poll()
        myMap:Draw(myOverview._pos, 0)

        draw.SimpleText(("[Clic droit] %s • [Clic gauche] pour se déplacer • [%s] Ouvrir le Menu BLIP personnalisé • [%s] pour fermer"):format(sInstruction, input.GetKeyName(tonumber(BindPersoConVar:GetString())):upper(), input.GetKeyName(tonumber(bigMapBindConVar:GetString())):upper()), "Trebuchet24", w * 0.5, h - 30, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        local cx, cy = w / 2, h / 2 
        local scale = myOverview._scale  -- L'échelle de la carte
        local px, py = myOverview._pos.x, myOverview._pos.y  -- Position de la carte

        for xPos, tObstacle in pairs(GtaCity.obstacleMap) do 
            for yPosStart, tObstacleFinal in pairs(tObstacle) do
                local xPosPanel = cx + ((xPos - px) * scale)
                local yPosPanel = cy + ((py - yPosStart) * scale)
                local xPosEndPanel = cx + ((tObstacleFinal[1] - px) * scale)
                local yPosEndPanel = cy + ((py - tObstacleFinal[2]) * scale)

                draw.RoundedBox(0, xPosPanel, yPosPanel, xPosEndPanel - xPosPanel, yPosEndPanel - yPosPanel, Color(123, 255, 0))  -- Exemple de couleur rouge
            end
        end

        if LocalPlayer().tGPS then
            for _, tData in ipairs(LocalPlayer().tGPS) do
                local xPos = cx + ((tData.x - px) * scale)
                local yPos = cy + ((py - tData.y) * scale)

                draw.RoundedBox(0, xPos, yPos, 5, 5, Color(255, 0, 0))  -- Exemple de couleur rouge
            end
        end

        for x = 0, 32 do 
            local xPos = cx + ((-16000 + x * 1024) - px) * scale
            local yPos = cy + ((py - (-16000 + x * 1024)) * scale)

            surface.SetDrawColor(Color(0, 0, 0))
            surface.DrawLine(xPos, 0, xPos, h) -- Ligne verticale
            
        end

        for y = 1, 32 do 
            -- La position de départ est -16000
            local xPos = cx + ((-16000 + y * 1024) - px) * scale
            local yPos = cy + ((py - (-16000 + y * 1024)) * scale)

            surface.SetDrawColor(Color(0, 0, 0))
            surface.DrawLine(0, yPos, w, yPos) -- Ligne horizontale
            
        end

        draw.SimpleText("X: " .. math.floor(px) .. " Y: " .. math.floor(py), "Trebuchet24", cx, cy + 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("w : " .. math.floor(w) .. " h: " .. math.floor(h), "Trebuchet24", cx, cy + 150, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
 
        -- Centre le crosshair
        draw.SimpleText("X", "Trebuchet24", cx, cy, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        if Gram.Zones then
            for _, zone in ipairs(Gram.Zones) do
                local verts = {}
                local corners = {
                    { x = zone.min.x, y = zone.min.y },
                    { x = zone.min.x, y = zone.max.y },
                    { x = zone.max.x, y = zone.max.y },
                    { x = zone.max.x, y = zone.min.y },
                }
                for i, c in ipairs(corners) do
                    local dx = (c.x - px) * scale
                    local dy = (py - c.y) * scale

                    verts[i] = { x = cx + dx, y = cy + dy }
                end

                surface.SetDrawColor(Color(0, 0, 255, 100))
                draw.NoTexture()
                surface.DrawPoly(verts)

                if zone.border_color then
                    local thickness = zone.border_thickness or 3
                    surface.SetDrawColor(zone.border_color)
                    for i = 1, #verts do
                        local v1, v2 = verts[i], verts[i % #verts + 1]
                        for dx = -math.floor(thickness/2), math.floor(thickness/2) do
                            for dy = -math.floor(thickness/2), math.floor(thickness/2) do
                                surface.DrawLine(v1.x + dx, v1.y + dy, v2.x + dx, v2.y + dy)
                            end
                        end
                    end
                end
            end
        end
    end 
end

GTA5_PauseMenu:RegisterPanel(PANEL) 