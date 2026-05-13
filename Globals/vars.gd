extends Node

signal room_changed
signal floor_changed

var _room: int = 0
var _floor: int = 0

var room: int:
	get: return _room
	set(value):
		_room = value
		room_changed.emit()

var floor: int:
	get: return _floor
	set(value):
		_floor = value
		floor_changed.emit()
