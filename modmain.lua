local require = GLOBAL.require
local io = require("io")

local RepoPanel = require("widgets/repopanel")

Assets = {
    Asset("ATLAS", "images/mypanel.xml"),
    Asset("IMAGE", "images/mypanel.tex"),
    Asset("ATLAS", "images/quagmire_hud.xml"),
    Asset("IMAGE", "images/quagmire_hud.tex"),
}

--读取文件中的网址
file,err = io.open(MODROOT.."url.txt", "r")
if err then 
    self.popuptext:SetString("未设置网址")
    self.mypopup:Show()
    self.inst:DoTaskInTime(5, function() self.mypopup:Hide() end)
    return 
end
local url = file:read()
file:close()

AddClassPostConstruct("widgets/controls", function(self)
    self.repopanel = self.top_root:AddChild(RepoPanel(url))
end)