extends TileMap

#this is the global tile map script, the script that is accessible by all other scripts in the world part of the game

#this is the gen_list, depending on the the index of the list the rarity of the blocks change,
#each block has its own id, which is its number and that is what we use in the gen list
const gen_list = [
	[],
	['1'],
	[],
	["9","10","11"], #rare
	["0"], #common
	["2"] #world
]

var world_vals = []#this is the world_vals, in a function below we us the gen list to build this list of values that we use for generation in the world

var mineable_blocks = ["organic_block"]#this is a list that tells us what blocks are mineable, also more blocks are added to this in a function below


var dung = 2#this determines which dungeon the player is going to enter
var arrow = 0#this determines the amount of arrows the player is taking into the dungeon
var d_inv = {}#this determines what the player will take with them to the dungeon

var digging_time = 0.2#this is the digging time, or the time it take for each block to get mined

var equiped = ""#this is the item that is currently equipped
var selected = ""#this is the item that is currently selected

#these are all the recipes for the furnace
var furnace_recipies = {
	"stone_chestplate" : {"stone":8,"chestplate_mold":1,"coal":4},
	"stone_helmet" : {"stone":5,"helmet_mold":1,"coal":4},
	"stone_boots" : {"stone":4,"boots_mold":1,"coal":4},
	"iron_chestplate" : {"iron":8,"chestplate_mold":1,"coal":4},
	"iron_helmet" : {"iron":5,"helmet_mold":1,"coal":4},
	"iron_boots" : {"iron":4,"boots_mold":1,"coal":4},
	"redgold_chestplate" : {"redgold":4,"iron":4,"chestplate_mold":1,"coal":4},
	"redgold_helmet" : {"redgold":2,"iron":3,"helmet_mold":1,"coal":4},
	"redgold_boots" : {"redgold":2,"iron":2,"boots_mold":1,"coal":4},
	
	"stone" : {"stone_ore":1,"coal":1},
	"redgold" : {"redgold_ore":1, "coal":1},
	"iron" : {"iron_ore":1,"coal":1},
	"diamond" : {"diamond_ore":1,"coal":4},
	"amethyst" : {"amethyst_ore":1, "coal":1},
	
	"iron_pickaxehead" : {"pickaxehead_mold":1,"coal":4,"iron":4},
	"amethyst_pickaxehead" : {"pickaxehead_mold":1,"coal":4,"amethyst":2},
	"stone_pickaxehead" : {"pickaxehead_mold":1,"coal":4,"stone":6},
	"diamond_pickaxehead" : {"pickaxehead_mold":1,"coal":12,"diamond":3},
	"redgold_pickaxehead" : {"pickaxehead_mold":1,"coal":4,"redgold":3},
	
	"stone_swordhead" : {"swordhead_mold":1,"coal":4,"stone":6},
	"iron_swordhead" : {"swordhead_mold":1,"coal":4,"iron":4},
	"diamond_swordhead" : {"swordhead_mold":1,"coal":12,"diamond":3}
}


#this are all the recipies for anything thats craftable 
var recipies = { #Nasir - I KNOW WHAT I SAID NESTED DICTINARIES ARE ACTUALLY PRETT COOL :D
	"handle" : {"stick": 4},
	
	"chestplate_mold" : {"copper":5},
	"helmet_mold" : {"copper":5},
	"boots_mold" : {"copper":5},
	"pickaxehead_mold" : {"copper":5},
	"swordhead_mold" : {"copper":5},
	
	"redgold_pickaxe" : {"redgold_pickaxehead":1,"handle":1},
	"amethyst_pickaxe" : {"amethyst_pickaxehead":1, "handle":1},
	"stone_pickaxe" : {"stone_pickaxehead":1,"handle":1},
	"iron_pickaxe" : {"iron_pickaxehead":1,"handle":1},
	"diamond_pickaxe" : {"diamond_pickaxehead":1,"handle":1},
	
	"stone_sword" : {"stone_swordhead":1,"handle":1},
	"iron_sword" : {"iron_swordhead":1,"handle":1},
	"diamond_sword": {"diamond_swordhead":1,"handle":1}
}


onready var orig_names = []#this list is used deeper in the code to save the names of a couple of nodes


var armor = []#this is the armor list thats us what is in the armor
var furnace = []#this is the furnace list that tells us whats in the furnace
var inv = {}#this is the inventory of the player

