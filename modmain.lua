local require = GLOBAL.require
local io = require("io")

local RepoPanel = require("widgets/repopanel")

Assets = {
    Asset("ATLAS", "images/mypanel.xml"),
    Asset("IMAGE", "images/mypanel.tex"),
    Asset("ATLAS", "images/quagmire_hud.xml"),
    Asset("IMAGE", "images/quagmire_hud.tex"),
}

local url = 'ali.peppernotes.top:2020'

AddClassPostConstruct("widgets/controls", function(self)
    self.repopanel = self.top_root:AddChild(RepoPanel(url))
end)