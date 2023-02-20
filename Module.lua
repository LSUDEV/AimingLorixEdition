if getgenv().LorixAiming then return getgenv().LorixAiming end

-- // Dependencies
local SignalManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/LSUDEV/AimingLorixEdition/main/Signal/Manager.lua"))()
local BeizerManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/LSUDEV/AimingLorixEdition/main/BeizerManager.lua"))()
local KeybindHandler = loadstring(game:HttpGet("https://raw.githubusercontent.com/LSUDEV/AimingLorixEdition/main/KeybindHandler.lua"))()

-- // Services
local ReplicatedStorage, UserInputService, TeleportService, HttpService, RunService, Workspace, Lighting, CoreGui, Players, Teams, Stats = game:GetService("ReplicatedStorage"), game:GetService("UserInputService"), game:GetService("TeleportService"), game:GetService("HttpService"), game:GetService("RunService"), game:GetService("Workspace"), game:GetService("Lighting"), game:GetService("CoreGui"), game:GetService("Players"), game:GetService("Teams"), game:GetService("Stats")

-- // Vars
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local Network = settings():GetService("NetworkSettings")
--
local Client = Players.LocalPlayer
local Mouse = Client:GetMouse()
local Ping = Stats.PerformanceStats.Ping
local Dot = Vector3.new().Dot
--
local ResetMemoryCategory, SetMemoryCategory, SetUpvalueName, SetMetatable, ProfileBegin, GetMetatable, GetConstants, GetRegistry, GetUpvalues, GetConstant, SetConstant, GetUpvalue, ValidLevel, LoadModule, SetUpvalue, ProfileEnd, GetProtos, GetLocals, Traceback, SetStack, GetLocal, DumpHeap, GetProto, SetLocal, GetStack, GetFenv, GetInfo, Info = debug.resetmemorycategory, debug.setmemorycategory, debug.setupvaluename, debug.setmetatable, debug.profilebegin, debug.getmetatable, debug.getconstants, debug.getregistry, debug.getupvalues, debug.getconstant, debug.setconstant, debug.getupvalue, debug.validlevel, debug.loadmodule, debug.setupvalue, debug.profileend, debug.getprotos, debug.getlocals, debug.traceback, debug.setstack, debug.getlocal, debug.dumpheap, debug.getproto, debug.setlocal, debug.getstack, debug.getfenv, debug.getinfo, debug.info
local RandomSeed, MRandom, Frexp, Floor, Atan2, Log10, Noise, Round, Ldexp, Clamp, Sinh, Sign, Asin, Acos, Fmod, Huge, Tanh, Sqrt, Atan, Modf, Ceil, Cosh, Deg, Min, Log, Cos, Exp, Max, Rad, Abs, Pow, Sin, Tan, Pi = math.randomseed, math.random, math.frexp, math.floor, math.atan2, math.log10, math.noise, math.round, math.ldexp, math.clamp, math.sinh, math.sign, math.asin, math.acos, math.fmod, math.huge, math.tanh, math.sqrt, math.atan, math.modf, math.ceil, math.cosh, math.deg, math.min, math.log, math.cos, math.exp, math.max, math.rad, math.abs, math.pow, math.sin, math.tan, math.pi
local Foreachi, Isfrozen, Foreach, Insert, Remove, Concat, Freeze, Create, Unpack, Clear, Clone, Maxn, Move, Pack, Find, Sort, Getn = table.foreachi, table.isfrozen, table.foreach, table.insert, table.remove, table.concat, table.freeze, table.create, table.unpack, table.clear, table.clone, table.maxn, table.move, table.pack, table.find, table.sort, table.getn
local PackSize, Reverse, SUnpack, Gmatch, Format, Lower, Split, Match, Upper, Byte, Char, Pack, Gsub, SFind, Rep, Sub, Len = string.packsize, string.reverse, string.unpack, string.gmatch, string.format, string.lower, string.split, string.match, string.upper, string.byte, string.char, string.pack, string.gsub, string.find, string.rep, string.sub, string.len
local Countlz, Rrotate, Replace, Lrotate, Countrz, Arshift, Extract, Lshift, Rshift, Btest, Band, Bnot, Bxor, Bor = bit32.countlz, bit32.rrotate, bit32.replace, bit32.lrotate, bit32.countrz, bit32.arshift, bit32.extract, bit32.lshift, bit32.rshift, bit32.btest, bit32.band, bit32.bnot, bit32.bxor, bit32.bor
local NfcNormalize, NfdNormalize, CharPattern, CodePoint, Graphemes, Offset, Codes, Char, Len = utf8.nfcnormalize, utf8.nfdnormalize, utf8.charpattern, utf8.codepoint, utf8.graphemes, utf8.offset, utf8.codes, utf8.char, utf8.len
local Isyieldable, Running, Status, Create, Resume, Close, Yield, Wrap = coroutine.isyieldable, coroutine.running, coroutine.status, coroutine.create, coroutine.resume, coroutine.close, coroutine.yield, coroutine.wrap
local Desynchronize, Synchronize, Cancel, Delay, Defer, Spawn, Wait = task.desynchronize, task.synchronize, task.cancel, task.delay, task.defer, task.spawn, task.wait
local CurrentCamera = Workspace.CurrentCamera;

