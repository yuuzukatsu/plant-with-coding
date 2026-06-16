This script is for a Roblox game called Plant with Coding made by Lated Graham
Check out the game on Roblox !
https://www.roblox.com/games/122761763017872/Plant-with-Coding

Built on `Plant with Coding` version `0.15.3` Lauversion `5.3.1`

Fully Automated "Mid Game" Farm Script !

In game module dependencies

- player  (Important. Used to get and list player seeds in inventory)
- string  (Important. Used to remove "tree" and "bush" on plant name for easier name searching)
- market  (Important. Used to buy seed and sell your produce)
- list    (Important. Used to build FIFO/First In First Out Drone Queue)
- task    (Important. Used to delay produce selling to avoid spamming)
- droneV2 (Important. Used for drone to move around directly into a specific tile)

How it works ?

This script utilize Events that's able to "spawn" a background process that can run simultaneously without interfering with another already running script
One of the way we can do that is by using utilizing `player.input:Once()` which is going to spawn a background process once whenever a player press any kind of input key (WASD and such). Also with `garden` library we can get where a specific plant is planted and check if a tile already had a plant or not, without making our drone go to that tile coordinates !

Why mid game ?
i suppose this still need some more work. There's some moment where droneQueue list is emptied faster by `droneRunner()` compared by `plantHarvester()`, `plantCropper()`, and `seedPlanter()` functions filling `droneQueue` list. Which mean those 3 function isn't fast enough and need more optimization. But with this in mind, we can just add more background process for that ! Your farm is harvest heavy ? Add more `plantHarvester()` !  Your farm is crop heavy ? Add more `plantCropper()` ! Just keep in mind the game limit events or background process to 10 maximum !

By utilizing all above, this script can:
- Scan garden, find empty tile and then plant a seed on them with function `seedPlanter()`
- Find all croppable plant by utilizing `garden.getPlantEnum()` with function `plantCropper()`
- Find all harvestable plant by utilizing `garden.getPlantEnum()` with function `plantHarvester()`
- Those 3 function will run simultaneously and queue a task for the drone on list `droneQueue`
- A function named `droneRunner()` will run everytime a task is listed on `droneQueue` in order while those 3 function keep scanning all plant and tiles
- Everytime new seed arive on market or `market.changedSeedStock:connect` is triggered, this script will automatically buy them using function `buySeedFromMarket()`
- You can also configure on `plantParam.lua` which seed to buy, which seed to plant, which plant to crop, and which plant to harvest !

What does this script do step by step ?
1. sell all produce in inventory with `buySeedFromMarket()` 
2. buy all seed with specified parameter from `plantParam.laum` 
3. Find and list all seed in inventory 
4. wait for user input. after user input any key, run `droneRunner()`, `plantHarvester()`, `plantCropper()`, and `seedPlanter()`  function in background
5. after 30 seconds, sell all produce
6. repeat again from step 5

extra step: watch and wait for market seed change. when market update, it will run  `buySeedFromMarket()` again

script without `droneV2`, `task`, `list`, and `market` module dependency. but its much more unoptimized in speed and script storage => https://github.com/yuuzukatsu/plant-with-coding/tree/v1.0