#these are all the items in the game, when something is added to the inventory this dictionary is accessed
#then both the key and its corresponding value are added which is the list are added to the inventory
var items = {

#materials
	"coal" : [0,"res://items/Sheet496.png","block"],
	"iron" : [0, "res://Items 2/Ore/Sheet473.png"],
	"redgold" : [0,"res://Items 2/Ore/Sheet453.png"],
	"copper" : [0,"res://items/copper ore.png", "block"],
	"redstone" : [0,"res://items/Sprite-0003.png"],
	"amethyst": [0, "res://Items 2/Ore/Sheet465.png"],
	"stone": [0,"res://Items 2/Ore/Sheet451.png"], 
	"diamond" : [0,"res://Items 2/Ore/Sheet447.png"],

#ores
	"redgold_ore" : [0,"res://Items 2/Ore/Sheet485.png","block"],
	"amethyst_ore" : [0, "res://Items 2/Ore/Sheet486.png","block"],
	"stone_ore" : [0,"res://Items 2/Ore/Sheet487.png","block"],
	"diamond_ore" : [0,"res://Items 2/Ore/Sheet488.png","block"],
	"iron_ore" : [0,"res://Items 2/Ore/Sheet490.png","block"],

#health pots
	"health1_pot": [0,"res://items/health_pot.png","heal",50,0,"weapon","potion"],
	"strength1_pot": [0,"res://items/strength_pot.png","strength",10,10,"weapon","potion"],

#molds
	"chestplate_mold" : [0,"res://Items 2/Equipment/Molds/chestplatemold.png"],
	"helmet_mold" : [0,"res://Items 2/Equipment/Molds/helmetmold.png"],
	"boots_mold" : [0,"res://Items 2/Equipment/Molds/bootsmold.png"],
	"pickaxehead_mold" : [0,"res://Items 2/Equipment/Molds/pickaxehead_mold.png"],
	"swordhead_mold" : [0,"res://Items 2/Equipment/Molds/swordhead_mold.png"],

#pickaxes
	"redgold_pickaxe" : [0,"res://Items 2/Equipment/pickaxes/Sheet186.png","equipment","pickaxe"],
	"amethyst_pickaxe" : [0,"res://Items 2/Equipment/pickaxes/Sheet163.png","equipment","pickaxe"],
	"stone_pickaxe" : [0,"res://Items 2/Equipment/pickaxes/Sheet142.png","equipment","pickaxe"],
	"iron_pickaxe" : [0,"res://Items 2/Equipment/pickaxes/Sheet185.png","equipment","pickaxe"],
	"diamond_pickaxe" : [0,"res://Items 2/Equipment/pickaxes/Sheet164.png","equipment","pickaxe"],
#pickaxe heads
	"redgold_pickaxehead" : [0,"res://Items 2/Equipment/pickaxe heads/redgold_pickaxehead.png"],
	"iron_pickaxehead": [0,"res://Items 2/Equipment/pickaxe heads/iron_pickaxehead.png"],
	"diamond_pickaxehead" : [0,"res://Items 2/Equipment/pickaxe heads/diamond_pickaxehead.png"],
	"amethyst_pickaxehead" : [0,"res://Items 2/Equipment/pickaxe heads/amethyst_pickaxehead.png"],
	"stone_pickaxehead" : [0,"res://Items 2/Equipment/pickaxe heads/stone_pickaxehead.png"],
#bow
	"bow" : [0,"res://items/bow.png",5,100,'weapon','equipment','bow'],

#swords
	"stone_sword" : [0,"res://Items 2/Equipment/light weapons/Swords/basic swords/Sheet7.png",10,100, ["Slash",50,2],"weapon",'equipment',"sword"], # -> 1: amount, 2:texture, 3: damage, 4: dur -1: type
	"iron_sword" : [0,"res://Items 2/Equipment/light weapons/Swords/basic swords/Sheet29.png",15,110,["Slash",60,2],"weapon",'equipment',"sword"],
	"diamond_sword" : [0,"res://Items 2/Equipment/light weapons/Swords/basic swords/Sheet45.png",20,110,["Slash",70,2],"weapon",'equipment',"sword"],
#sword heads	
	"stone_swordhead" : [0,"res://Items 2/Equipment/light weapons/Swords/basic swords/sword heads/Sheet7.png"],
	"iron_swordhead" : [0,"res://Items 2/Equipment/light weapons/Swords/basic swords/sword heads/Sheet29.png"],
	"diamond_swordhead" : [0,"res://Items 2/Equipment/light weapons/Swords/basic swords/sword heads/Sheet45.png"],
	
#armor
	"stone_helmet": [0,"res://Items 2/Equipment/armor/Helmets/basic helmets/Sheet200.png",0,100,"equipment","helmet"],
	"stone_chestplate" : [0,"res://Items 2/Equipment/armor/Chestplates/basic chestplate/Sheet223.png",0,100,"equipment","chestplate"],
	"stone_boots" : [0,"res://Items 2/Equipment/armor/Boots/basic boots/Sheet266.png",0,100,"equipment","boots"],
	"iron_helmet" : [0,"res://Items 2/Equipment/armor/Helmets/basic helmets/Sheet202.png",0,150,"equipment","helmet"],
	"iron_chestplate": [0,"res://Items 2/Equipment/armor/Chestplates/basic chestplate/Sheet225.png",0,150,"equipment","chestplate"],
	"iron_boots" : [0,"res://Items 2/Equipment/armor/Boots/basic boots/Sheet270.png",0,150,"equipment","boots"],
	"redgold_helmet" : [0,"res://Items 2/Equipment/armor/Helmets/basic helmets/Sheet206.png",0,200,"equipment","helmet"],
	"redgold_chestplate" : [0,"res://Items 2/Equipment/armor/Chestplates/basic chestplate/Sheet228.png",0,200,"equipment","chestplate"],
	"redgold_boots" : [0,"res://Items 2/Equipment/armor/Boots/basic boots/Sheet272.png",0,200,"equipment","boots"],

	"handle" : [0,"res://items/handle.png"],
	"woodchip" : [0,"res://items/woodchip.png"],
	"stick" : [0,"res://items/stick.png"],

	"bomb_s" : [0,"res://Items 2/Equipment/explosives/Bombs/Sheet143.png",50,1,100,"bomb"]

}
"""
Item guide:
	-potion:
		0 - number
		1 - texture
		2 - effect type
		3 - effect magnitutde
		4 - durration
	health1: 10
	health2: 25
	health3: 50
	strength: 10
	strength: 25
	strength: 50
	-bombs:
		0 - number
		1 - texture
		2 - damage(dungeon only)
		3 - radius (mining)
		4 - radius (dungeon)
	-blocks:
		0 - number
		1 - texture
	-swords:
		0: amount
		1: texture
		2: damage
		3: dur
		4: ability
			0: name
			1: dmg
			2: cooldown
		-1: type



"""




