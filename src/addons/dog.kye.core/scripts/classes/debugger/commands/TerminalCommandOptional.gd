class_name TerminalCommandOptional
extends Node

enum {
	TYPE_COMMAND = -1,
	TYPE_FLAG    = -2,
}

var value: Variant

func _init(name: String, value: Variant = null) -> void:
	self.name = name
	self.value = value
