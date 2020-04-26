local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Image = require "widgets/image"
local TextEdit = require "widgets/textedit"
local Text = require "widgets/text"

local buttonCD = 10

local RepoPanel = Class(Widget, function(self, url)
    Widget._ctor(self, "RepoPanel")

    local message

    --定义repopanel按钮组
    self.repopanel = self:AddChild(Widget("repopanel"))
    self.repopanel:SetPosition(0, -150)

    --背景
    self.mainbackground = self.repopanel:AddChild(Image("images/mypanel.xml", "background.tex"))
    self.mainbackground:SetPosition(0, -215)
    self.mainbackground:SetScale(0.85)

    --输入框提示
    self.mytipbg1 = self.repopanel:AddChild(Image("images/mypanel.xml", "title1.tex"))
    self.mytipbg1:SetPosition(-100, -160)
    self.mytipbg1:SetScale(0.5)
    self.mytipbg2 = self.repopanel:AddChild(Image("images/mypanel.xml", "title2.tex"))
    self.mytipbg2:SetPosition(-100, -210)
    self.mytipbg2:SetScale(0.5)

    --输入框背景
    self.myinputbg1 = self.repopanel:AddChild(Image("images/global_redux.xml", "textbox3_gold_small_normal.tex"))
    self.myinputbg1:SetPosition(60, -160)
    self.myinputbg1:SetScale(0.55, 0.45)
    self.myinputbg2 = self.repopanel:AddChild(Image("images/global_redux.xml", "textbox3_gold_small_normal.tex"))
    self.myinputbg2:SetPosition(60, -210)
    self.myinputbg2:SetScale(0.55, 0.45)

    --仓库序号输入框
    self.inputrepo = self.repopanel:AddChild(TextEdit(NUMBERFONT, 30, ""))
    self.inputrepo:SetPosition(60, -160)
    self.inputrepo:SetColour(1, 1, 1, 1)
    self.inputrepo.edit_text_color = {1, 1, 1, 1}
    self.inputrepo.idle_text_color = {1, 1, 1, 1}
    self.inputrepo:SetEditCursorColour(1, 1, 1, 1)
    self.inputrepo:SetForceEdit(true)
    self.inputrepo.enable_accept_control = true
    self.inputrepo:SetRegionSize(130, 30)
    self.inputrepo:SetTextLengthLimit(4)
    self.inputrepo:SetCharacterFilter("1234567890")
    self.inputrepo:SetFocusedImage(self.myinputbg1, "images/global_redux.xml", "textbox3_gold_small_normal.tex", "textbox3_gold_small_hover.tex", "textbox3_gold_small_focus.tex")

    --仓库密码输入框
    self.inputpw = self.repopanel:AddChild(TextEdit(NUMBERFONT, 30, ""))
    self.inputpw:SetPosition(60, -210)
    self.inputpw:SetColour(1, 1, 1, 1)
    self.inputpw.edit_text_color = {1, 1, 1, 1}
    self.inputpw.idle_text_color = {1, 1, 1, 1}
    self.inputpw:SetEditCursorColour(1, 1, 1, 1)
    self.inputpw:SetForceEdit(true)
    self.inputpw:SetRegionSize(130, 30)
    self.inputpw:SetFocusedImage(self.myinputbg2, "images/global_redux.xml", "textbox3_gold_small_normal.tex", "textbox3_gold_small_hover.tex", "textbox3_gold_small_focus.tex")

    --绿色按钮
    self.buttongreen = self.repopanel:AddChild(ImageButton("images/mypanel.xml", "buttongreen.tex"))
    self.buttongreen:SetPosition(-90, -275)
    self.buttongreen:SetNormalScale(0.6)
    self.buttongreen:SetFocusScale(0.66)
    self.buttongreen:SetOnClick(
        function()
            local reponum = self.inputrepo:GetString()
            local passwd = self.inputpw:GetString()
            local website = string.format("http://%s/X?bv=open%s&pw=%s", url or 'X', reponum, passwd)
            TheSim:QueryServer(website,
            function(result, isSuccessful, resultCode)
                if isSuccessful and string.len(result) > 1 and resultCode == 200 then
                    if string.find(result, "\\u269c\\u6210\\u529f\\u5f00\\u542f\\u4ed3\\u5e93\\uff0c\\u8bf7\\u8010\\u5fc3\\u7b49\\u5f851\\u5206\\u949f...") then
                        message = "打开成功"
                    elseif string.find(result, "\\u5bc6\\u7801\\u9519\\u8bef") then
                        message = "密码错误"
                    elseif string.find(result, "\\u8f93\\u5165\\u9519\\u8bef") then
                        message = "输入错误"
                    end
                else
                    message = "服务器未响应"
                end
                --弹窗
                self.popuptext:SetString(message)
                self.mypopup:Show()
                self.inst:DoTaskInTime(5, function() self.mypopup:Hide() end)
            end, "GET")
            --CD
            self.buttonred:Disable()
            self.buttongreen:Disable()
            self.buttonyellow:Disable()
            self.inst:DoTaskInTime(buttonCD, function()
                self.buttonred:Enable() 
                self.buttongreen:Enable() 
                self.buttonyellow:Enable() 
            end)
        end
    )

    --黄色按钮
    self.buttonyellow = self.repopanel:AddChild(ImageButton("images/mypanel.xml", "buttonyellow.tex"))
    self.buttonyellow:SetPosition(0, -275)
    self.buttonyellow:SetNormalScale(0.6)
    self.buttonyellow:SetFocusScale(0.66)
    self.buttonyellow:SetOnClick(
        function()
            local reponum = self.inputrepo:GetString()
            local website = string.format("http://%s/X?bv=status%s", url or 'X', reponum)
            TheSim:QueryServer(website,
            function(result, isSuccessful, resultCode)
                if isSuccessful and string.len(result) > 1 and resultCode == 200 then
                    if string.find(result, "\\ud83c\\udf36\\u4ed3\\u5e93\\u72b6\\u6001\\uff1a\\u5f00\\u542f") then
                        message = "开启状态"

                    elseif string.find(result, "\\ud83c\\udf36\\u4ed3\\u5e93\\u72b6\\u6001\\uff1a\\u5173\\u95ed") then
                        message = "关闭状态"
                    elseif string.find(result, "\\u8f93\\u5165\\u9519\\u8bef") then
                        message = "输入错误"
                    end
                else
                    message = "服务器未响应"
                end
                --弹窗
                self.popuptext:SetString(message)
                self.mypopup:Show()
                self.inst:DoTaskInTime(5, function() self.mypopup:Hide() end)
            end, "GET")
            --CD
            self.buttonred:Disable()
            self.buttongreen:Disable()
            self.buttonyellow:Disable()
            self.inst:DoTaskInTime(buttonCD, function()
                self.buttonred:Enable() 
                self.buttongreen:Enable() 
                self.buttonyellow:Enable() 
            end)
        end
    )

    --红色按钮
    self.buttonred = self.repopanel:AddChild(ImageButton("images/mypanel.xml", "buttonred.tex"))
    self.buttonred:SetPosition(90, -275)
    self.buttonred:SetNormalScale(0.6)
    self.buttonred:SetFocusScale(0.66)
    self.buttonred:SetOnClick(
        function()
            local reponum = self.inputrepo:GetString()
            local passwd = self.inputpw:GetString()
            local website = string.format("http://%s/X?bv=close%s&pw=%s", url or 'X', reponum, passwd)
            TheSim:QueryServer(website,
            function(result, isSuccessful, resultCode)
                if isSuccessful and string.len(result) > 1 and resultCode == 200 then
                    if string.find(result, "\\ud83d\\udc94\\u6210\\u529f\\u5173\\u95ed\\u4ed3\\u5e93\\uff0c\\u518d\\u89c1...") then
                        message = "关闭成功"
                    elseif string.find(result, "\\u5bc6\\u7801\\u9519\\u8bef") then
                        message = "密码错误"
                    elseif string.find(result, "\\u8f93\\u5165\\u9519\\u8bef") then
                        message = "输入错误"
                    end
                else
                    message = "服务器未响应"
                end
                --弹窗
                self.popuptext:SetString(message)
                self.mypopup:Show()
                self.inst:DoTaskInTime(5, function() self.mypopup:Hide() end)
            end, "GET")
            --CD
            self.buttonred:Disable()
            self.buttongreen:Disable()
            self.buttonyellow:Disable()
            self.inst:DoTaskInTime(buttonCD, function()
                self.buttonred:Enable() 
                self.buttongreen:Enable() 
                self.buttonyellow:Enable() 
            end)
        end
    )

    --关闭按钮
    self.buttonclose = self.repopanel:AddChild(ImageButton("images/global_redux.xml", "close.tex"))
    self.buttonclose:SetPosition(170, -130)
    self.buttonclose:SetNormalScale(0.5)
    self.buttonclose:SetFocusScale(0.55)
    self.buttonclose:SetOnClick(
        function()
            self.repopanel:Hide()
        end
    )

    --按等号键显示或隐藏按钮
    self.repopanel:Hide()
    TheInput:AddKeyUpHandler(61, function()
        if self.repopanel.shown == true then
            self.repopanel:Hide()
        else
            self.repopanel:Show()
        end
    end)

    --定义mypopup按钮组
    self.mypopup = self:AddChild(Widget("mypopup"))
    self.mypopup:SetPosition(0, -430)

    --背景
    self.secondbackground = self.mypopup:AddChild(Image("images/mypanel.xml", "popup.tex"))
    self.secondbackground:SetPosition(0, 0)
    self.secondbackground:SetScale(0.5)

    --文字
    self.popuptext = self.mypopup:AddChild(Text(DEFAULTFONT, 30, ""))
    self.popuptext:SetPosition(0, -10)

    self.mypopup:Hide()
end)

return RepoPanel