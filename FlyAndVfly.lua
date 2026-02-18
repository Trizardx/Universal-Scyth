-- Purple Hub | Fly + Noclip | R6 & R15

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local FlyOn = false
local VFlyOn = false
local NoclipOn = false
local FlySpeed = 60
local FlyUpHeld = false
local FlyDownHeld = false
local FlyConn = nil
local VFlyConn = nil
local NoclipConn = nil
local OrigSpeed = 16
local OrigJump = 50

-- ========================
--   GUI
-- ========================
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("PurpleHub")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LP.PlayerGui:FindFirstChild("PurpleHub")
    if old then old:Destroy() end
end)

local Gui = Instance.new("ScreenGui")
Gui.Name = "PurpleHub"
Gui.ResetOnSpawn = false

local ok = pcall(function() Gui.Parent = game:GetService("CoreGui") end)
if not ok then Gui.Parent = LP.PlayerGui end

local Frame = Instance.new("Frame", Gui)
Frame.Size = UDim2.new(0, 220, 0, 248)
Frame.Position = UDim2.new(0, 20, 0.5, -124)
Frame.BackgroundColor3 = Color3.fromRGB(30, 0, 60)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

-- Titulo
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -40, 0, 36)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
Title.BorderSizePixel = 0
Title.Text = "  Purple Hub"
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
-- cobre o canto inferior arredondado do titulo
local TitleFix = Instance.new("Frame", Title)
TitleFix.Size = UDim2.new(1, 0, 0, 8)
TitleFix.Position = UDim2.new(0, 0, 1, -8)
TitleFix.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
TitleFix.BorderSizePixel = 0

-- Botao minimizar
local MinBtn = Instance.new("TextButton", Frame)
MinBtn.Size = UDim2.new(0, 36, 0, 36)
MinBtn.Position = UDim2.new(1, -36, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
MinBtn.BorderSizePixel = 0
MinBtn.Text = "-"
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)
local MinFix = Instance.new("Frame", MinBtn)
MinFix.Size = UDim2.new(0, 8, 1, 0)
MinFix.Position = UDim2.new(0, 0, 0, 0)
MinFix.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
MinFix.BorderSizePixel = 0

-- Conteudo
local Content = Instance.new("Frame", Frame)
Content.Size = UDim2.new(1, 0, 1, -36)
Content.Position = UDim2.new(0, 0, 0, 36)
Content.BackgroundTransparency = 1

local function makeBtn(parent, text, yPos)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1, -20, 0, 34)
    b.Position = UDim2.new(0, 10, 0, yPos)
    b.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.fromRGB(220, 180, 255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local function makeLabel(parent, text, yPos)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1, -20, 0, 20)
    l.Position = UDim2.new(0, 10, 0, yPos)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextSize = 11
    l.Font = Enum.Font.Gotham
    l.TextColor3 = Color3.fromRGB(180, 140, 220)
    l.TextXAlignment = Enum.TextXAlignment.Left
    return l
end

local BtnFly    = makeBtn(Content, "FLY [ OFF ]", 8)
local BtnVFly   = makeBtn(Content, "VFLY [ OFF ]", 50)
makeLabel(Content, "Velocidade:", 94)

local SpeedBox = Instance.new("TextBox", Content)
SpeedBox.Size = UDim2.new(0, 70, 0, 26)
SpeedBox.Position = UDim2.new(0, 10, 0, 112)
SpeedBox.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
SpeedBox.BorderSizePixel = 0
SpeedBox.Text = "60"
SpeedBox.TextSize = 13
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextColor3 = Color3.fromRGB(220, 180, 255)
SpeedBox.ClearTextOnFocus = false
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)

-- Setas cima/baixo ao lado da caixa de velocidade
local BtnUp = Instance.new("TextButton", Content)
BtnUp.Size = UDim2.new(0, 34, 0, 26)
BtnUp.Position = UDim2.new(0, 90, 0, 112)
BtnUp.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
BtnUp.BorderSizePixel = 0
BtnUp.Text = "CIMA"
BtnUp.TextSize = 13
BtnUp.Font = Enum.Font.GothamBold
BtnUp.TextColor3 = Color3.fromRGB(220, 180, 255)
Instance.new("UICorner", BtnUp).CornerRadius = UDim.new(0, 6)

