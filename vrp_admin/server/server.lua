local vRPAdmin = class("vRPAdmin", vRP.Extension)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WEBHOOK
-----------------------------------------------------------------------------------------------------------------------------------------
local webhooklink1 = ""

-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('dv',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"mecanico.permissao") or vRP.hasPermission(user_id,"diretor.permissao") or vRP.hasPermission(user_id,"chefe.permissao") then
        local vehicle = vRPclient.getNearestVehicle(source,7)
        if vehicle then
			TriggerClientEvent('deletarveiculo',source,vehicle)
			
			local data = os.date("**%d-%m-%Y** ás **%X**")
    		local content1 = "[ID]: "..user_id.." deu **DV** em um veículo ás ("..data..")"
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
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"god.permissao") then
		vRP.clearInventory(user_id)
		
		local data = os.date("**%d-%m-%Y** ás **%X**")
		local content1 = "[ID]: "..user_id.." limpou o próprio **INVENTÁRIO** ás ("..data..")"
		PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REVIVER TODOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trydeleteped")
RegisterCommand('reviveall', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local rusers = vRP.getUsers()
        for k,v in pairs(rusers) do
            local rsource = vRP.getUserSource(k)
			vRPclient.setHealth(rsource, 400)
			
			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[ID]: "..user_id.." reviveu **TODOS** da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PUXAR TODOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpall', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    local x,y,z = vRPclient.getPosition(source)
    if vRP.hasPermission(user_id,"admin.permissao") then
        local rusers = vRP.getUsers()
        for k,v in pairs(rusers) do
            local rsource = vRP.getUserSource(k)
            if rsource ~= source then
				vRPclient.teleport(rsource,x,y,z)
				
				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[ID]: "..user_id.." puxou **TODOS** da cidade ás ("..data..")"
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
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"fix.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			TriggerClientEvent('reparar',source,vehicle)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[ID]: "..user_id.." **FIXOU** seu carro ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYAREA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('limparea',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		TriggerClientEvent("syncarea",-1,x,y,z)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('god',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"god.permissao") then
		if args[1] then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				vRPclient.killGod(nplayer)
				vRPclient.setHealth(nplayer,400)

				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[**ID**]: "..user_id.." reviveu o [**ID**]: "..parseInt(args[1]).." ás ("..data..")"
				PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
			end
		else
			vRPclient.killGod(source)
			vRPclient.setHealth(source,400)
			vRPclient.setArmour(source,100)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." se **AUTO-REVIVEU** ás ("..data..")"
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
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			TriggerClientEvent('vehash',source,vehicle)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tuning',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local vehicle = vRPclient.getNearestVehicle(source,7)
		if vehicle then
			TriggerClientEvent('vehtuning',source,vehicle)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('wl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"wl.permissao") then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),true)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." adiciou o [**ID**]: "..parseInt(args[1]).." na **Whitelist** da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unwl',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"wl.permissao") then
		if args[1] then
			vRP.setWhitelisted(parseInt(args[1]),false)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." retirou o [**ID**]: "..parseInt(args[1]).." da **Whitelist** da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('kick',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"kick.permissao") then
		if args[1] then
			local id = vRP.getUserSource(parseInt(args[1]))
			if id then
				vRP.kick(id,"Você foi expulso da cidade.")

				local data = os.date("**%d-%m-%Y** ás **%X**")
				local content1 = "[ID]: "..user_id.." **Kickou** o [ID]: "..id.." ás ("..data..")"
				PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ban',function(source,args,rawCommand)
    local user_id = vRP.getUserId(source)
    if vRP.hasPermission(user_id,"ban.permissao") then
        if args[1] then
            local id = vRP.getUserSource(parseInt(args[1]))
            vRP.setBanned(parseInt(args[1]),true)
            vRP.kick(id,"Você foi expulso da cidade.")
			vRP.setWhitelisted(parseInt(args[1]),false)
			
			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = " [**/BAN**] [**ID**]: "..user_id.." Baniu o [**ID**]: "..parseInt(args[1]).." da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('unban',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"unban.permissao") then
		if args[1] then
			vRP.setBanned(parseInt(args[1]),false)

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." desbaniu o [**ID**]: "..nuser_id.." da cidade ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('money',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"money.permissao") then
		local zionlixo = args[1]
		if zionlixo then
			vRP.giveMoney(user_id,parseInt(zionlixo))

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." spawnou [**MONEY**]: "..parseInt(zionlixo).." ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('nc',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"noclip.permissao") then
		vRPclient.toggleNoclip(source)

		local data = os.date("**%d-%m-%Y** ás **%X**")
		local content1 = "[**ID**]: "..user_id.." utilizou o [**/NC**] ás ("..data..")"
		PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpcds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"tp.permissao") then
		local fcoords = vRP.prompt(source,"Cordenadas:","")
		if fcoords == "" then
			return
		end
		local coords = {}
		for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
			table.insert(coords,parseInt(coord))
		end
		vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cds',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		local x,y,z = vRPclient.getPosition(source)
		vRP.prompt(source,"Cordenadas:",x..","..y..","..z)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('group',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
			vRP.addUserGroup(parseInt(args[1]),args[2])

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." adiciou no [**ID**]: "..parseInt(args[1]).." o [**GRUPO**]: "..args[2].." ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('ungroup',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		if args[1] and args[2] then
			vRP.removeUserGroup(parseInt(args[1]),args[2])

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." retirou do [**ID**]: "..parseInt(args[1]).." o [**GRUPO**]: "..parseInt(args[2]).." ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tptome',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"tp.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			local x,y,z = vRPclient.getPosition(source)
			if tplayer then
				vRPclient.teleport(tplayer,x,y,z)
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpto',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"tp.permissao") then
		if args[1] then
			local tplayer = vRP.getUserSource(parseInt(args[1]))
			if tplayer then
				vRPclient.teleport(source,vRPclient.getPosition(tplayer))
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('tpway',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"tp.permissao") then
		TriggerClientEvent('tptoway',source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('car',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"spawncar.permissao") then
		if args[1] then
			TriggerClientEvent('spawnarveiculo',source,args[1])

			local data = os.date("**%d-%m-%Y** ás **%X**")
			local content1 = "[**ID**]: "..user_id.." spawnou o [**CARRO**]: "..parseInt(args[1]).." ás ("..data..")"
			PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = "PenguinStaff", content = content1}), { ['Content-Type'] = 'application/json' })
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('delnpcs',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"admin.permissao") then
		TriggerClientEvent('delnpcs',source)
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- ADM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('adm',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"msg.permissao") then
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(255,50,50,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 10%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 16px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: Administrador")
		SetTimeout(60000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)

vRP:registerExtension(vRPAdmin)