local LorixAimingSettings = {
    GlobalSettings = {
        Enabled = true,
        Internal = false, -- // Do not modify, for internal use only
        TargetPart = {"Head", "HumanoidRootPart"},
        RaycastIgnore = nil,
        Offset = Vector2new(),
        MaxDistance = 1000,
    },
    ScriptChecks = {
        Wall = true,
        Team = true,
        Visible = true,
        ForceField = true,
        Alive = true,
        Friend = false,
        Player = true,
        Ignored = true,
    },
    AimAssistSettings = {
        Enabled = false,
        InternalEnabled = false, -- // Do not modify, for internal use only
        SelectedTarget = nil,
        HitChance = 100,
        TargetPart = {"Head", "HumanoidRootPart"},
    }
    Keybinds = {
        TargetBindSilent = "C",
        TargetBindAssist = "C",
    },
    FOVSettingsAssist = {
        Circle = Drawingnew("Circle"),
        Enabled = true,
        Visible = true,
        Type = "Static",
        Scale = 60,
        Sides = 12,
        Colour = Color3fromRGB(231, 84, 128),
        DynamicFOVConstant = 25
    },
    FOVSettingsSilent = {
        Circle = Drawingnew("Circle"),
        Enabled = true,
        Visible = true,
        Type = "Static",
        Scale = 60,
        Sides = 12,
        Colour = Color3fromRGB(231, 84, 128),
        DynamicFOVConstant = 25
    },
    FOVSettingsDeadzone = {
        Circle = Drawingnew("Circle"),
        Enabled = false,
        Visible = true,
        Scale = 10,
        Sides = 30,
        Colour = Color3fromRGB(83, 31, 46),
    },
    TracerSettings = {
        Tracer = Drawingnew("Line"),
        Enabled = true,
        Colour = Color3fromRGB(231, 84, 128)
    },
    Ignored = {
        WhitelistMode = {
            Players = false,
            Teams = false
        },
        Teams = {},
        IgnoreLocalTeam = true,
        Players = {
            Client
        }
    }
}

local LorixAiming = {
    Loaded = false,
    ShowCredits = true,
    Settings = LorixAimingSettings,
    Signals = SignalManager.new(),
    Selected = {
        Instance = nil,
        Part = nil,
        Position = nil,
        Velocity = nil,
        OnScreen = false
    }
}

getgenv().LorixAiming = LorixAiming

