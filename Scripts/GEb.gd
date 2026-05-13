extends Node3D

@export_dir var rooms_folder_path: String = "res://scenes/Rooms"
@onready var start_room = $StartRoom

var rooms: Array = []
var current_index: int = 0
var current_room_count: int = 0
var spawned_rooms: Array = []

func _ready() -> void:
	var dir = DirAccess.open(rooms_folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tscn"):
				rooms.append(file_name)
			file_name = dir.get_next()
		rooms.sort()
	
	spawned_rooms.append(start_room)
	
	for i in 5:
		_generate()
	
	DiscordRPC.app_id = 1503994868610109480
	DiscordRPC.start_timestamp = Time.get_unix_time_from_system()
	Vars.room_changed.connect(_update_rpc)
	Vars.floor_changed.connect(_update_rpc)
	_update_rpc()

func _update_rpc():
	DiscordRPC.details = str("Room : ", Vars.room)
	DiscordRPC.state = str("Floor : ", Vars.floor)
	DiscordRPC.refresh()

func _generate():
	if rooms.is_empty():
		return
	
	var room_name = rooms[current_index % rooms.size()]
	current_index += 1
	
	var full_path = rooms_folder_path + "/" + room_name
	var clone = load(full_path).instantiate()
	add_child(clone)
	
	for child in clone.get_children():
		if child.has_signal("door_touched"):
			child.door_touched.connect(_on_room_touched)
			break
	
	var forward_direction = spawned_rooms.back().global_transform.basis.x
	current_room_count += 1
	clone.global_position = spawned_rooms.back().global_position + (forward_direction * 4)
	
	spawned_rooms.append(clone)
	
	if spawned_rooms.size() > 10:
		var old_room = spawned_rooms.pop_front()
		old_room.queue_free()
	
	Vars.room = current_index

func _on_room_touched():
	_generate()
