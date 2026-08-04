extends Node
class_name MainGame

@onready var main_state_machine: StateMachineBase = $MainStateMachine
@onready var turn_judge_manager: TurnJudgeManager = $TurnJudgeManager
@onready var combat: Attack = $Combat
@onready var movement: Movement = $Movement
@onready var occupancy: Occupancy = $Occupancy
@onready var deal_cards: DealCards = $DealCards
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var grid_range: GridRange = $GridRange
@onready var hand_root: HandRoot = $HandLayer/HandRoot
@onready var draw_high_light_area: DrawHighLightArea = $Map/DrawHighLightArea
@onready var map: Map = $Map
@onready var game_grid: GameGrid = $Map/GameGrid
@onready var arm: ARM = $Arm
@onready var hand_card_info: HandCardInfo = $InfoLayer/InfoRoot/HandCardInfo
@onready var map_card_info: MapCardInfo = $InfoLayer/InfoRoot/MapCardInfo
@onready var map_card_operate: MapCardOperate = $OperateLayer/MapCardOperate
@onready var action_point: ActionPoint = $GameStatusLayer/ActionPoint

var my_faction:Data.Faction = Data.Faction.NULL

#只有服务端有两者id
var player1_id:int
var player2_id:int


var start_player = 0
var current_action_player:Data.Faction = Data.Faction.NULL

var DEFALUT_ACTION_POINT:int = 5
var MAX_ACTION_POINT:int = 10
var current_player1_action_point:int = 0
var current_player2_action_point:int = 0

var player1_draw_count_delta = 0
var player2_draw_count_delta = 0

var player1_hand:Array[int]=[]
var player2_hand:Array[int]=[]

var hand_card_be_selected:CardBaseOnhand = null
var player2_hand_card_selected_id:int = -1
var map_card_be_selected:CardBaseOnmap = null
var map_action_card:CardBaseOnmap = null
var clicked_position:Vector2i
var player2_clicked_position:Vector2i
var id_map_card_map:Dictionary

#备份
func backup_game_state():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	NetRelay.sync_main_init.connect(_on_sync_main_init)
	NetRelay.sync_action_point.connect(_on_sync_action_point)
	NetRelay.sync_turn_change.connect(_on_sync_turn_change)
	if LanNetwork.is_host():
		my_faction = Data.Faction.PLAYER1
		# 房主加载完成后，同步初始对局数据
		NetRelay.rpc("net_sync_main_init")
	else:
		my_faction = Data.Faction.PLAYER2
	game_grid._init_grid()

func _process(delta: float) -> void:
	main_state_machine._state_process(delta)

func _input(event: InputEvent) -> void:
	main_state_machine._state_input(event)

func _on_sync_main_init() ->void:
# 初始化棋盘、单位、回合等
	main_state_machine.initialize(self)
	await get_tree().process_frame
	if my_faction == Data.Faction.PLAYER1:
		main_state_machine._on_enter()
		player1_id = multiplayer.get_unique_id()
		for id in LanNetwork.players.keys():
			if id != player1_id:
				player2_id = id
				break
	randomize()
	await get_tree().process_frame
	print("对局初始化完成")

func _on_sync_action_point(player:Data.Faction, value:int):
	if player == Data.Faction.PLAYER1:
		current_player1_action_point = value
	else:
		current_player2_action_point = value

func _on_sync_turn_change(faction:Data.Faction):
	current_action_player = faction


func is_my_turn() -> bool:
	return my_faction == current_action_player
