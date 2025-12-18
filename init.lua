core.register_node("myscaffolding:scaffolding", {
    description = "Construction Scaffolding",
    drawtype = "nodebox",
    tiles = {"myscaffolding_frame.png"},
    use_texture_alpha = "blend",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    climbable = true,
    buildable_to = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 3, scaffolding = 1},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, -0.4,  0.5, -0.4},
            { 0.4, -0.5, -0.5,  0.5,  0.5, -0.4},
            {-0.5, -0.5,  0.4, -0.4,  0.5,  0.5},
            { 0.4, -0.5,  0.4,  0.5,  0.5,  0.5},
            {-0.5,  0.4, -0.5,  0.5,  0.5,  0.5},
        },
    },
    on_rightclick = function(pos, node, clicker, itemstack)
        if itemstack:get_name() == "myscaffolding:scaffolding" then
            local top_pos = {x = pos.x, y = pos.y, z = pos.z}
            while core.get_node(top_pos).name == "myscaffolding:scaffolding" do
                top_pos.y = top_pos.y + 1
            end
            local target_node = core.get_node(top_pos)
            local def = core.registered_nodes[target_node.name]
            if target_node.name == "air" or (def and def.buildable_to) then
                core.set_node(top_pos, {name = "myscaffolding:scaffolding"})
                core.sound_play("default_place_node", {pos = top_pos, gain = 1.0})
                if not core.is_creative_enabled(clicker:get_player_name()) then
                    itemstack:take_item()
                end
            end
        end
        return itemstack
    end,
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        local up = {x = pos.x, y = pos.y + 1, z = pos.z}
        local node_above = core.get_node(up)
        if core.get_item_group(node_above.name, "scaffolding") > 0 then
            core.node_dig(up, node_above, digger)
        end
    end,
})

core.register_craft({
    output = "myscaffolding:scaffolding 6",
    recipe = {
        {"group:wood", "group:wood", "group:wood"},
        {"default:stick", "", "default:stick"},
        {"default:stick", "", "default:stick"},
    }
})
