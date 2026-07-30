extends Control
const MAIN_GAME = preload("uid://tdb8d8mdvj61")
const MAIN_MENU = "res://src/ui/main_menu/main_menu.tscn"

@onready var panel_connect: Control = $PanelConnect
@onready var panel_room: Control = $PanelRoom
@onready var line_edit_port: LineEdit = $PanelConnect/CreateServer/LineEdit
@onready var line_edit_ip: LineEdit = $PanelConnect/JoinServer/LineEdit
@onready var vbox_player_list = $PanelRoom/PlayerList
@onready var button_ready = $PanelRoom/ReadyButton
@onready var button_start = $PanelRoom/StartButton
@onready var label_status = $LabelStatus


func _ready():
	# 绑定全局网络信号
	LanNetwork.player_connected.connect(_on_player_joined)
	LanNetwork.player_disconnected.connect(_on_player_left)
	LanNetwork.player_ready_changed.connect(_on_ready_changed)
	LanNetwork.server_disconnected.connect(_on_server_lost)
	
	# 默认只显示连接面板
	panel_room.visible = false
	panel_connect.visible = true


# ========== 按钮回调 ==========
# 创建房间
func _on_button_create_server_pressed() -> void:
	var err = LanNetwork.create_room()
	if err != OK:
		label_status.text = "创建失败：端口被占用"
		return
	label_status.text = "房间已创建，等待玩家加入"
	_enter_room_view()


# 加入房间
func _on_button_join_server_pressed() -> void:
	var ip = line_edit_ip.text
	var err = LanNetwork.join_room(ip)
	if err != OK:
		label_status.text = "连接发起失败，请检查IP格式"
		return
	label_status.text = "正在连接..."


# 切换准备状态
func _on_button_toggle_ready_pressed() -> void:
	LanNetwork.toggle_self_ready()


# 房主开始游戏
func _on_button_start_game_pressed() -> void:
	if not LanNetwork.is_all_ready():
		label_status.text = "对方尚未准备"
		return
	LanNetwork.request_start_game()


# 返回主菜单
func _on_button_back_pressed() -> void:
	print("1. 按钮被点击")
	LanNetwork.remove_connection()
	print("2. 网络清理完成")
	get_tree().change_scene_to_file(MAIN_MENU)
	print("3. 场景切换指令已发出")

# ========== UI刷新 ==========
func _enter_room_view() -> void:
	panel_connect.visible = false
	panel_room.visible = true
	# 房主显示开始按钮，客户端隐藏
	button_start.visible = LanNetwork.is_host()
	_refresh_player_list()


func _refresh_player_list() -> void:
	# 清空旧列表
	for child in vbox_player_list.get_children():
		child.queue_free()
	
	# 生成玩家条目
	for peer_id in LanNetwork.players:
		var info = LanNetwork.players[peer_id]
		var ready_ = LanNetwork.player_ready.get(peer_id, false)
		
		var label = Label.new()
		label.text = "%s  %s" % [info.name, "【已准备】" if ready_ else "【未准备】"]
		if peer_id == 1:
			label.text += " （房主）"
		vbox_player_list.add_child(label)
	
	# 刷新准备按钮文本
	var my_id = multiplayer.get_unique_id()
	var my_ready = LanNetwork.player_ready.get(my_id, false)
	button_ready.text = "取消准备" if my_ready else "准备"


# ========== 信号回调 ==========
func _on_player_joined(_id, _info) -> void:
	label_status.text = "玩家已加入"
	_refresh_player_list()
	# 客户端连接成功后进入房间视图
	if LanNetwork.is_net_connected() and not panel_room.visible:
		_enter_room_view()


func _on_player_left(_id) -> void:
	label_status.text = "对方已离开房间"
	_refresh_player_list()


func _on_ready_changed(_id, _ready) -> void:
	_refresh_player_list()


func _on_server_lost() -> void:
	label_status.text = "与房主断开连接"
	panel_room.visible = false
	panel_connect.visible = true
