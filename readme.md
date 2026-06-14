This script is for a Roblox game called Plant with Coding made by Lated Graham
Check out the game on Roblox !
https://www.roblox.com/games/122761763017872/Plant-with-Coding

Built on `Plant with Coding` version 0.15.3

In game module dependencies

- player  (Important. Used to get and list player seeds in inventory)
- string  (Important. Used to remove "tree" and "bush" on plant name for easier name searching)
- market  (Important. Used to buy seed and sell your produce)
- list    (Important. Used to build FIFO/First In First Out Drone Queue)
- task    (Important. Used to delay produce selling to avoid spamming)
- droneV2 (Important. Used for drone to move around directly into a specific tile)

How it works ?

This script utilize Events that's able to "spawn" a background process that can run simultaneously without interfering with another already running script
One of the way we can do that is by using utilizing `player.input:Once()` which is going to spawn a background process once whenever a player press any kind of input key (WASD and such)

By utilizing that, this script can:
- Find all empty tile and plant a seed on them with function `seedPlanter()`
- Find all croppable plant with function `plantCropper()`
- Find all harvestable plant with function `plantHarvester()`
- Those 3 function will run simultaneously and queue a task for the drone on list `droneQueue`
- A function named `droneRunner()` will run everytime a task is listed on `droneQueue` in order while those 3 function keep scanning all plant and tiles
- Everytime new seed arive on market or `market.changedSeedStock:connect` is triggered, this script will automatically buy them using function `buySeedFromMarket()`
- You can also configure on `plantParam.lua` which seed to buy, which seed to plant, which plant to crop, and which plant to harvest !