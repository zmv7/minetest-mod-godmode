local gods = core.get_mod_storage()
core.register_privilege("godmode","Allows to make players gods")
core.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    if not name then return end
    local isgod = gods:get_string(name)
    if isgod == "1" then
        core.after(0.5,function()
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
        if not player then return false, "No Player" end
        local isgod = gods:get_string(name)
        if isgod == "1" then
            player:set_armor_groups({immortal=0})
            gods:set_string(param,"")
            return true, "Godmode disabled for "..param
        else
            player:set_armor_groups({immortal=1})
            gods:set_string(param,"1")
            return true, "Godmode enabled for "..param
        end
end})
      
core.register_chatcommand("gods",{
    description = "Show list of godmoded players",
    privs = {godmode=true},
    func = function(name,param)
        local msg = "Gods: "
        local table = gods:to_table().fields
        for nick,val in pairs(table) do
            msg = msg..nick..", "
        end
        return true, msg
end})
