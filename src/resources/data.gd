extends Node
class_name Data
enum Faction{
	PLAYER1=1, 
	PLAYER2
}

enum Affiliation{
	ABYSSAL=1,
	MORTAL,
	CELESTIAL,
}

enum Type{
	CHARACTER=1,
	VEHICLE,
	WEAPON,
	ARMOR,
	SKILL,
}

var card_data:Dictionary = {
	1:{
		"name":"武士","hand_uid":"uid://va7mf6bcwcax","map_uid":"uid://bqurcqpdries",
		"affiliation":Affiliation.MORTAL,"type":Type.CHARACTER,
		"hp":20,"damage":10,"speed":2,
		"text":"平平无奇"
	},
	2:{
		
		
	}
	
}
