local _, _, classId = UnitClass("player")
if classId ~= 2 then return end

local VPE_settings = VPE_settings or {}
local VPE_soundEnabled = VPE_settings.soundEnabled ~= false
local VPE_debugEnabled = VPE_settings.debugEnabled == true
local VPE_GLOBAL_CD = VPE_settings.globalCD or 0

local function VPE_Debug(msg)
    if VPE_debugEnabled then
        print("|cffF58CBAVPE DEBUG|r " .. msg)
    end
end
local VPE_lastSoundTime = 0
local VPE_playLock = 0
local VPE_currentHandle  = nil
local VPE_currentIsForce = false

local function CanPlay()
    local now = GetTime()
    if now < VPE_playLock then return false end
    if (now - VPE_lastSoundTime) < VPE_GLOBAL_CD then return false end
    VPE_lastSoundTime = now
    return true
end

local VPE_lastPlayed = {}

local ADDON_PATH = "Interface\\AddOns\\VarathrazPaladinExperience\\sounds\\"

local function PlayRandom(category, force, protectDuration)
    if not VPE_soundEnabled then return end
    local now = GetTime()

    if force then
        -- Force
        VPE_lastSoundTime = now
    else
        -- Non-force
        if now < VPE_playLock then return end
        if not CanPlay() then return end
    end

    local sounds = VPE_Sounds[category]
    if not sounds or #sounds == 0 then return end

    local lastFile = VPE_lastPlayed[category]
    local totalWeight = 0
    for _, s in ipairs(sounds) do
        local w = s[2] or 1
        if s[1] == lastFile then w = w * 0.1 end
        totalWeight = totalWeight + w
    end

    local roll = math.random() * totalWeight
    local chosen, chosenProtect
    local cumulative = 0
    for _, s in ipairs(sounds) do
        local w = s[2] or 1
        if s[1] == lastFile then w = w * 0.1 end
        cumulative = cumulative + w
        if roll <= cumulative then
            chosen = s[1]
            chosenProtect = s[3]
            break
        end
    end
    if not chosen then
        chosen = sounds[#sounds][1]
        chosenProtect = sounds[#sounds][3]
    end

    VPE_lastPlayed[category] = chosen

    -- Force: mevcut her sesi durdurur (protect dahil)
    -- Non-force: sadece non-force sesi durdurur
    if force then
        if VPE_currentHandle then pcall(StopSound, VPE_currentHandle) end
        VPE_playLock = 0
    elseif not VPE_currentIsForce and VPE_currentHandle then
        pcall(StopSound, VPE_currentHandle)
    end

    VPE_Debug("[" .. category .. "] playing: " .. chosen)
    local ok, success, handle = pcall(PlaySoundFile, ADDON_PATH .. chosen, "Dialog")
    VPE_currentHandle  = (ok and success) and handle or nil
    VPE_currentIsForce = force or false
    local effectiveProtect = chosenProtect or protectDuration
    if effectiveProtect then VPE_playLock = now + effectiveProtect end
end

VPE_Sounds = {
    LOGIN    = { {"login\\login_1.ogg", 1, 12}, {"login\\login_2.ogg", 1, 7} },
    SELECT   = {
        {"select\\select_0.ogg", 1},
        {"select\\select_1.ogg", 1},
        {"select\\select_2.ogg", 1},
        {"select\\select_3.ogg", 1},
        {"select\\select_4.ogg", 1},
        {"select\\select_5.ogg", 1},
    },
    AGGRO    = { {"aggro\\aggro_1.ogg", 1}, {"aggro\\aggro_2.ogg", 1}, {"aggro\\aggro_3.ogg", 1} },
    DEATH    = { {"death\\death_1.ogg", 1}, {"death\\death_2.ogg", 1}, {"death\\death_3.ogg", 1}, {"death\\death_4.ogg", 1} },
    REVIVE     = { {"revive\\revive_1.ogg", 1} },
    REDEMPTION = { {"redemption\\REDEMPTION.ogg", 1} },
    MOUNT    = { {"mount\\mount_1.ogg", 1}, {"mount\\mount_2.ogg", 1}, {"mount\\mount_3.ogg", 1} },
    AFKSTART = { {"afkstart\\afkmusic_1.mp3", 1} },
    AFKEND   = { {"afkend\\afkend_1.ogg", 1} },
    BEACON         = { {"beacon\\beacon_1.ogg", 1} },
    LAYONHANDS     = { {"layonhands\\layonhands_1.ogg", 1} },
    CLEANSE        = { {"cleanse\\cleanse_1.ogg", 1} },
    DIVINESTEED    = { {"divinesteed\\divinesteed_1.ogg", 1} },
    FREEDOM        = { {"freedom\\freedom_1.ogg", 1} },
    DIVINEPROTECTION = { {"divineprotection\\divineprotection_1.ogg", 1} },
    BUBBLE         = { {"bubble\\bubble_1.ogg", 1} },
    BOP            = { {"bop\\bop_1.ogg", 1} },
    INTERRUPT      = { {"interrupt\\interrupt_1.ogg", 1} },
    STUN           = { {"stun\\stun_1.ogg", 1} },
    BLINDINGLIGHT  = { {"blindinglight\\blindinglight_1.ogg", 1} },
    SPELLWARDING   = { {"spellwarding\\spellwarding_1.ogg", 1} },
    SACRIFICE      = { {"sacrifice\\sacrifice_1.ogg", 1} },
    TAUNT          = { {"taunt\\taunt_1.ogg", 1} },
    WINGS          = { {"wings\\wings_3.ogg", 1} },
    AURAMASTERY    = { {"auramastery\\auramastery_1.ogg", 1} },
    ARDENTDEFENDER = { {"ardentdefender\\ardentdefender_1.ogg", 1} },
    ANCIENTKINGS   = { {"ancientkings\\ancientkings.ogg", 1} },
    CR             = { {"cr\\cr_1.ogg", 1, 2}, {"cr\\cr_2.ogg", 1, 4}, {"cr\\cr_3.ogg", 1, 1} },
    ABSOLUTION     = { {"absolution\\absolution_1.ogg", 1} },
}

-- spellID → { cat, prob, force, anyCombat, protect }
local SpellToSound = {
    -- Major cooldowns (bypass global CD, lock out other sounds)
    [31884]  = { cat = "WINGS", prob = 1.0, force = true, anyCombat = true, protect = 3 }, -- Avenging Wrath
    [216331] = { cat = "WINGS", prob = 1.0, force = true, anyCombat = true, protect = 3 }, -- Avenging Crusader
    [389539] = { cat = "WINGS", prob = 1.0, force = true, anyCombat = true, protect = 3 }, -- Sentinel
    [255937] = { cat = "WINGS", prob = 1.0, force = true, anyCombat = true, protect = 3, requiresSpell = 458359 }, -- Wake of Ashes 
    [633]    = { cat = "LAYONHANDS",     prob = 1.0, force = true,  anyCombat = true, protect = 3 },
    [471195] = { cat = "LAYONHANDS",     prob = 1.0, force = true,  anyCombat = true, protect = 3 },
    [642]    = { cat = "BUBBLE",         prob = 1.0, force = true,  anyCombat = true, protect = 3 },
    [31821]  = { cat = "AURAMASTERY",    prob = 1.0,   anyCombat = true },              
    [86659]  = { cat = "ANCIENTKINGS",   prob = 1.0, force = true,  anyCombat = true },
    [31850]  = { cat = "ARDENTDEFENDER", prob = 1.0,     anyCombat = true },               
    [391054] = { cat = "CR",             prob = 1.0, force = true,  anyCombat = true  }, -- Intercession (combat res)
    [7328]   = { cat = "REVIVE",      prob = 1.0, anyCombat = true, onCastStart = true ,protect = 8},  -- Redemption (res on ally)
    -- Cast-start triggers (onCastStart = true → fires on UNIT_SPELLCAST_START, not SENT)
    [212056] = { cat = "ABSOLUTION",  prob = 1.0, anyCombat = true, onCastStart = true,protect = 8 }, -- Mass Resurrection / Absolution (verify ID in-game)
    -- Utility / off-GCD (allow outside combat)
    [53563]  = { cat = "BEACON",         prob = 1.0, anyCombat = true }, -- Beacon of Light
    [156910] = { cat = "BEACON",         prob = 1.0, anyCombat = true }, -- Beacon of Faith
    [200025] = { cat = "BEACON",         prob = 1.0, anyCombat = true }, -- Beacon of Virtue
    [1044]   = { cat = "FREEDOM",        prob = 1.0, anyCombat = true },
    [1022]   = { cat = "BOP",            prob = 1.0, anyCombat = true },
    [204018] = { cat = "SPELLWARDING",   prob = 1.0, anyCombat = true },
    [190784] = { cat = "DIVINESTEED",    prob = 1.0, anyCombat = true },
    [115750] = { cat = "BLINDINGLIGHT",  prob = 1.0, anyCombat = true },
    [498]    = { cat = "DIVINEPROTECTION", prob = 1.0, anyCombat = true },
    [403876] = { cat = "DIVINEPROTECTION", prob = 1.0, anyCombat = true },
    -- Combat spells
    [6940]   = { cat = "SACRIFICE",  prob = 1.0 ,    anyCombat = true },
    [4987]   = { cat = "CLEANSE",    prob = 1.0 ,    anyCombat = true },           -- Cleanse (Holy)
    [213644] = { cat = "CLEANSE",    prob = 1.0 ,    anyCombat = true },           -- Cleanse Toxins (Prot/Ret)
    [62124]  = { cat = "TAUNT",      prob = 1.0 ,anyCombat = true  },
    [853]    = { cat = "STUN",       prob = 1.0 ,    anyCombat = true },
    [96231]  = { cat = "INTERRUPT",  prob = 1.0 ,    anyCombat = true },
}

local function HandleResolvedSpell(spellID, fromCastStart)
    local cfg = SpellToSound[spellID]
    if not cfg then
        VPE_Debug("unmapped spellID=" .. tostring(spellID) .. (fromCastStart and " (castStart)" or " (sent)"))
        return
    end
    if fromCastStart and not cfg.onCastStart then return end
    if not fromCastStart and cfg.onCastStart then return end
    if cfg.requiresSpell and not IsPlayerSpell(cfg.requiresSpell) then return end
    if not cfg.anyCombat and not InCombatLockdown() then return end
    VPE_Debug("spell=" .. tostring(spellID) .. " → " .. cfg.cat)
    if math.random() > cfg.prob then return end
    PlayRandom(cfg.cat, cfg.force, cfg.protect)
end

-- State tracking
local prevDead      = false
local prevCombat    = false
local prevMounted   = false
local prevAFK       = false
local prevSelfTarget = false
local afkSoundHandle  = nil
local pollTimer     = 0
local POLL          = 0.2

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("UNIT_SPELLCAST_SENT")
frame:RegisterEvent("UNIT_SPELLCAST_START")

local loginLastPlayed = nil
frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        prevMounted = IsMounted()
        local now = GetTime()
        if not loginLastPlayed or (now - loginLastPlayed) >= 3600 then
            loginLastPlayed = now
            PlayRandom("LOGIN", true)
        end
    elseif event == "UNIT_SPELLCAST_SENT" then
        -- params: unit, target, castGUID, spellID
        local unit, _, _, spellID = ...
        if unit == "player" then HandleResolvedSpell(spellID, false) end
    elseif event == "UNIT_SPELLCAST_START" then
        local unit, _, spellID = ...
        if unit == "player" then HandleResolvedSpell(spellID, true) end
    end
end)

frame:SetScript("OnUpdate", function(_, elapsed)
    pollTimer = pollTimer + elapsed
    if pollTimer < POLL then return end
    pollTimer = 0

    -- Death / Revive
    local isDead = UnitIsDeadOrGhost("player")
    if isDead and not prevDead then
        VPE_Debug("state: DEATH")
        PlayRandom("DEATH", true)
    elseif not isDead and prevDead then
        VPE_Debug("state: REVIVE")
        PlayRandom("REDEMPTION", true)
    end
    prevDead = isDead

    -- Combat / Aggro
    local inCombat = InCombatLockdown()
    if inCombat and not prevCombat then
        VPE_Debug("state: COMBAT")
        if math.random() < 0.33 then
            PlayRandom("AGGRO")
        end
    end
    prevCombat = inCombat

    -- Mount
    local mounted = IsMounted()
    if mounted and not prevMounted then
        VPE_Debug("state: MOUNT")
        PlayRandom("MOUNT")
    end
    prevMounted = mounted

    -- AFK
    local isAFK = UnitIsAFK("player")
    if isAFK and not prevAFK then
        VPE_Debug("state: AFK")
        if VPE_soundEnabled then
            local _, _, handle = pcall(PlaySoundFile, ADDON_PATH .. "afkstart\\afkmusic_1.mp3", "Dialog")
            afkSoundHandle = handle
        end
    elseif not isAFK and prevAFK then
        VPE_Debug("state: AFKEND")
        if afkSoundHandle then
            StopSound(afkSoundHandle)
            afkSoundHandle = nil
        end
        PlayRandom("AFKEND", true)
    end
    prevAFK = isAFK

    -- Self-target
    local selfTarget = UnitExists("target") and UnitIsUnit("target", "player")
    if selfTarget and not prevSelfTarget then
        VPE_Debug("state: SELF-TARGET")
        PlayRandom("SELECT")
    end
    prevSelfTarget = selfTarget

end)

-- Slash command: /vpe on | off | cd <seconds>
SLASH_VPE1 = "/vpe"
SlashCmdList["VPE"] = function(msg)
    local cmd, arg = msg:match("^(%S+)%s*(.*)$")
    if not cmd then cmd = "" end
    cmd = cmd:lower()

    if cmd == "on" then
        VPE_soundEnabled = true
        VPE_settings.soundEnabled = true
        print("|cffF58CBAVarathraz Paladin Experience:|r Sounds |cff00FF00enabled|r.")
    elseif cmd == "off" then
        VPE_soundEnabled = false
        VPE_settings.soundEnabled = false
        print("|cffF58CBAVarathraz Paladin Experience:|r Sounds |cffFF0000disabled|r.")
    elseif cmd == "debug" then
        VPE_debugEnabled = not VPE_debugEnabled
        VPE_settings.debugEnabled = VPE_debugEnabled
        print("|cffF58CBAVarathraz Paladin Experience:|r Debug " .. (VPE_debugEnabled and "|cff00FF00on|r" or "|cffFF0000off|r") .. ".")
    elseif cmd == "cd" then
        local val = tonumber(arg)
        if val and val >= 0 then
            VPE_GLOBAL_CD = val
            VPE_settings.globalCD = val
            print("|cffF58CBAVarathraz Paladin Experience:|r Global cooldown set to |cffFFFF00" .. val .. "|r seconds.")
        else
            print("|cffF58CBAVarathraz Paladin Experience:|r Usage: /vpe cd <seconds>")
        end
    else
        print("|cffF58CBAVarathraz Paladin Experience:|r Commands:")
        print("  /vpe on    — enable sounds")
        print("  /vpe off   — disable sounds")
        print("  /vpe debug — toggle debug output")
        print("  /vpe cd <seconds> — set global cooldown between sounds")
    end
end
