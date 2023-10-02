class_name TerminalCommandOptional
extends Node

enum {
	TYPE_COMMAND = -1,
	TYPE_FLAG    = -2,
}

var type  : int
var value : Variant

func _init(type: int, value: Variant) -> void:
	self.type = type
	self.value = value
