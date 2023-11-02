
--------------Discord Bot Beállítása--------------
Config = {}
Config.DiscordBotToken = "" --Discord Bot Token 
Config.WebHook = "" --Discord WebHook
Config.GuildId = ""  --Discord szerver ID
Config.ChannelID = ""    --Discord Szoba ID (Amit néz a bot!)
Config.ReplyUserName = "GS Panel"   --Discord Bot Név
Config.AvatarURL = "https://i.imgur.com/KNI4p5X.png"   -- Discord Bot Képe
Config.Prefix = "!"  --Discord parancs előjel
Config.WaitEveryTick = 50  -- Frissitési Idő

--------------Engedélyek Beállítása--------------
Config.OnlyRoles = false    --(Be/Ki)Csak a legenerált azonosítók használhatják-e a parancsokat

Config.Roles = {  --[Engedély elnevezése] = "DC azonosító"
    ["TULAJ"] = "",
    ["TULAJH"] = "" 
}
--Engedélyek hozzáadása..
--Sablon az README.md-ben