local BtnDown = Instance.new("TextButton", Content)
BtnDown.Size = UDim2.new(0, 34, 0, 26)
BtnDown.Position = UDim2.new(0, 130, 0, 112)
BtnDown.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
BtnDown.BorderSizePixel = 0
BtnDown.Text = "BAIXO"
BtnDown.TextSize = 13
BtnDown.Font = Enum.Font.GothamBold
BtnDown.TextColor3 = Color3.fromRGB(220, 180, 255)
Instance.new("UICorner", BtnDown).CornerRadius = UDim.new(0, 6)

local BtnNoclip = makeBtn(Content, "NOCLIP [ OFF ]", 148)

-- Dica de atalhos
makeLabel(Content, "[F] Fly  [V] VFly  [G] Noclip", 192)

-- ========================
--   MINIMIZAR
-- ========================
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Content.Visible = not minimized
    Frame.Size = minimized and UDim2.new(0,220,0,36) or UDim2.new(0,220,0,248)
    MinBtn.Text = minimized and "+" or "-"
end)

-- ========================
--   LOGICA FLY
-- ========================
local function enableFly()
    local char = LP.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    if not char or not hum or not root then return end

    FlyOn = true
    BtnFly.Text = "FLY [ ON ]"
    BtnFly.BackgroundColor3 = Color3.fromRGB(120, 0, 200)

    OrigSpeed = hum.WalkSpeed
    OrigJump  = hum.JumpPower
    hum.WalkSpeed  = 0
    hum.JumpPower  = 0
    hum.AutoRotate = false
    hum:ChangeState(Enum.HumanoidStateType.Physics)

    -- Congela TODAS as animaÃ§Ãµes (para o boneco ficar duro)
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end
    end
    -- Impede novas animaÃ§Ãµes de tocar enquanto voa
    hum.AnimationPlayed:Connect(function(track)
        if FlyOn then track:Stop(0) end
    end)

    -- remove instancias velhas
    pcall(function() root:FindFirstChild("_FlyBV"):Destroy() end)
    pcall(function() root:FindFirstChild("_FlyBG"):Destroy() end)

    local bv = Instance.new("BodyVelocity", root)
    bv.Name     = "_FlyBV"
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)

    local bg = Instance.new("BodyGyro", root)
    bg.Name      = "_FlyBG"
    bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bg.P         = 1e4
    bg.D         = 500
    bg.CFrame    = root.CFrame

    FlyConn = RunService.Heartbeat:Connect(function()
        if not FlyOn then return end
        local char2 = LP.Character
        local hum2  = char2 and char2:FindFirstChildOfClass("Humanoid")
        local r     = char2 and (char2:FindFirstChild("HumanoidRootPart") or char2:FindFirstChild("Torso"))
        local bv2   = r and r:FindFirstChild("_FlyBV")
        local bg2   = r and r:FindFirstChild("_FlyBG")
        if not r or not bv2 or not bg2 or not hum2 then return end

        if hum2:GetState() ~= Enum.HumanoidStateType.Physics then
            hum2:ChangeState(Enum.HumanoidStateType.Physics)
        end
        local anim2 = hum2:FindFirstChildOfClass("Animator")
        if anim2 then
            for _, track in ipairs(anim2:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
        end

        local cam = workspace.CurrentCamera.CFrame

        -- LÃª input: teclado OU thumbstick mobile diretamente
        local ix, iz = 0, 0

        -- Teclado
        if UIS:IsKeyDown(Enum.KeyCode.W) then iz = iz - 1 end
        if UIS:IsKeyDown(Enum.KeyCode.S) then iz = iz + 1 end
        if UIS:IsKeyDown(Enum.KeyCode.A) then ix = ix - 1 end
        if UIS:IsKeyDown(Enum.KeyCode.D) then ix = ix + 1 end

        -- Thumbstick mobile (Thumbstick1 = analÃ³gico esquerdo)
        local stick = UIS:GetGamepadState(Enum.UserInputType.Gamepad1)
        for _, input in ipairs(stick) do
            if input.KeyCode == Enum.KeyCode.Thumbstick1 then
                if math.abs(input.Position.X) > 0.1 then ix = input.Position.X end
                if math.abs(input.Position.Y) > 0.1 then iz = -input.Position.Y end
            end
        end

        -- Se nÃ£o tem gamepad, usa o MoveDirection sÃ³ como fallback
        if ix == 0 and iz == 0 then
            local md = hum2.MoveDirection
            if md.Magnitude > 0.01 then
                -- Transforma MoveDirection do world-space para o espaÃ§o da cÃ¢mera (yaw)
                local camYaw = CFrame.Angles(0, math.atan2(-cam.LookVector.X, -cam.LookVector.Z), 0)
                local localDir = camYaw:Inverse() * md
                ix = localDir.X
                iz = localDir.Z
            end
        end

        local moveVec = Vector3.zero
        if math.abs(ix) > 0.01 or math.abs(iz) > 0.01 then
            -- ix = esquerda/direita, iz = frente(negativo)/trÃ¡s(positivo)
            -- Aplica sobre os vetores da cÃ¢mera
            moveVec = cam.LookVector * (-iz) + cam.RightVector * ix
            if moveVec.Magnitude > 0 then moveVec = moveVec.Unit end
        end

        -- Vertical pelos botÃµes ou E/Q
        local vert = 0
        if FlyUpHeld   or UIS:IsKeyDown(Enum.KeyCode.E) or UIS:IsKeyDown(Enum.KeyCode.Space) then vert =  1 end
        if FlyDownHeld or UIS:IsKeyDown(Enum.KeyCode.Q) then vert = -1 end

        if vert ~= 0 and moveVec == Vector3.zero then
            moveVec = Vector3.new(0, vert, 0)
        end

        bv2.Velocity = moveVec * FlySpeed

        local camRot = cam - cam.Position
        bg2.CFrame = CFrame.new(r.Position) * camRot
    end)
end

local function disableFly()
    FlyOn = false
    BtnFly.Text = "FLY [ OFF ]"
    BtnFly.BackgroundColor3 = Color3.fromRGB(80, 0, 160)

    if FlyConn then FlyConn:Disconnect(); FlyConn = nil end

    local char = LP.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    if root then
        pcall(function() root:FindFirstChild("_FlyBV"):Destroy() end)
        pcall(function() root:FindFirstChild("_FlyBG"):Destroy() end)
    end

    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = true
        hum.WalkSpeed  = OrigSpeed
        hum.JumpPower  = OrigJump
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

-- ========================
--   LOGICA VFLY (veÃ­culos)
-- ========================
local function getVehicleRoot()
    local char = LP.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return nil end

    local seat = hum.SeatPart

    -- AssemblyRootPart Ã© a peÃ§a raiz REAL da montagem fÃ­sica do Roblox.
    -- Ã‰ nela que BodyVelocity funciona, independente do peso ou estrutura do veÃ­culo.
    -- Funciona pra foguetes, carros, barcos, qualquer coisa.
    local assemblyRoot = seat.AssemblyRootPart
    if assemblyRoot and assemblyRoot ~= workspace.Terrain then
        return assemblyRoot
    end

    -- Fallback: sobe hierarquia e pega PrimaryPart ou o prÃ³prio seat
    local model = seat:FindFirstAncestorOfClass("Model") or seat.Parent
    return (model and model.PrimaryPart) or seat
end

local function enableVFly()
    local vroot = getVehicleRoot()
    if not vroot then
        BtnVFly.Text = "VFLY: entre num veiculo!"
        task.delay(2, function() BtnVFly.Text = "VFLY [ OFF ]" end)
        return
    end

    VFlyOn = true
    BtnVFly.Text = "VFLY [ ON ]"
    BtnVFly.BackgroundColor3 = Color3.fromRGB(120, 0, 200)

    -- Desativa dano de queda no personagem enquanto voa no veÃ­culo
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    end

    pcall(function() vroot:FindFirstChild("_VFlyBV"):Destroy() end)
    pcall(function() vroot:FindFirstChild("_VFlyBG"):Destroy() end)

    local bv = Instance.new("BodyVelocity", vroot)
    bv.Name     = "_VFlyBV"
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

    local bg = Instance.new("BodyGyro", vroot)
    bg.Name      = "_VFlyBG"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P         = 1e4
    bg.D         = 500
    bg.CFrame    = vroot.CFrame

    VFlyConn = RunService.Heartbeat:Connect(function()
        if not VFlyOn then return end

        -- Pega o vroot atualizado a cada frame
        local vr = getVehicleRoot()
        if not vr then disableVFly(); return end
        local bv2 = vr:FindFirstChild("_VFlyBV")
        local bg2 = vr:FindFirstChild("_VFlyBG")
        if not bv2 or not bg2 then return end

        local cam = workspace.CurrentCamera.CFrame
        local hum2 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")

        local ix, iz = 0, 0

        if UIS:IsKeyDown(Enum.KeyCode.W) then iz = iz - 1 end
        if UIS:IsKeyDown(Enum.KeyCode.S) then iz = iz + 1 end
        if UIS:IsKeyDown(Enum.KeyCode.A) then ix = ix - 1 end
        if UIS:IsKeyDown(Enum.KeyCode.D) then ix = ix + 1 end

        local stick = UIS:GetGamepadState(Enum.UserInputType.Gamepad1)
        for _, input in ipairs(stick) do
            if input.KeyCode == Enum.KeyCode.Thumbstick1 then
                if math.abs(input.Position.X) > 0.1 then ix = input.Position.X end
                if math.abs(input.Position.Y) > 0.1 then iz = -input.Position.Y end
            end
        end

        if ix == 0 and iz == 0 and hum2 then
            local md = hum2.MoveDirection
            if md.Magnitude > 0.01 then
                local camYaw = CFrame.Angles(0, math.atan2(-cam.LookVector.X, -cam.LookVector.Z), 0)
                local localDir = camYaw:Inverse() * md
                ix = localDir.X
                iz = localDir.Z
            end
        end

        local moveVec = Vector3.zero
        if math.abs(ix) > 0.01 or math.abs(iz) > 0.01 then
            moveVec = cam.LookVector * (-iz) + cam.RightVector * ix
            if moveVec.Magnitude > 0 then moveVec = moveVec.Unit end
        end

        local vert = 0
        if FlyUpHeld   or UIS:IsKeyDown(Enum.KeyCode.E) or UIS:IsKeyDown(Enum.KeyCode.Space) then vert =  1 end
        if FlyDownHeld or UIS:IsKeyDown(Enum.KeyCode.Q) then vert = -1 end

        if vert ~= 0 and moveVec == Vector3.zero then
            moveVec = Vector3.new(0, vert, 0)
        end

        bv2.Velocity = moveVec * FlySpeed

        local camRot = cam - cam.Position
        bg2.CFrame = CFrame.new(vr.Position) * camRot
    end)
end

local function disableVFly()
    VFlyOn = false
    BtnVFly.Text = "VFLY [ OFF ]"
    BtnVFly.BackgroundColor3 = Color3.fromRGB(80, 0, 160)

    if VFlyConn then VFlyConn:Disconnect(); VFlyConn = nil end

    -- Reativa dano de queda
    local hum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
    end

    local vr = getVehicleRoot()
    if vr then
        pcall(function() vr:FindFirstChild("_VFlyBV"):Destroy() end)
        pcall(function() vr:FindFirstChild("_VFlyBG"):Destroy() end)
    end
end


local function enableNoclip()
    NoclipOn = true
    BtnNoclip.Text = "NOCLIP [ ON ]"
    BtnNoclip.BackgroundColor3 = Color3.fromRGB(120, 0, 200)

    NoclipConn = RunService.Stepped:Connect(function()
        local c = LP.Character
        if not c then return end
        for _, p in next, c:GetDescendants() do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end)
end

local function disableNoclip()
    NoclipOn = false
    BtnNoclip.Text = "NOCLIP [ OFF ]"
    BtnNoclip.BackgroundColor3 = Color3.fromRGB(80, 0, 160)

    if NoclipConn then NoclipConn:Disconnect(); NoclipConn = nil end

    local c = LP.Character
    if c then
        for _, p in next, c:GetDescendants() do
            if p:IsA("BasePart") then
                pcall(function() p.CanCollide = true end)
            end
        end
    end
end

-- ========================
--   RECONECTA AO MORRER
-- ========================
LP.CharacterAdded:Connect(function()
    task.wait(1)

    -- Desativa tudo ao morrer â€” evita bugs de estado Physics travado
    -- e dano de queda persistente
    if FlyConn    then FlyConn:Disconnect();    FlyConn    = nil end
    if VFlyConn   then VFlyConn:Disconnect();   VFlyConn   = nil end
    if NoclipConn then NoclipConn:Disconnect(); NoclipConn = nil end

    FlyOn    = false
    VFlyOn   = false
    NoclipOn = false

    BtnFly.Text    = "FLY [ OFF ]";    BtnFly.BackgroundColor3    = Color3.fromRGB(80, 0, 160)
    BtnVFly.Text   = "VFLY [ OFF ]";   BtnVFly.BackgroundColor3   = Color3.fromRGB(80, 0, 160)
    BtnNoclip.Text = "NOCLIP [ OFF ]"; BtnNoclip.BackgroundColor3 = Color3.fromRGB(80, 0, 160)

    -- Garante que o novo personagem comeÃ§a com estado limpo
    local newHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if newHum then
        newHum.AutoRotate = true
        newHum.WalkSpeed  = 16
        newHum.JumpPower  = 50
        newHum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        newHum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
        newHum:ChangeState(Enum.HumanoidStateType.Running)
    end
end)

-- ========================
--   BOTOES
-- ========================
BtnFly.MouseButton1Click:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then FlySpeed = v end
    if FlyOn then disableFly() else enableFly() end
end)

