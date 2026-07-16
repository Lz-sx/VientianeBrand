extends Node

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
	BUILDING,
	WEAPON,
	ARMOR,
	SKILL,
}

var card_data:Dictionary = {
	0:{
		"name":"大本营","hand_uid":"uid://bsfevywtjtfko","map_uid":"uid://bix7xf80pa2x8",
		"affiliation":Affiliation.MORTAL,"type":Type.BUILDING,
		"hp":30,"damage":10,"attack_range":7,"capacity":0,
		"text":"不要爆了就行"
	},
	1:{
		"name":"武士","hand_uid":"uid://va7mf6bcwcax","map_uid":"uid://bqurcqpdries",
		"affiliation":Affiliation.MORTAL,"type":Type.CHARACTER,
		"hp":20,"damage":10,"attack_range":1,"speed":2,
		"text":"平平无奇"
	},
	2:{
		"name":"马","hand_uid":"uid://bcjly5e8n0h5h","map_uid":"uid://b4utn1adkr2cv",
		"affiliation":Affiliation.MORTAL,"type":Type.VEHICLE,
		"hp":20,"damage":5,"attack_range":1,"speed":5,"capacity":1,
		"text":"这是马"
	},
	3:{
		"name":"瞭望塔","hand_uid":"uid://oebutx1q38fk","map_uid":"uid://dp1lbplm5vws",
		"affiliation":Affiliation.MORTAL,"type":Type.BUILDING,
		"hp":30,"damage":10,"attack_range":6,"capacity":1,
		"text":"站得高，看得远"
	},
	4:{
		"name":"铠甲","hand_uid":"uid://fffptp88pfnc","map_uid":null,
		"affiliation":Affiliation.MORTAL,"type":Type.ARMOR,
		"damage_reduction":5,
		"text":"超薄"
	},
	5:{
		"name":"剑","hand_uid":"uid://3u80sra8fdel","map_uid":null,
		"affiliation":Affiliation.MORTAL,"type":Type.WEAPON,
		"damage":5,
		"text":"剑来！！"
	},
	6:{
		"name":"火球","hand_uid":"uid://bslo38b3g0458","map_uid":null,
		"affiliation":Affiliation.ABYSSAL,"type":Type.SKILL,
		"damage":10,
		"text":"fireboll"
	}
}