func _ready(): #as soon as the script is ready add all items which have block at the end of their list to mineable blocks
	for i in items.keys():
		if items[i][-1] == "block":
			mineable_blocks.append(i)
	gen()#generate the world_vals list

var move = false

var posi


var update_inv = true#used to check when it is necessary to update inventory
func inventory(list, list2):#this runs whenever the inventory is updated
	#basically what it does is that it goes through all the panels in the inventory and makes sure every new item added goes to the right place
	if not visible:
		return
	var name_list = []
	for x in list:
		name_list.append(x.name)
	#mark = []
	if !(inv.empty()):
		for key in inv.keys():
			var c = 0
			if !(key in name_list):
				for i in list:
					if i.get_child(0).texture == null:
						if str(inv[key][-2]) == "equipment" and !(key in list2):
							i.get_child(1).text = ""
							i.get_child(0).texture = load((inv)[key][1])
							i.name = key
							break
						elif str(inv[key][-2]) != "equipment" and !(key in furnace):
							i.get_child(1).text = str(inv[key][0])
							i.get_child(0).texture = load((inv)[key][1])
							i.name = key
							break
					c += 1
	update_inv = false





func gen():#this is the function that generates the world vals list
	world_vals = []
	var x = 0
	for i in gen_list:
		x+=1
		for p in i:
			for _e in range(pow(5,x)):#depending on your location in the gen list then more of your values will be in the world vals list
				#for example with an index of 1 5^1 = 5 and therefore only five of your values will be in the world vals list
				#whilst and index of 5 5^5 = 3125 so 3125 values will be found in world vals making it significantly for common 
				world_vals.append(p)