BtnVFly.MouseButton1Click:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then FlySpeed = v end
    if VFlyOn then disableVFly() else enableVFly() end
end)

BtnNoclip.MouseButton1Click:Connect(function()
    if NoclipOn then disableNoclip() else enableNoclip() end
end)

SpeedBox.FocusLost:Connect(function()
    local v = tonumber(SpeedBox.Text)
    if v and v > 0 then FlySpeed = v else SpeedBox.Text = tostring(FlySpeed) end
end)

BtnUp.MouseButton1Down:Connect(function()   FlyUpHeld = true  end)
BtnUp.MouseButton1Up:Connect(function()     FlyUpHeld = false end)
BtnUp.MouseLeave:Connect(function()         FlyUpHeld = false end)
BtnDown.MouseButton1Down:Connect(function() FlyDownHeld = true  end)
BtnDown.MouseButton1Up:Connect(function()   FlyDownHeld = false end)
BtnDown.MouseLeave:Connect(function()       FlyDownHeld = false end)

-- ========================
--   ATALHOS TECLADO
-- ========================
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.KeyCode == Enum.KeyCode.F then
        local v = tonumber(SpeedBox.Text)
        if v and v > 0 then FlySpeed = v end
        if FlyOn then disableFly() else enableFly() end
    elseif inp.KeyCode == Enum.KeyCode.V then
        local v = tonumber(SpeedBox.Text)
        if v and v > 0 then FlySpeed = v end
        if VFlyOn then disableVFly() else enableVFly() end
    elseif inp.KeyCode == Enum.KeyCode.G then
        if NoclipOn then disableNoclip() else enableNoclip() end
    end
end)

warn("Purple Hub carregado!")
