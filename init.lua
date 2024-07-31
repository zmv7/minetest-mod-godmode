local s = minetest.get_mod_storage()
minetest.register_privilege("godmode_self",{
    description = "Allows to toggle godmode for yourself",
    give_to_singleplayer = false,
    give_to_admin = false
})
minetest.register_privilege("godmode",{
    description = "Allows to toggle godmode for any player",
    give_to_singleplayer = false,
    give_to_admin = false
})
minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    if not name then return end
    local isgod = s:get_string(name)
    if isgod == "1" then
        minetest.after(0.1,function()
            player:set_armor_groups({immortal=1})
        end)
    end
end)
minetest.register_chatcommand("god",{
    description = "Toggle godmode for yourself or for specified player",
    privs = {godmode_self=true},
    params = "<name>",
    func = function(name,target)
        if not target or target == "" then target = name end
        if target ~= name and not minetest.check_player_privs(name,{godmode=true}) then
            return false, "/!\\ Your privileges are insufficient to toggle godmode for other players"
        end
        local player = minetest.get_player_by_name(target)
        local isgod = s:get_string(target)
        if isgod == "1" then
            if player then player:set_armor_groups({immortal=0}) end
            s:set_string(target,"")
            return true, "Godmode disabled for "..target..(not player and " (note: player is not online)" or "")
        else
            if player then player:set_armor_groups({immortal=1}) end
            s:set_string(target,"1")
            return true, "Godmode enabled for "..target..(not player and " (note: player is not online)" or "")
        end
end})
minetest.register_chatcommand("gods",{
    description = "Show list of players with godmode enabled",
    privs = {godmode=true},
    func = function(name,param)
        local out = {}
        for nick,val in pairs(s:to_table().fields) do
            table.insert(out,nick)
        end
        table.sort(out)
        return true, "Gods: "..table.concat(out,", ")
end})
