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

var start_player = 0

var DEFALUT_ACTION_POINT:int = 10
var MAX_ACTION_POINT:int = 10
var current_player1_action_point:int = 0
var current_player2_action_point:int = 0

var player1_draw_count_delta = 0
var player2_draw_count_delta = 0

var player1_hand:Array[int]=[]
var player2_hand:Array[int]=[]

var hand_card_be_selected:CardBaseOnhand = null
var map_card_be_selected:CardBaseOnmap = null
var map_action_card:CardBaseOnmap = null
var clicked_position:Vector2i
#var active_units:Array[CardBaseOnmap]

#备份
func backup_game_state():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if LanNetwork.is_host():
		my_faction = Data.Faction.PLAYER1
		# 房主加载完成后，同步初始对局数据
		rpc("sync_battle_init")
	else:
		my_faction = Data.Faction.PLAYER2

func _process(delta: float) -> void:
	main_state_machine._state_process(delta)

func _input(event: InputEvent) -> void:
	main_state_machine._state_input(event)

@rpc("any_peer", "call_local", "reliable")
func sync_battle_init() -> void:
	# 初始化棋盘、单位、回合等
	main_state_machine.initialize(self)
	await get_tree().process_frame
	main_state_machine._on_enter()
	game_grid._init_grid()
	randomize()
	await get_tree().process_frame
	print("对局初始化完成")
