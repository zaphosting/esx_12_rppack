-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
--		   	Created By: qalle-fivem AKA qalle		      --
--			 Protected By: ATG-Github AKA ATG			  --
-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --

ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function checkIfLegit(source, target)
	-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
	--				Let's grab our data...					  --
	-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
	local src, tgt = source, target;
	if src ~= nil and tgt ~= nil then
		local xSrc, xTgt = ESX.GetPlayerFromId(src), ESX.GetPlayerFromId(tgt);
		if xSrc ~= nil and xTgt ~= nil then
			local srcIdent, tgtIdent = xSrc.identifier, xTgt.identifier;
			local srcJob = xSrc.job.name;
			local tgtJob = xTgt.job.name;
			local srcGroup = xSrc.getGroup();
			-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
			--				Let's define legitimacy...			      --
			-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
			local legit = {
				["legit"] = true,
				["reason"] = "No flags found."
			};
			-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
			--				Let's test for legitimacy!			      --
			-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
			if srcJob ~= "police" then
				if srcGroup ~= "admin" and srcGroup ~= "superadmin" then
					legit = {
						["legit"] = false,
						["reason"] = "Source does not have the police job, and is not staff."
					}
					return legit
				end
			end
			-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
			--		     If we've made it here, it's legit!           --
			-- ~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~= --
			return legit
		else
			legit = {
				["legit"] = false,
				["reason"] = "xSrc or xTgt == nil."
			}
			return legit
		end
	else
		legit = {
			["legit"] = false,
			["reason"] = "Source or Target == nil."
		}
		return legit
	end
end

RegisterCommand("jail", function(source, args, raw)
	local src, tgt = source, tonumber(args[1]);
	local jailTime, jailReason = tonumber(args[2]), args[3];

	if GetPlayerName(tgt) ~= nil then
		local legit = checkIfLegit(src, tgt);
		if legit["legit"] == true then
			if jailTime ~= nil then
				JailPlayer(tgt, jailTime)
				if args[3] ~= nil then
					GetRPName(tgt, function(Firstname, Lastname)
						TriggerClientEvent("esx:showNotification", src, Firstname .. " " .. Lastname .. " has been sentenced to " .. jailTime .. " minutes in jail.")
						TriggerClientEvent('chat:addMessage', -1, { args = { "JUDGE",  Firstname .. " " .. Lastname .. " has been sentenced to " .. jailTime .. " minutes in jail for the charges of " .. jailReason .. "." }, color = { 249, 166, 0 } })
					end)
				end
			else
				TriggerClientEvent("esx:showNotification", src, "This time is invalid!")
			end
		else
			print(
				string.format(
					"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to place [^5%s^7] ^5%s^7 into jail via the ^2jail^7 command. The legitimacy check returned ^1false^7 with the reason of ^2%s^7.",
					GetCurrentResourceName(), src, GetPlayerName(src), tgt, GetPlayerName(tgt), legit["reason"]
				)
			)
		end
	else
		TriggerClientEvent("esx:showNotification", src, "This ID is not online!")
	end

end)

RegisterCommand("unjail", function(source, args)
	local src, tgt = source, tonumber(args[1]);
	if GetPlayerName(tgt) ~= nil then
		local legit = checkIfLegit(src, tgt);
		if legit["legit"] == true then
			UnJail(tgt)
		else
			print(
				string.format(
					"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to remove [^5%s^7] ^5%s^7 from jail via the ^2unjail^7 command. The legitimacy check returned ^1false^7 with the reason of ^2%s^7.",
					GetCurrentResourceName(), src, GetPlayerName(src), tgt, GetPlayerName(tgt), legit["reason"]
				)
			)
		end
	else
		TriggerClientEvent("esx:showNotification", src, "This ID is not online!")
	end
end)

RegisterServerEvent("esx-qalle-jail:jailPlayer")
AddEventHandler("esx-qalle-jail:jailPlayer", function(t, jT, jR)
	local src, tgt = source, t;
	local jailTime, jailReason = jT, jR;

	local legit = checkIfLegit(src, tgt);
	if legit["legit"] == true then
		JailPlayer(tgt, jailTime)

		GetRPName(tgt, function(Firstname, Lastname)
			TriggerClientEvent("esx:showNotification", src, Firstname .. " " .. Lastname .. " has been sentenced to " .. jailTime .. " minutes in jail.")
			TriggerClientEvent('chat:addMessage', -1, { args = { "JUDGE",  Firstname .. " " .. Lastname .. " has been sentenced to " .. jailTime .. " minutes in jail for the charges of " .. jailReason .. "." }, color = { 249, 166, 0 } })
		end)
	else
		print(
			string.format(
				"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to remove [^5%s^7] ^5%s^7 from jail via the ^2jailPlayer^7 event. The legitimacy check returned ^1false^7 with the reason of ^2%s^7.",
				GetCurrentResourceName(), src, GetPlayerName(src), tgt, GetPlayerName(tgt), legit["reason"]
			)
		)
	end

end)

