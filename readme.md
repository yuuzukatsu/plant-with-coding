This script is for a Roblox game called Plant with Coding made by Lated Graham
Check out the game on Roblox !
https://www.roblox.com/games/122761763017872/Plant-with-Coding

In game module dependencies 
- player (Important. To get player inventory)
- string (Important. To detect whether plant can have fruits or not)
- market (Optional. Only for selling fruits and crop)

if you decide to not use market module, you can comment out market syntax at line 75 and line 99 by adding `--` at the beginning of the line
```
	if start_sell_all then
		print("Selling all Fruits and Crops in inventory")
		-- market.sellAllItem()
	end
```
```
	if sell_after_drone_grid_loop then
		varol oldSC = player.scrap()
		print("Selling all Fruits and Crops in inventory")
		-- market.sellAllItem()
		print("You sold", player.scrap()-oldSC, "SC worth of Fruits and Crops !")
	end
```

Feature :
- The drone will try to harvest all plant. 
- If harvesting is not possible, it will check whether the plant will grow fruit or not. 
- If the plant is not going to grow fruit and its on 100% growth, the drone will crop it  
- Customizable Grid Size. Any grid size is theorically possible, but current grid size is capped at 27 x 27. Configurable through variable `grid_width` and `grid_height`
- Plant specific seed only. Configurable through List variable `seed_to_plant` 
- Automatically sell fruits and crop (need market module)