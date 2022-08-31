Config = {}

Config.DrugList = {
    ['weed'] = { --ชื่อไอเทมที่ใช้ขาย
        Timeout = 100, -- เวลานับถอยหลังระบุเป็นวินาที
        Dirtymoney = true, --ได้เงินเขียวหรือเงินเเดง true = เงินเเดง false = เงินเขียว
        Price = {1000, 1500}, -- ราคา 
        SellPerCent = 100, -- % การขายออก
        CopCount = 0, -- จำนวนตำรวจ
        Success = {
            PercentFreezeCallCop = 0, -- freeze เเละ เเจ้งตำรวจ
            Freeze = 10000, -- เเจ้งตำรวจมั้ย
        },
        Fail = {
            PercentFreezeCallCop = 10, -- freeze เเละ เเจ้งตำรวจ
            Freeze = 10000, -- 
        },
    },
}

Config.Model = 'a_m_m_afriamer_01' -- โมเดล NPC ที่ spawn

Config.CoordsRandom = { --จุดที่สุ่มเกิด NPC
    vector3(-451.77, -265.44, 35.86),
    -- vector3(-45.29, -1727.63, 29.3)
}

function GetPolice()
    local PoliceCount = exports["sm-data"]:SM_GET_DATA('police') -- ใส่ function การเช็คหน่วยงานที่นี้
    return PoliceCount
end 

function PoliceAlert()
    -- ใส่ event เเจ้งเตือนตำรวจได้เลย
end 
