extends Node

# ===== 全局信号 =====
signal player_connected(peer_id, player_info)
signal player_disconnected(peer_id)
signal player_ready_changed(peer_id, is_ready)  # 玩家准备状态变化
signal game_starting()                           # 即将开始游戏
signal server_disconnected

# ===== 房间配置 =====
const PORT = 7000
const DEFAULT_IP = "127.0.0.1"
const MAX_PLAYERS = 2  # 固定双人
const MAIN_GAME = preload("uid://tdb8d8mdvj61")

# ===== 连接状态 =====
enum ConnectionState { IDLE, HOSTING, CONNECTING, CONNECTED }
var current_state: ConnectionState = ConnectionState.IDLE

# ===== 房间数据 =====
var players: Dictionary = {}        # key: peer_id, value: 玩家信息字典
var player_ready: Dictionary = {}   # key: peer_id, value: bool 是否准备
var local_player_info: Dictionary = {"name": "玩家"}  # 本地玩家昵称，可在UI层修改


func _ready():
	# 绑定系统网络信号
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


# ========== 1. 创建房间（房主）==========
func create_room() -> Error:
	remove_connection()
	
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT, MAX_PLAYERS)
	if err != OK:
		return err
	
	multiplayer.multiplayer_peer = peer
	current_state = ConnectionState.HOSTING
	
	# 初始化房主数据
	players[1] = local_player_info
	player_ready[1] = false
	
	player_connected.emit(1, local_player_info)
	return OK


# ========== 2. 加入房间（客户端）==========
func join_room(ip: String = "") -> Error:
	remove_connection()
	if ip.is_empty():
		ip = DEFAULT_IP
	
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(ip, PORT)
	if err != OK:
		return err
	
	multiplayer.multiplayer_peer = peer
	current_state = ConnectionState.CONNECTING
	return OK


# ========== 3. 清理连接 ==========
func remove_connection() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	player_ready.clear()
	current_state = ConnectionState.IDLE


# ========== 4. 准备状态切换 ==========
func toggle_self_ready() -> void:
	var my_id = multiplayer.get_unique_id()
	var new_state = not player_ready.get(my_id, false)
	# 广播自己的准备状态
	rpc("sync_player_ready", my_id, new_state)


# 全员同步准备状态
@rpc("any_peer", "call_local", "reliable")
func sync_player_ready(peer_id: int, is_ready: bool) -> void:
	player_ready[peer_id] = is_ready
	player_ready_changed.emit(peer_id, is_ready)


# ========== 5. 开始游戏（仅房主可调用）==========
func request_start_game() -> void:
	# 仅房主有权限触发
	if not is_host():
		return
	# 校验：必须满2人
	if players.size() < MAX_PLAYERS:
		return
	
	game_starting.emit()
	# 全员切换战斗场景
	rpc("load_battle_scene")


# 全员加载战斗场景
@rpc("call_local", "reliable")
func load_battle_scene() -> void:
	get_tree().change_scene_to_packed(MAIN_GAME)


# ========== 6. 连接回调 ==========
# 有新玩家加入（服务端触发）
func _on_peer_connected(peer_id: int) -> void:
	# 向新玩家同步自己的信息
	_send_player_info.rpc_id(peer_id, local_player_info)


# 接收玩家信息同步
@rpc("any_peer", "reliable")
func _send_player_info(info: Dictionary) -> void:
	var sender_id = multiplayer.get_remote_sender_id()
	players[sender_id] = info
	player_ready[sender_id] = false
	player_connected.emit(sender_id, info)


# 玩家断开连接
func _on_peer_disconnected(peer_id: int) -> void:
	players.erase(peer_id)
	player_ready.erase(peer_id)
	player_disconnected.emit(peer_id)


# 客户端连接成功
func _on_connected_ok() -> void:
	current_state = ConnectionState.CONNECTED
	var my_id = multiplayer.get_unique_id()
	players[my_id] = local_player_info
	player_ready[my_id] = false
	player_connected.emit(my_id, local_player_info)


# 客户端连接失败
func _on_connected_fail() -> void:
	remove_connection()


# 客户端与服务器断开
func _on_server_disconnected() -> void:
	remove_connection()
	server_disconnected.emit()


# ========== 7. 状态查询工具函数 ==========
func is_host() -> bool:
	return current_state == ConnectionState.HOSTING

func is_net_connected() -> bool:
	return current_state == ConnectionState.CONNECTED or current_state == ConnectionState.HOSTING

func is_all_ready() -> bool:
	if players.size() < MAX_PLAYERS:
		return false
	for ready in player_ready.values():
		if not ready:
			return false
	return true
