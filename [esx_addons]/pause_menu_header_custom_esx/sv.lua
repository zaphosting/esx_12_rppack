ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)
ESX.RegisterServerCallback('pause_menu_header_custom_esx:getinfo', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer ~= nil then
        local infotable = {}
        infotable.money = xPlayer.getMoney and xPlayer.getMoney() or xPlayer.getAccount("money").money;
        infotable.bank = xPlayer.getBank and xPlayer.getBank() or xPlayer.getAccount("bank").money;
        infotable.blackmoney = xPlayer.getBlackMoney and xPlayer.getBlackMoney() or xPlayer.getAccount("black_money").money;
        infotable.id = source
        infotable.job = xPlayer.getJob and xPlayer.getJob() ;
        infotable.name = xPlayer.name;
        cb(infotable)
        else 
        cb(nil)
        end
end)