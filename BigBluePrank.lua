

--  $$$$$$\   $$\   $$\   $$$$$$\   $$$$$$$$\  $$$$$$$$\  $$$$$$$\
-- $$  __$$\  $$ |  $$ | $$  __$$\  \__$$  __| $$  _____| $$  __$$\
-- $$ /  \__| $$ | $$  | $$ /  $$ |    $$ |    $$ |       $$ |  $$ |
-- \$$$$$$\   $$$$$  /   $$$$$$$$ |    $$ |    $$$$$\     $$$$$$$  |
--  \____$$\  $$  $$ <   $$  __$$ |    $$ |    $$  __|    $$  __$$< 
-- $$\   $$ | $$ |\$$ \  $$ |  $$ |    $$ |    $$ |       $$ |  $$ |
-- \$$$$$$  | $$ | \$$ \ $$ |  $$ |    $$ |    $$$$$$$$\  $$ |  $$ |
--  \______/  \__|  \__| \__|  \__|    \__|    \________| \__|  \__|

local playerNameToTrack = "Garbagetruck"
local lastKnownLevel = 0

-- Throttle variables to make sure multiple messages aren't sent
local lastWhisperTime = 0
local whisperCooldown = 10 -- Cooldown in seconds

-- Array of custom messages
local messages = {
    "Holy shit, gz. How are you so slow at leveling?",
    "Bro, you should take a break. Gz on lvlup!",
    "Lol, Gz Noob",
    "Gz, how many times did u die this level?",
    "You are on fire! - But you will never be as fast and cool as Skater!",
    "Gz! Sam just lost his bet. He was sure you would take at least 8 hours more, before you would be dinging",
    "Gz!! One Step closer to raiding!! Shame you are the worst hunter in the guild!",
    "LOL! Gz, Blue. Now your level matches ur IQ!!",
    "Gz! At the speed you are going, we are never going to be raiding before TBC launches",
    "Gz! Did you play with your monitor off for half the level?",
    "Congrats! But let’s be real, your pet did all the work",
    "Gz on leveling! You really put the 'casual' in casual gaming.",
    "Ayyyyyyy Coongratz on Ding! Did you finally figure out what the WASD keys do?",
    "Gz Noob! I hope you didn’t waste all your gold repairing from dying so much",
    "Gz! Now that you’re higher level, maybe mobs will finally stop laughing at you",
    "Ding! Congrats, slowpoke. I heard the snails in Elwynn are organizing a petition to nerf you",
    "Gz! By the time you hit 60, we’ll be in the nursing home together",
    "Ding! Congrats on being one level closer to figuring out your rotation.",
    "Gz! Just 50 more levels and you’ll be ready for Hogger.",
    "Gz on proving that persistence beats skill... barely.",
    "Gz on levelup! Does this mean you’re finally going to buy arrows?",
    "You’re a legend, Blue! No one’s ever taken this long to ding before. Gz!",
    "Congrats! Shame there is no achievement for 'Most Hours Wasted'. You deserve it",
    "Gz! Hopefully, your skills level up next",
    "Congrats! What’s slower: your leveling or your AUDI?",
    "Gz! With that pace, you are lucky Blizzard doesn't charge us by the hour",
    "Congrats! I see your leveling speed hasn’t scared off the mobs yet",
    "Gz! Don't worry, they say Vanilla content lasts forever... just like your leveling",
    "Gz bro! Only Destate is slower at leveling than you! <3",
    "Congrats! Your dog, Manfred, said he's embarrassed to walk near you, with that leveling pace",
    "Gz! Does your girlfriend even know you're alive after grinding out this level?",
    "GZ! Mac said last night, that he was sure you would quit before you reached this level",
    "Gz, Blue. Shame JohnCritller will be taking your raidspot at 60"

}

-- Function to get a random message from the array
local function getRandomMessage()
    return messages[math.random(#messages)]
end

-- Function to update Blue's level
local function updateTrackedPlayerLevel()
    local guildMembers = GetNumGuildMembers()
    for i = 1, guildMembers do
        local name, _, _, level, _, _, _, _, _ = GetGuildRosterInfo(i)
        if name == playerNameToTrack then
            return level -- Return Blue's current level
        end
    end
    return nil -- Return nil if Blue is not found in the guild
end

-- Function to handle events
local function onEvent(self, event, ...)
    if event == "GUILD_ROSTER_UPDATE" then
        -- Update Blue's current level
        local currentLevel = updateTrackedPlayerLevel()

        -- If Blue is found, compare levels and determine if a message should be sent
        if currentLevel then
            -- Check if Blue's level increased compared to the last known level
            if currentLevel > lastKnownLevel then
                -- Send a hidden addon message to trigger the prank
                C_ChatInfo.SendAddonMessage("LvlUpPrank", "TRIGGER", "GUILD")
            end

            -- Always update the last known level
            lastKnownLevel = currentLevel
        end
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message, channel, sender = ...
        if prefix == "LvlUpPrank" and message == "TRIGGER" then
            local currentTime = GetTime()
            if currentTime - lastWhisperTime >= whisperCooldown then
                -- Send a random whisper to Blue
                SendChatMessage(getRandomMessage(), "WHISPER", nil, playerNameToTrack)
                lastWhisperTime = currentTime
            end
        end
    elseif event == "PLAYER_LOGIN" then
        -- Update Blue's current level on login
        local currentLevel = updateTrackedPlayerLevel()
        if currentLevel then
            lastKnownLevel = currentLevel
        end
    end
end

-- Register the addon message prefix
C_ChatInfo.RegisterAddonMessagePrefix("LvlUpPrank")

-- Create a frame to listen for events
local frame = CreateFrame("Frame")
frame:RegisterEvent("GUILD_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", onEvent)

-- Slash command for testing
SLASH_TESTBIGBLUE1 = "/testbigblue"
SlashCmdList["TESTBIGBLUE"] = function()
    -- Simulate the level-up trigger by sending a hidden addon message
    C_ChatInfo.SendAddonMessage("LvlUpPrank", "TRIGGER", "GUILD")
    print("Test trigger sent!")
end