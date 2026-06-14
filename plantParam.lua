varol plantList = {
["Wheat"] = {
    ["seed"] = Enum.Seed.Wheat,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Potato"] = {
    ["seed"] = Enum.Seed.Potato,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Carrot"] = {
    ["seed"] = Enum.Seed.Carrot,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Bush"] = {
    ["seed"] = Enum.Seed.Bush,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Tree"] = {
    ["seed"] = Enum.Seed.Tree,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Apple"] = {
    ["seed"] = Enum.Seed.Apple,
    ["harvest"] = true,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Onion"] = {
    ["seed"] = Enum.Seed.Onion,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Pumpkin"] = {
    ["seed"] = Enum.Seed.Pumpkin,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Strawberry"] = {
    ["seed"] = Enum.Seed.Strawberry,
    ["harvest"] = true,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Blueberry"] = {
    ["seed"] = Enum.Seed.Blueberry,
    ["harvest"] = true,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Tomato"] = {
    ["seed"] = Enum.Seed.Tomato,
    ["harvest"] = true,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = false
},
["Grape"] = {
    ["seed"] = Enum.Seed.Grape,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Bamboo"] = {
    ["seed"] = Enum.Seed.Bamboo,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = true
},
["Corn"] = {
    ["seed"] = Enum.Seed.Corn,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Cactus"] = {
    ["seed"] = Enum.Seed.Cactus,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Pineapple"] = {
    ["seed"] = Enum.Seed.Pineapple,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Pear"] = {
    ["seed"] = Enum.Seed.Pear,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Pepper"] = {
    ["seed"] = Enum.Seed.Pepper,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Banana"] = {
    ["seed"] = Enum.Seed.Banana,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Watermelon"] = {
    ["seed"] = Enum.Seed.Watermelon,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = true
},
["Mushroom"] = {
    ["seed"] = Enum.Seed.Mushroom,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = true
},
["Mango"] = {
    ["seed"] = Enum.Seed.Mango,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Coconut"] = {
    ["seed"] = Enum.Seed.Coconut,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Cacao"] = {
    ["seed"] = Enum.Seed.Cacao,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Lotus"] = {
    ["seed"] = Enum.Seed.Lotus,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Kiwi"] = {
    ["seed"] = Enum.Seed.Kiwi,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Lemon"] = {
    ["seed"] = Enum.Seed.Lemon,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Garlic"] = {
    ["seed"] = Enum.Seed.Garlic,
    ["harvest"] = false,
    ["crop"] = true,
    ["buy"] = false,
    ["plant"] = true
},
["Pomegranate"] = {
    ["seed"] = Enum.Seed.Pomegranate,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Cherry"] = {
    ["seed"] = Enum.Seed.Cherry,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Dragon"] = {
    ["seed"] = Enum.Seed.Dragon,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
["Starfruit"] = {
    ["seed"] = Enum.Seed.Starfruit,
    ["harvest"] = true,
    ["crop"] = false,
    ["buy"] = false,
    ["plant"] = true
},
}

varol plantParam = {}

plantParam.getPlantList = plantList

plantParam.updateSeedAmount = func(keys,amount)
    plantList[keys].amount = amount
end

return plantParam