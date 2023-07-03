Config = {}

Config.Locale = 'tw'

Config.oldESX = false   -- true is for ESX 1.1/1.2

Config.Discord = {  -- Discord 紀錄
    enable = true,  -- 是否啟用
    webhook = '',   -- WebHook
    imgURL = '',    -- 伺服器頭像
}

Config.Zone = {
    {
        pos = vec3(-633.99, 2926.79, 13.26),   --位置
        rate = 1,       --黑錢To白錢x多少
        jobs = 'admin',  --職業, 無須限制填nil
        blip = true,    --是否要在地圖放圖標
        name = '測試點一',   --顯示名稱
        dispatchRate = 20   --觸發警察通報機率(須自己寫入警察通報內容)
    },
    {
        pos = vec3(-631.6, 2928.24, 13.24),
        rate = 0.8,
        jobs = {
            ['gang'] = 3,   --[職位]=最低可用位階
            ['gang2'] = 3,
            ['gang3'] = 3
        },
        name = '測試點二',
        blip = false
    },
}

Config.PriceTime = 40   --基底讀條為8秒, 每洗1000黑錢, 讀條增加多少毫秒

if not IsDuplicityVersion() then
    function TextUI(msg) -- 顯示自己常用的TextUI, 例: esx、ox、okok
        ESX.TextUI(msg)
        --lib.showTextUI(msg)
        --exports['okokTextUI']:Open(msg, 'lightblue', 'right')
    end
    
    function HideUI()   --隱藏TextUI
        ESX.HideUI()
        --lib.hideTextUI()
        --exports['okokTextUI']:Close()
    end
    
    function ProgressBar(duration, label, anim, scenario, onFinish, onCancel)   -- 自己常用的讀條, 例: esx、ox、mythic
        ESX.Progressbar(label, duration, {
            FreezePlayer = true,
            animation = {
                type = scenario and 'Scenario' or 'anim',
                dict = anim.dict,
                lib = anim.clip,
                Scenario = scenario
            },
            onFinish = function()
                if onFinish then
                    onFinish()
                end
            end,
            onCancel = function()
                if onCancel then
                    onCancel()
                end
            end
        })
        return true
        --[[if lib.progressBar({    -- ox_lib
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                move = true,
                combat = true,
                mouse = true
            },
            anim = {
                scenario = scenario or nil,
                dict = anim and anim.dict,
                clip = anim and anim.clip
            }
        }) then
            if onFinish then
                onFinish()
            end
        else
            if onCancel then
                onCancel()
            end
        end]]
        --[[TriggerEvent("mythic_progbar:client:progress", {    -- mythic_progbar
            name = "eric_moneywash",
            duration = duration,
            label = label,
            useWhileDead = false,
            canCancel = false,
            controlDisables = {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = true,
                disableCombat = true,
            },
            animation = {
                animDict = anim and anim.dict,
                anim = anim and anim.clip,
                task = scenario or nil
            }
        }, function(status)
            if not status then
                if onFinish then
                    onFinish()
                end
            else
                if onCancel then
                    onCancel()
                end
            end
        end)]]
    end

    function CancelProgress(onCancel)   -- 取消讀條
        --lib.cancelProgress()
        --TriggerEvent("mythic_progbar:client:cancel")
    end

    RegisterNetEvent("eric_moneywash:notify")   --自己常用的Notify, 例: esx、ox、okokNotify、mythic
    AddEventHandler("eric_moneywash:notify", function(msg, type)
        ESX.ShowNotification(msg, type)
        --TriggerEvent("ox_lib:notify", {description = msg, type = type})
        --exports.okokNotify:Alert("黑錢", msg, 3000, type, true)
        --exports['mythic_notify']:SendAlert(type, msg, 5000)
    end)

    RegisterNetEvent("eric_moneywash:dispatch")
    AddEventHandler("eric_moneywash:dispatch", function(coords)
    end)
end