RegisterServerEvent("esx-qalle-jail:unJailPlayer")
AddEventHandler("esx-qalle-jail:unJailPlayer", function(tI)
	local src = source;
	local targetIdentifier = tI;
	local xTgt = ESX.GetPlayerFromIdentifier(targetIdentifier);
	if xTgt ~= nil then
		local tgt = xTgt.source;
		local legit = checkIfLegit(src, tgt);
		if legit["legit"] == true then
			UnJail(tgt)
			GetRPName(tgt, function(Firstname, Lastname)
				TriggerClientEvent("esx:showNotification", src, Firstname .. " " .. Lastname .. " has been released from jail.")
				TriggerClientEvent('chat:addMessage', -1, { args = { "JUDGE",  Firstname .. " " .. Lastname .. " has been released from jail." }, color = { 249, 166, 0 } })
			end)
		else
			print(
				string.format(
					"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to remove [^5%s^7] ^5%s^7 from jail via the ^2unJailPlayer^7 event. The legitimacy check returned ^1false^7 with the reason of ^2%s^7.",
					GetCurrentResourceName(), src, GetPlayerName(src), tgt, GetPlayerName(tgt), legit["reason"]
				)
			)
		end
	end
end)

RegisterServerEvent("esx-qalle-jail:updateJailTime")
AddEventHandler("esx-qalle-jail:updateJailTime", function(newJailTime)
	local src = source

	EditJailTime(src, newJailTime)
end)

RegisterServerEvent("esx-qalle-jail:prisonWorkReward")
AddEventHandler("esx-qalle-jail:prisonWorkReward", function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	
	local sql = MySQL.Sync.fetchScalar("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = xPlayer.identifier })
	if sql ~= nil then
		sql = tonumber(sql);
		if sql > 0 then
			xPlayer.addMoney(math.random(13, 21))
			TriggerClientEvent("esx:showNotification", src, "Thanks, here you have some cash for food!")
		else
			print(
				string.format(
					"^2%s^7 -> [^1%s^7] ^1%s^7 has attempted to exploit money through the ^2prisonWorkReward^7 event.",
					GetCurrentResourceName(), src, GetPlayerName(src)
				)
			)
		end
	end
end)

function JailPlayer(jailPlayer, jailTime)
	TriggerClientEvent("esx-qalle-jail:jailPlayer", jailPlayer, jailTime)

	EditJailTime(jailPlayer, jailTime)
end

function UnJail(jailPlayer)
	TriggerClientEvent("esx-qalle-jail:unJailPlayer", jailPlayer)

	EditJailTime(jailPlayer, 0)
end

function EditJailTime(source, jailTime)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier

	MySQL.Async.execute(
       "UPDATE users SET jail = @newJailTime WHERE identifier = @identifier",
        {
			['@identifier'] = Identifier,
			['@newJailTime'] = tonumber(jailTime)
		}
	)
end

function GetRPName(playerId, data)
	local Identifier = ESX.GetPlayerFromId(playerId).identifier

	MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		data(result[1].firstname, result[1].lastname)

	end)
end

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailedPlayers", function(source, cb)
	
	local jailedPersons = {}

	MySQL.Async.fetchAll("SELECT firstname, lastname, jail, identifier FROM users WHERE jail > @jail", { ["@jail"] = 0 }, function(result)

		for i = 1, #result, 1 do
			table.insert(jailedPersons, { name = result[i].firstname .. " " .. result[i].lastname, jailTime = result[i].jail, identifier = result[i].identifier })
		end

		cb(jailedPersons)
	end)
end)

ESX.RegisterServerCallback("esx-qalle-jail:retrieveJailTime", function(source, cb)

	local src = source

	local xPlayer = ESX.GetPlayerFromId(src)
	local Identifier = xPlayer.identifier


	MySQL.Async.fetchAll("SELECT jail FROM users WHERE identifier = @identifier", { ["@identifier"] = Identifier }, function(result)

		local JailTime = tonumber(result[1].jail)

		if JailTime > 0 then

			cb(true, JailTime)
		else
			cb(false, 0)
		end

	end)
end)
