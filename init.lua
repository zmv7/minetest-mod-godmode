local s = core.get_mod_storage()
core.register_privilege("godmode","Allows to make players gods")
core.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    if not name then return end
    local isgod = s:get_string(name)
    if isgod == "1" then
        core.after(0.1,function()
            player:set_armor_groups({immortal=1})
        end)
    end
end)
core.register_chatcommand("god",{
    description = "Toggle godmode of player",
    privs = {godmode=true},
    params = "<name>",
    func = function(name,param)
        if param == "" then param = name end
        local player = core.get_player_by_name(param)
        local isgod = s:get_string(param)
        if isgod == "1" then
            if player then player:set_armor_groups({immortal=0}) end
            s:set_string(param,"")
            return true, "Godmode disabled for "..param
        else
            if player then player:set_armor_groups({immortal=1}) end
            s:set_string(param,"1")
            return true, "Godmode enabled for "..param
        end
end})
core.register_chatcommand("gods",{
    description = "Show list of godmoded players",
    privs = {godmode=true},
    func = function(name,param)
        local out = {}
        local tabl = s:to_table().fields
        for nick,val in pairs(tabl) do
            table.insert(out,nick)
        end
        return true, "Gods: "..table.concat(out,", ")
end})
