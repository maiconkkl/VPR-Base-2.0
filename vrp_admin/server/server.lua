local vRPAdmin = class("vRPAdmin", vRP.Extension)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhooklink1 = ""
local lang = vRP.lang
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dv',function(source,args,rawCommand)
    local user = vRP.users_by_source[source]
    if user and user:isReady() and user:hasPermission("player.list") or user and user:isReady() and user:hasPermission("dv.permission") then
        local vehicle = vRP.EXT.Garage.remote.getNearestVehicle(user.source, 7)
        if IsEntityAVehicle(vehicle) then
			TriggerClientEvent('deletarveiculo',source,vehicle)
			
			local data = os.date("**%d-%m-%Y** ás **%X**")
    		local content1 = "[ID]: "..user.id.." deu **DV** em um veículo ás ("..data..")"
    		PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
        end
    end
end)
RegisterNetEvent('deletarveiculo')
AddEventHandler('deletarveiculo',function(vehicle)
    TriggerServerEvent("vrp_garages:admDelete",VehToNet(vehicle))
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEVEH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteveh")
AddEventHandler("trydeleteveh",function(index)
	TriggerClientEvent("syncdeleteveh",-1,index)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteped")
AddEventHandler("trydeleteped",function(index)
	TriggerClientEvent("syncdeleteped",-1,index)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAR INVENTARIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limpainv',function(source,args,rawCommand)
    local user = vRP.users_by_source[source]
    if user and user:isReady() and user:hasPermission("god") then
		user:clearInventory()
		
		local data = os.date("**%d-%m-%Y** ás **%X**")
		local content1 = "[ID]: "..user.id.." limpou o próprio **INVENTÁRIO** ás ("..data..")"
		PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
    end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVER TODOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteped")
RegisterCommand('reviveall', function(source, args, rawCommand)
    local user = vRP.users_by_source[source]
    if user and user:isReady() and user:hasPermission("player.list") then
        for k,v in pairs(vRP.users) do
			user:setVital("water", 1)
			user:setVital("food", 1)
			vRP.EXT.PlayerState.remote._setHealth(k, 200)
			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[ID]: "..user.id.." reviveu **TODOS** da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PUXAR TODOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpall', function(source, args, rawCommand)
    local user = vRP.users_by_source[source]
    local x,y,z = vRP.EXT.Base.remote.getPosition(user.source)
    if user and user:isReady() and user:hasPermission("player.list") and user:hasPermission("player.tptome") then
        for k,v in pairs(vRP.users) do
            if k ~= user then
				vRP.EXT.Base.remote.teleport(k,x,y,z)
				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[ID]: "..user.id.." puxou **TODOS** da cidade ás ("..data..")"
				PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYDELETEOBJ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteobj")
AddEventHandler("trydeleteobj",function(index)
	TriggerClientEvent("syncdeleteobj",-1,index)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FIX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('fix',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		local vehicle = vRP.EXT.Garage.remote.getNearestVehicle(user.source, 7)
		if vehicle then
			TriggerClientEvent('reparar',source,vehicle)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[ID]: "..user.id.." **FIXOU** seu carro ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limparea',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	local x,y,z = vRP.EXT.Base.remote.getPosition(user.source)
	if user and user:isReady() and user:hasPermission("player.list") then
		TriggerClientEvent("syncarea",-1,x,y,z)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("god") or user and user:isReady() and user:hasPermission("player.list") then
		if args[1] then
			local nplayer = vRP.users_by_cid[parseInt(args[1])]
			if nplayer then
				nplayer:setVital("water", 1)
				nplayer:setVital("food", 1)
				vRP.EXT.PlayerState.remote._setHealth(nplayer.source, 200)

				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[**ID**]: "..user.id.." reviveu o [**ID**]: "..parseInt(args[1]).." ás ("..data..")"
				PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
			end
		else
			user:setVital("water", 1)
			user:setVital("food", 1)
			vRP.EXT.PlayerState.remote._setHealth(user.source, 200)
			vRP.EXT.PlayerState.remote._setArmour(user.source,100)
			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user.id.." se **AUTO-REVIVEU** ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS ON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('players',function(source,args,rawCommand)
    local onlinePlayers = GetNumPlayerIndices()
    TriggerClientEvent('chatMessage',source,"ALERTA",{255,70,50},"Jogadores online: "..onlinePlayers)
end)  

-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('hash',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		local vehicle = vRP.EXT.Garage.remote.getNearestVehicle(user.source, 7)
		if vehicle then
			TriggerClientEvent('vehash',source,vehicle)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		local vehicle = vRP.EXT.Garage.remote.getNearestVehicle(user.source, 7)
		if vehicle then
			TriggerClientEvent('vehtuning',source,vehicle)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.whitelist") then
		if args[1] then
			vRP:setWhitelisted(parseInt(args[1]),true)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user.id.." adiciou o [**ID**]: "..parseInt(args[1]).." na **Whitelist** da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.unwhitelist") then
		if args[1] then
			vRP:setWhitelisted(parseInt(args[1]),false)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user.id.." retirou o [**ID**]: "..parseInt(args[1]).." da **Whitelist** da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.kick") then
		if args[1] then
			local nplayer = vRP.users[parseInt(args[1])]
			if id then
				vRP:kick(nplayer.id,"Você foi expulso da cidade.")

				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[ID]: "..user.id.." **Kickou** o [ID]: "..nplayer.id.." ás ("..data..")"
				PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
    local user = vRP.users_by_source[source]
    if user and user:isReady() and user:hasPermission("player.ban") then
        if args[1] then
            local nplayer = vRP.users[parseInt(args[1])]
            vRP:setBanned(parseInt(args[1]),true)
            vRP:kick(nplayer.id,"Você foi expulso da cidade.")
			vRP:setWhitelisted(parseInt(args[1]),false)
			
			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = " [**/BAN**] [**ID**]: "..user.id.." Baniu o [**ID**]: "..nplayer.id.." da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.unban") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),false)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user.id.." desbaniu o [**ID**]: "..nuser.id.." da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.givemoney") then
		local zionlixo = args[1]
		if zionlixo then
			user:giveWallet(parseInt(zionlixo))

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user.id.." spawnou [**MONEY**]: "..parseInt(zionlixo).." ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.noclip") then
		vRP.EXT.Garage.remote.Admin.toggleNoclip(user.source)

		local data = os.date("**%d-%m-%Y** ás **%X**")
		local content1 = "[**ID**]: "..user.id.." utilizou o [**/NC**] ás ("..data..")"
		PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.tpto") then
	
		local fcoords = user:prompt("Cordenadas:", "")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRP.EXT.Base.remote.teleport(user.source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		local x,y,z = vRP.EXT.Base.remote.getPosition(user.source)
		user:addGroup(lang.admin.coords.hint(), x..","..y..","..z)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		if args[1] then
			local nplayer = vRP.users_by_cid[parseInt(args[1])]
			if args[2] then
				nplayer:removeGroup(parseInt(args[2])

				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[**ID**]: "..user.id.." adiciou no [**ID**]: "..nplayer.id.." o [**GRUPO**]: "..args[2].." ás ("..data..")"
				PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		if args[1] then
			local nplayer = vRP.users_by_cid[parseInt(args[1])]
			if args[2] then
				nplayer:removeGroup(parseInt(args[2])

				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[**ID**]: "..user.id.." retirou do [**ID**]: "..nplayer.id.." o [**GRUPO**]: "..parseInt(args[2]).." ás ("..data..")"
				PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.tptome") then
		if args[1] then
			local nplayer = vRP.users_by_cid[parseInt(args[1])]
			local x,y,z = vRPclient.getPosition(source)
			if nplayer then
				vRP.EXT.Base.remote.teleport(nplayer,x,y,z)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.tpto") then
		if args[1] then
			local nplayer = vRP.users_by_cid[parseInt(args[1])]
			if nplayer then
				vRP.EXT.Base.remote.teleport(source,vRPclient.getPosition(nplayer))
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.tpto") then
		TriggerClientEvent('tptoway',source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		if args[1] then
			TriggerClientEvent('spawnarveiculo',source,args[1])

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user.id.." spawnou o [**CARRO**]: "..parseInt(args[1]).." ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("player.list") then
		TriggerClientEvent('delnpcs',source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
	local user = vRP.users_by_source[source]
	if user and user:isReady() and user:hasPermission("msg.permissao") then
		local mensagem = user:prompt("Mensagem:", "")
		if mensagem == "" then
			return
		end
		vRP.EXT.GUI.remote.setDiv(user.source,"anuncio",".div_anuncio { background: rgba(255,50,50,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 10%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: Administrador")
		SetTimeout(60000,function()
			vRP.EXT.GUI.remote.removeDiv(user.source,"anuncio")
		end)
	end
end)

vRP:registerExtension(vRPAdmin)