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


var active_units:Array[CardBaseOnmap]

#备份
func backup_game_state():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_state_machine.initialize(self)
	await get_tree().process_frame
	main_state_machine._on_enter()

func _process(delta: float) -> void:
	main_state_machine._state_process(delta)

func _input(event: InputEvent) -> void:
	main_state_machine._state_input(event)