local State = {Utils = {}, Connections = {}, Objects = {}, Velocities = {}, Tracked = {}, Connect = {}, Previous = {}}
local LorixUtils = {}
do -- LorixUtils
    function LorixUtils:Connection(connectionType, connectionCallback)
        local connection = connectionType:Connect(connectionCallback)
        State.Connections[#State.Connections + 1] = connection
        --
        return connection
    end
    --
    function LorixUtils:ThreadFunction(Func, Name, ...)
        local Func = Name and function()
            local Passed, Statement = pcall(Func)
            --
            if not Passed and not Lorix.Safe then
                warn("Lorix:\n", "              " .. Name .. ":", Statement)
            end
        end or Func
        local Thread = Create(Func)
        --
        Resume(Thread, ...)
        return Thread
    end
end

-- // Set RaycastIgnore
function LorixAimingSettings.RaycastIgnore()
    return {LorixAiming.Utilities.Character(Client), LorixAiming.Utilities.GetCurrentCamera()}
end

-- // Keep track of current friends
local Friends = {}

-- // Loop through every player
for _, Player in ipairs(Players:GetPlayers()) do
    -- // If friends, add to table
    if (Player ~= Client and Client:IsFriendsWith(Player.UserId)) then
        table.insert(Friends, Player)
    end
end

-- // See when a new player joins
LorixUtils:Connection(Players.PlayerAdded, function(Player)
     -- // If friends, add to table
     if (Client:IsFriendsWith(Player.UserId)) then
        table.insert(Friends, Player)
    end
end)

-- // See when player leaves (not needed because of GC but just in case)
LorixUtils:Connection(Players.PlayerRemoving, function(Player)
    -- // If in friends table, remove
    local i = table.find(Friends, Player)
    if (i) then
        table.remove(Friends, i)
    end
end)

-- // Get Settings
function LorixAimingSettings.Get(...)
    -- // Vars
    local args = {...}
    local argsCount = #args
    local Identifier = args[argsCount]

    -- // Navigate through settings
    local Found = LorixAimingSettings
    for i = 1, argsCount - 1 do
        -- // Vars
        local v = args[i]

        -- // Make sure it exists
        if (v) then
            -- // Set
            Found = Found[v]
        end
    end

    -- // Return
    return Found[Identifier]
end

-- // Create signals
do
    local SignalNames = {"InstanceChanged", "PartChanged", "PartPositionChanged", "OnScreenChanged"}

    for _, SignalName in pairs(SignalNames) do
        LorixAiming.Signals:Create(SignalName)
    end
end

-- // Create fovCircleAssist
local circleAssist = LorixAimingSettings.FOVSettingsAssist.Circle
circleAssist.Transparency = 1
circleAssist.Thickness = 2
circleAssist.Color = LorixAimingSettings.FOVSettingsAssist.Colour
circleAssist.Filled = false

-- // Create fovCircleSilent
local circleSilent = LorixAimingSettings.FOVSettingsSilent.Circle
circleSilent.Transparency = 1
circleSilent.Thickness = 2
circleSilent.Color = LorixAimingSettings.FOVSettingsSilent.Colour
circleSilent.Filled = false

-- // Update
function LorixAiming.UpdateFOV()
    -- // Make sure the circle exists
    if not (circleAssist) then
        return
    end

    -- // Vars
    local MousePosition = GetMouseLocation(UserInputService) + LorixAimingSettings.GlobalSettings.Offset
    local Settings = LorixAimingSettings.FOVSettings

    -- // Set Circle Properties
    circle.Position = MousePosition
    circle.NumSides = Settings.Sides
    circle.Color = Settings.Colour

    -- // Set radius based upon type
    circle.Visible = Settings.Enabled and Settings.Visible
    if (Settings.Type == "Dynamic") then
        -- // Check if we have a target
        if (not Aiming.Checks.IsAvailable()) then
            circle.Radius = (Settings.Scale * 3)
            return circle
        end

        -- // Grab which part we are going to use
        local TargetPart = Aiming.Selected.Part
        local PartInstance = Aiming.Utilities.Character(LocalPlayer)[TargetPart.Name]

        -- // Calculate distance, set
        local Distance = (PartInstance.Position - TargetPart.Position).Magnitude
        circle.Radius = math.round((Settings.DynamicFOVConstant / Distance) * 1000)
    else
        circle.Radius = (Settings.Scale * 3)
    end

    -- // Return circle
    return circle
end

-- // Beizer Aim Curves
LorixAiming.BeizerCurve = {}
do
    -- // Information
    --[[
        A deals with mouse movements
        B deals with custom movements, e.g. camera
    ]]

    -- // Vars
    local ManagerA = BeizerManager.new()
    local ManagerB = BeizerManager.new()

    -- // Functions
    LorixAiming.BeizerCurve.ManagerA = ManagerA
    LorixAiming.BeizerCurve.ManagerB = ManagerB

    local function Offset()
        return LorixAimingSettings.GlobalSettings.Offset
    end
    ManagerA.Offset = Offset
    ManagerB.Offset = Offset

    LorixAiming.BeizerCurve.AimTo = function(...)
        ManagerA:ChangeData(...)
    end
    LorixAiming.BeizerCurve.AimToB = function(...)
        ManagerB:ChangeData(...)
    end

    -- // Convert B to Camera Mode
    ManagerB:CameraMode()

    -- // Convert function to use LorixAiming
    ManagerB.Function = function(self, Pitch, Yaw)
        local RotationMatrix = CFrame.fromEulerAnglesYXZ(Pitch, Yaw, 0)
        Utilities.SetCameraCFrame(CFrame.new(GetCurrentCamera().CFrame.Position) * RotationMatrix)
    end

    -- // Start
    ManagerA:Start()
    ManagerB:Start()
end

-- // Heartbeat Function
Heartbeat:Connect(function(deltaTime)
    LorixAiming.UpdateFOV()
    LorixAiming.UpdateDeadzoneFOV()
    LorixAiming.UpdateTracer()
    LorixAiming.GetClosestToCursor(deltaTime)

    LorixAiming.Loaded = true
end)

-- //
KeybindHandler.CreateBind({
    Keybind = function() 
        return LockMode.UnlockBind 
    end,
    ProcessedCheck = true,
    State = LockMode.InternalEnabled,
    Callback = function(State)
        LockMode.InternalEnabled = false
        LockMode.LockedPlayer = nil
    end,
    Hold = false
})

-- // Other stuff
task.spawn(function()
    -- // Repeat every 10 seconds
    while true do wait(10)
        -- // Update the friends list
        LorixAiming.Utilities.UpdateFriends()
    end
end)

-- // Credits
task.delay(1, function()
    -- // Credits (by disabling this and not including your own way of crediting within the script, e.g. credits tab, is violating the license agreement. Beware!)
    if (LorixAiming.ShowCredits) then
        messagebox("Thanks to Linux for their Aiming Module (v2, Module)", "Credits", 0)
    end
end)

-- //
return LorixAiming
