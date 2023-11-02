
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local lastdata = nil

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/" .. endpoint,function(errorCode, resultData, resultHeaders)
        data = {data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bot " .. "(" ..Config.DiscordBotToken.. ")"})  -------Discord Bot Token
    while data == nil do Citizen.Wait(0) end
    return data
end


function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function mysplit(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end




function ExecuteCOMM(command, author)
    if string.starts(command, Config.Prefix) then
        -- Online játékosok számának lekérése
        if string.starts(command, Config.Prefix .. "pstatus") then
            sendToDiscord("Online Játékosok:", "Jelenlegi játékosszám: " ..GetNumPlayerIndices(), 16489834)
        -- Játékos kirúgása
        elseif string.starts(command, Config.Prefix .. "kick") then
            if TheyHaveRole(author, "TULAJ") then
                local t = mysplit(command, " ")
                if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                    sendToDiscord("Játékos kirugása:","Sikeresen kirúgtad a játékost!" .. GetPlayerName(t[2]), 16489834)
                    DropPlayer(t[2], "KICKED FROM DISCORD CONSOLE")
                else
                    sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
                end
            else
                sendToDiscord("Discord parancs","Ön nem jogosult ennek a parancsnak a használatára.", 16711680)  
            end
            -- Játékos megölése
        elseif string.starts(command, Config.Prefix .. "kill") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                TriggerClientEvent("discordc:kill", t[2])
                sendToDiscord("Játékos megölése:","Sikeresen megölted a játékost." .. GetPlayerName(t[2]),16489834)
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
           -- Játékos újraélesztése
        elseif string.starts(command, Config.Prefix .. "revive") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                TriggerClientEvent('esx_ambulancejob:revive',t[2]) 
                sendToDiscord("Játékos újraélesztése:","Sikeresen újraélesztetted a játékost." .. GetPlayerName(t[2]),16489834)
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
            --Játékos autójának törlése
        elseif string.starts(command,Config.Prefix .. "dv") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                TriggerClientEvent('esx:deleteVehicle', t[2])
                sendToDiscord("Jármű törlése:","Törölted ennek a játékosnak az autóját:" .. GetPlayerName(t[2]),16489834)
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!", 16489834)
            end
            --Játékos autójának javítása
        elseif string.starts(command,Config.Prefix .. "fix") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                TriggerClientEvent('fix', t[2])
                sendToDiscord("Jármű javítása","Meg javítottad ennek a játékosnak az autóját " .. GetPlayerName(t[2]),16489834)
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!", 16489834)
            end
            --Autó lehívás játékosnak
        elseif string.starts(command,Config.Prefix .. "car") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                TriggerClientEvent('esx:spawnVehicle', t[2], t[3])
                sendToDiscord("Lehívott típus: "..t[3].."", " Sikeresen lehívtad az autót neki: " .. GetPlayerName(t[2]), 16489834)
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!", 16489834)
            end
            -- Frakció váltás
        elseif string.starts(command, Config.Prefix .. "setjob") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    if t[3] and t[4] then
                        xPlayer.setJob(tostring(t[3]), tonumber(t[4]))   
                        sendToDiscord("Frakció váltás:", "Sikeresen átváltottad ennek a játékosnak a munkáját: " .. GetPlayerName(t[2]), 16489834)
                    else
                        sendToDiscord("Frakció váltás:","Nikal Lawde",16489834)
                    end
                end
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!", 16489834)
            end
            -- Játékos készpénzének a lekérdezése
        elseif string.starts(command, Config.Prefix .. "getmoney") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    money = xPlayer.getMoney()
                    if money then
                        sendToDiscord("Játékos készpénzének a lekérdezése:","Jelenlegi készpénz: " .. money .."Ft", 16489834)
                    end
                end
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
            -- Játékos bankegyenleg lekérdezése
        elseif string.starts(command, Config.Prefix .. "getbank") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    money = xPlayer.getAccount('bank').money
                    if money then
                        sendToDiscord("Játékos bankegyenleg lekérdezése:","Jelenlegi bankegyenleg: " ..money .."Ft",16489834)
                    end
                end
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
            -- Játékos készpénzének elvétele
        elseif string.starts(command, Config.Prefix .. "removemoney") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    if t[3] then
                        xPlayer.removeMoney(tonumber(t[3])) 
                        sendToDiscord("Készpénzének elvétele","Sikeresen elvetted az adoot összeget ettöl a játékostol: " ..GetPlayerName(t[2]),16489834)
                    else
                        sendToDiscord("Hiba","Az ID VAGY pénzbeírás érvénytelen, győződj meg róla, hogy így írtad-e be?: ! + removemoney + id + érték",16489834)
                    end
                end
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
            -- Játékos készpénzének adása
        elseif string.starts(command, Config.Prefix .. "addmoney") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    if t[3] then
                            xPlayer.addMoney(tonumber(t[3]))
                            sendToDiscord("Discord BOT","Sikeresen adoot egy összeget  játékosnak: " .. tonumber(t[3]) ..GetPlayerName(t[2]) .. ' money',16489834)
                        else
                            sendToDiscord("Discord BOT","Az ID VAGY pénzbevitel érvénytelen, győződjön meg róla, hogy így ír: \nprefix + addmoney + id + érték",16489834)
                        end
                    end
                else
                    sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
                end
            -- Játékosnak Pénz adása Bankba
        elseif string.starts(command, Config.Prefix .. "addbank") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    if t[3] then
                        xPlayer.addAccountMoney('bank',tonumber(t[3]))
                        sendToDiscord("Discord BOT","Sikeresen adoot egy összeget  játékosnak: " ..GetPlayerName(t[2]) .. ' bank money',16489834)
                    else
                        sendToDiscord("Discord BOT","Az ID VAGY pénzbevitel érvénytelen, győződjön meg róla, hogy így ír: \nprefix + addbank + id + érték",16489834)
                    end
                end
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
			-- Játékosnak PrémiumPont adása
		elseif string.starts(command, Config.Prefix .. "addcredits") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    if t[3] then
                        xPlayer.addAccountMoney('credits',tonumber(t[3]))
                        sendToDiscord("Discord BOT","Sikeresen adoot egy összeget  játékosnak: " ..GetPlayerName(t[2]) .. 'credits',16489834)
                    else
                        sendToDiscord("Discord BOT","Az ID VAGY pénzbevitel érvénytelen, győződjön meg róla, hogy így ír: \nprefix + addcredits + id + érték",16489834)
                    end
                end
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
            -- Játékos Pénzének elvétele Bankbol
        elseif string.starts(command, Config.Prefix .. "removebank") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                if xPlayer then
                    if t[3] then
                        xPlayer.removeAccountMoney('bank', tonumber(t[3])) 
                        sendToDiscord("Discord BOT","Sikeresen elvettél egy összeget  játékostol: " ..GetPlayerName(t[2]) .. ' bank money',16489834)
                    else
                        sendToDiscord("Discord BOT","Az ID VAGY pénzbevitel érvénytelen, győződjön meg róla, hogy így ír: \nprefix + removebank + id + érték",16489834)
                    end
                end
            else
                sendToDiscord("Nem található","Nem található ID. Ügyelj arra, hogy érvényes ID adj meg!",16489834)
            end
            -- Multi karakter adása (Készítés alatt)
        elseif string.starts(command, Config.Prefix .. "multi") then
            ------ADD UR MULTICHARACTER LOGOUT----

            --[[local t = mysplit(command, " ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                local xPlayer = ESX.GetPlayerFromId(tonumber(t[2]))
                QBCore.Player.Logout(tonumber(t[2]))
                TriggerClientEvent('hh_select:client:chooseChar', tonumber(t[2]))
                if xPlayer then
                    sendToDiscord("Discord Bot","Karakter Menü Adása" , 16489834)
                end
            else
                sendToDiscord("Nem található","Nem található azonosító. Ügyeljen arra, hogy érvényes azonosítót adjon meg!",16489834)
            end--]]
            --Saveall
        elseif string.starts(command, Config.Prefix .. "saveall") then
            for k, v in pairs(ESX.Game.GetPlayers()) do
                local Player = ESX.GetPlayerFromId(v)
                if Player ~= nil then 
                    ESX.SavePlayer(Player.source)
                end
            end
            sendToDiscord("Discord Bot", "Minden játékos mentése: "..ESX.Game.GetPlayers() , 16489834)
            --Notify
        elseif string.starts(command, Config.Prefix .. "dm") then
            local safecom = command
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                args = string.gsub(safecom, Config.Prefix .. "dm " ..t[2],"")
                TriggerClientEvent("announce", t[2], args)
                sendToDiscord("Discord BOT", "Sikeresen elküldve : " .. args .. " | Neki " .. GetPlayerName(t[2]), 16489834)
            else
                sendToDiscord("Nem található", "Hibás parancs!", 16489834)
            end
            -- Tárgy adás
        elseif string.starts(command,Config.Prefix .. "giveitem") then
            local t = mysplit(command," ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                if t[3] ~= nil and t[4] ~= nil then
                    local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                    xPlayer.addInventoryItem(t[3], t[4])  
                    sendToDiscord("Discord BOT", "Sikeresen oda adva " .. GetPlayerName(t[2]) .."\nTárgy: ".. t[3] .. "\ndb: " .. t[4],16489834)
                end
            else
              sendToDiscord("Nem található","Nem található azonosító. Ügyeljen arra, hogy érvényes azonosítót adjon meg",16489834)
            end
            --Unban
        elseif string.starts(command,Config.Prefix .. "unban") then
            local t = mysplit(command," ")
            if t[2] ~= nil then
                sendToDiscord("Discord BOT","Sikeresen Unbannoltad ezt a BanID-t ="..t[2],16489834)
            else
                sendToDiscord("Nem található","Nem található azonosító. Ügyeljen arra, hogy érvényes azonosítót adjon meg",16489834)
            end
            --Ban
        elseif string.starts(command, Config.Prefix .. "ban") then
            local t = mysplit(command, " ")     -- Add hozzá az Admin Jogosultságot
            local banTime = 2147483647
            local timeTable = os.date("*t", banTime)
            local reason = "No Reason Given"
            local banby = "Discord ADMIN"
            if t[3] ~= nil then reason = t[3] end
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
            else
                sendToDiscord("Nem található","Nem található azonosító. Ügyeljen arra, hogy érvényes azonosítót adjon meg",16489834)
            end
            --- Segitség Commands
        elseif string.starts(command, Config.Prefix .. "gsp") then
            sendToDiscord("Discord Bot Összes Parancs:", "```!pstatus:- Az aktuálisan játszó játékosok megtekintése \n!dm [ID] [Message] :- Üzenet küldése valakinek a szerveren  \n!kick [ID]:- Játékos kirugása \n!revive [ID] :- Játékos felélesztése\n!fix [ID] :- Autó Javítása  \n!kill [ID] :- Játékos megölése  \n!ban [ID][reason] :- Játékos kitiltása  \n!unban [BanID] :- Játékos kitiltásának feloldása\n!weather [name] :- Víz adása\n!dv [ID] :- Autó törlés\n!car [ID] :- Autó lehívása\n!setjob [ID] :- Munka változtatás\n!getmoney [ID] :- Készpénz lekérdezés \n!getbank [ID] :- Bank egyenleg lekérdezése\n!removemoney [ID] :- Készpénz elvétele \n!addmoney [ID] :- Készpénz adás\n!addbank [ID] :- Bank egyenleg adás \n!removebank [ID] :- Bank egyenleg elvétele\n!giveitem [ID][NÉV][DARAB] :- Tárgy adás\n!say [Üzenet] :- Felhívás\n!multi [ID] :- Karakter Menü adás\n!saveall :- Összes karakter mentése\n!closeserver :- Szerver leállitása\n!rvall :- Mindenki újraélesztése \n!tpall [coords] :- Teleportáljon mindenkit a koordinátákra (x, y, z)\n!giveall [tárgy][db] :- Adj mindenkinek tárgyat\n!info [ID]:- Játékos infó\n!checkinv [ID] - Inventory tartalmának lekérdezése\n!clearinv [ID] - Inventory tartalmának törlése\n!removeitem [ID][Item][amount] - Játékos tárgyának törlése\n!cloth [ID] - Ruha menü rá adás játékosra\n!noclip [ID] - Noclip Adás/Elvétel\n!giveadmin [ID][God/Admin] - Admin adás játékosnak\n!removeadmin [ID] - Admin elvétel játékostol\n!start [script] - Script Elindítása\n!stop [script] - Script leállitása\n!restart [script] - Script újraindítása```" , 762640)    
         -- Figyelmeztetés
        elseif string.starts(command, Config.Prefix .. "say") then
            local safecom = command
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                args = string.gsub(safecom, Config.Prefix .. "say","")
                TriggerClientEvent("announce", -1, args)
                sendToDiscord("Discord Bot", "Sikeresen elküldve : " .. string.gsub(safecom, Config.Prefix .. "say","") .. " | Neki: " .. GetNumPlayerIndices() ..  "!",16489834)
            else
                sendToDiscord("Nem található", "Hibás parancs!", 16489834)
            end
            -- Víz
        elseif string.starts(command, Config.Prefix .. "weather") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                --TriggerEvent('scriptname:server:setWeather', t[2])
                sendToDiscord("Discord Bot","Weather Succesfuly Changed",16489834)            
            else
                sendToDiscord("Nem található", "Hibás parancs!", 16489834)
            end  
        elseif string.starts(command, Config.Prefix .. "closeserver") then
            sendToDiscord("Server", "Leállitás", 16489834)
            Wait(2500)
            os.exit()  
        elseif string.starts(command, Config.Prefix .. "tpall") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                local coords = string.gsub(command, Config.Prefix .. "tpall","")
                local ped = GetPlayerPed(-1)
                SetEntityCoords(1, coords.x, coords.y, coords.z)
                sendToDiscord("Teleport", "Mindenki ide teleportált: "..coords, 16489834)  
            else
                sendToDiscord("Coords", "Hibás parancs! (x, y, z)", 16489834)
            end  
        elseif string.starts(command, Config.Prefix .. "rvall") then
            TriggerClientEvent('esx_ambulancejob:revive', -1) 
            sendToDiscord("Discord Bot","Sikeresen feléledt " .. GetNumPlayerIndices(),16489834)  
        elseif string.starts(command,Config.Prefix .. "giveall") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and t[3] ~= nil then
                for k, v in pairs(ESX.Game.GetPlayers()) do
                    local Player = ESX.GetPlayerFromId(v)
                    if Player ~= nil then 
                        Player.addInventoryItem(t[2], t[3])  
                        TriggerClientEvent('chatMessage', -1, "Rendszer", "error",  'Megadtál '..t[2].. "db "..t[3])
                        sendToDiscord("Discord Bot", "Sikeresen megkapta " .. GetNumPlayerIndices().. " ö" .."\nTárgy: ".. t[2] .. "\ndb: " .. t[3],16489834)
                    end
                end
            else
              sendToDiscord("Format Error","giveall [item] [amount]",16489834)
            end
        elseif string.starts(command,Config.Prefix .. "info") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                local Player =  ESX.GetPlayerFromId(tonumber(t[2]))
                local sname = GetPlayerName(t[2])
                local steam = GetPlayerIdentifiers(t[2])[1]
                local discord = '<@' .. GetPlayerIdentifiers(t[2])[3]:gsub('discord:', '') .. '>'
                local name = Player.getName()
                local job = Player.job.label
                local bank = Player.getMoney()
                local cash = Player.getAccount('bank').money
                sendToDiscord("Játékos Infó", "**Játékos ID:** "..t[2].."\n**Steam:** "..steam.."\n**Steam Név:** " ..sname.."\n**Játékos Név:** "..name.."\n**Munka:** " ..job.."\n**Bank egyenleg:** "..bank.."\n**Készpénz:** "..cash.."\n**Discord:** "..discord,16489834)
            else
              sendToDiscord("Formátum Error","info [id]",16489834)
            end
        elseif string.starts(command,Config.Prefix .. "checkinv") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                local Player =  ESX.GetPlayerFromId(tonumber(t[2]))
                local name = Player.getName().."``` ("..GetPlayerIdentifiers(t[2])[1]..")```\n"
                local items = Player.inventory
                local ItemsJson = {}
                if items ~= nil and next(items) ~= nil then
                    for slot, item in pairs(items) do
                        if items[slot] ~= nil then
                            table.insert(ItemsJson, {
                                name = item.name,
                                amount = item.amount,
                            })
                        end
                    end
                end
                sendToDiscord("Discord Bot", "**Játékos Inventory:** "..name.."\n",16489834)
            end
        elseif string.starts(command, Config.Prefix .. "clearinv") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                local Player =  ESX.GetPlayerFromId(tonumber(t[2]))
                local name = Player.getName().."("..GetPlayerIdentifiers(t[2])[1]..")\n"
                for i=1, #Player.inventory, 1 do
                    if Player.inventory[i].count > 0 then
                        Player.setInventoryItem(Player.inventory[i].name, 0)
                    end
                end
                sendToDiscord("Discord Bot", "Inventory törölve: "..name, 16489834)  
            else
                sendToDiscord("Formátum Error", "clearinv [ID]", 16489834)
            end 
        elseif string.starts(command,Config.Prefix .. "removeitem") then
            local t = mysplit(command," ")
            if t[2] ~= nil and GetPlayerName(t[2]) ~= nil then
                if t[3] ~= nil and t[4] ~= nil then
                    local xPlayer =  ESX.GetPlayerFromId(tonumber(t[2]))
                    xPlayer.removeInventoryItem(t[3], t[4])   
                    sendToDiscord("Discord Bot", "Az elem sikeresen eltávolítva " .. GetPlayerName(t[2]) .."\nTárgy: ".. t[3] .. "\ndb: " .. t[4],16489834)
                end
            else
              sendToDiscord("Nem található","Nem található azonosító. Ügyeljen arra, hogy érvényes azonosítót adjon meg",16489834)
            end
        elseif string.starts(command, Config.Prefix .. "cloth") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                local Player =  ESX.GetPlayerFromId(tonumber(t[2]))
                local name = Player.getName().."("..GetPlayerIdentifiers(t[2])[1]..")"
                TriggerEvent('esx_skin:openSaveableMenu', t[2])
                sendToDiscord("Discord Bot", "Ruházat Menü rá adva: "..name, 16489834)  
            else
                sendToDiscord("Formátum Error", "cloth [ID]", 16489834)
            end 
        elseif string.starts(command, Config.Prefix .. "noclip") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                local Player =  ESX.GetPlayerFromId(tonumber(t[2]))
                local name = Player.getName().."("..GetPlayerIdentifiers(t[2])[1]..")"
                --TriggerClientEvent('scriptname:toggleNoclip', t[2])
                sendToDiscord("Discord Bot", "Noclip rá adva: "..name, 16489834)  
            else
                sendToDiscord("Formátum Error", "noclip [ID]", 16489834)
            end 
        elseif string.starts(command, Config.Prefix .. "giveadmin") then
            local t = mysplit(command, " ")
            if t[2] ~= nil and t[3] ~= nil then
                local Player =  ESX.GetPlayerFromId(tonumber(t[2]))
                local name = Player.getName().."("..GetPlayerIdentifiers(t[2])[1]..")"
                --ESX.Functions.AddPermission(Player.PlayerData.source, tostring(t[3]):lower())
                sendToDiscord("Discord Bot", "Jog rá adva: "..name.."\nType: "..tostring(t[3]):lower(), 16489834)  
            else
                sendToDiscord("Formátum Error", "giveadmin [ID][God/Admin]", 16489834)
            end 
        elseif string.starts(command, Config.Prefix .. "removeadmin") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                local Player =  ESX.GetPlayerFromId(tonumber(t[2]))
                local name = Player.getName().."("..GetPlayerIdentifiers(t[2])[1]..")"
                --ESX.Functions.RemovePermission(Player.PlayerData.source)
                sendToDiscord("Discord Bot", "Jog eltávolítva tölle: "..name, 16489834)  
            else
                sendToDiscord("Formátum Error", "removeadmin [ID]", 16489834)
            end
        elseif string.starts(command, Config.Prefix .. "start") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                ExecuteCommand("start "..t[2])
                sendToDiscord("Discord Bot", "Script indítása: "..t[2], 16489834)  
            else
                sendToDiscord("Formátum Error", "start [script]", 16489834)
            end
        elseif string.starts(command, Config.Prefix .. "stop") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                ExecuteCommand("stop "..t[2])
                sendToDiscord("Discord Bot", "Script leállitása: "..t[2], 16489834)  
            else
                sendToDiscord("Formátum Error", "stop [script]", 16489834)
            end
        elseif string.starts(command, Config.Prefix .. "restart") then
            local t = mysplit(command, " ")
            if t[2] ~= nil then
                ExecuteCommand("stop "..t[2])
                ExecuteCommand("start "..t[2])
                sendToDiscord("Discord Bot", "Script újra indítása: "..t[2], 16489834)  
            else
                sendToDiscord("Format Error", "restart [script]", 16489834)
            end
        else
            -- Parancs nem található
            sendToDiscord("Discord Command","A parancs nem található. Kérjük, győződj meg arról, hogy érvényes parancsot adtál meg",16489834)
        end
    end
end







function TheyHaveRole(discordId, role)
	local theRole = nil
	if type(role) == "number" then
		theRole = tostring(role)
	else
		theRole = Config.Roles[role]
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format(Config.GuildId, discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			local found = true
			for i=1, #roles do
				if roles[i] == theRole then
					return true
				end
			end
			return false
		else
			print("An error occured, maybe they arent in the discord?")
			return false
		end
	else
		print("missing identifier")
		return false
	end
end


Citizen.CreateThread(function()
    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST', json.encode({
        username = Config.ReplyUserName,
        content = "**GS Panel Online lett**",
        avatar_url = Config.AvatarURL
    }), {['Content-Type'] = 'application/json'})
    while true do
        local chanel =
        DiscordRequest("GET", "channels/" .. Config.ChannelID, {})
        if chanel.data then
            local data = json.decode(chanel.data)
            local lst = data.last_message_id
            local lastmessage = DiscordRequest("GET", "channels/" ..Config.ChannelID .."/messages/" .. lst, {})
            if lastmessage.data then
                local lstdata = json.decode(lastmessage.data)
                if lastdata == nil then lastdata = lstdata.id end
                if lastdata ~= lstdata.id and lstdata.author.username ~= Config.ReplyUserName then
                    if Config.OnlyRoles then
                        if TheyHaveRole(lstdata.author.id, "GS Panel") then
                            ExecuteCOMM(lstdata.content, lstdata.author.id)
                            lastdata = lstdata.id
                        else
                            sendToDiscord("Discord Bot","Nincs hozzáférési jogosultságod", 16711680)  
                        end
                    else
                        ExecuteCOMM(lstdata.content, lstdata.author.id)
                        lastdata = lstdata.id
                    end
                end
            end
        end
        Citizen.Wait(Config.WaitEveryTick)
    end
end)


function sendToDiscord(name, message, color)
    local connect = {
        {["color"] = color,
        ["title"] = "**" .. name .. "**",
        ["description"] = message,
        ["footer"] = {
            ["text"] = "GamerStore",
            ["icon_url"] = "https://i.imgur.com/KNI4p5X.png",},
        }
    }
    PerformHttpRequest(Config.WebHook, function(err, text, headers) end, 'POST',
    json.encode({
        username = Config.ReplyUserName,
        embeds = connect,
        avatar_url = Config.AvatarURL
    }), {['Content-Type'] = 'application/json'})
end


