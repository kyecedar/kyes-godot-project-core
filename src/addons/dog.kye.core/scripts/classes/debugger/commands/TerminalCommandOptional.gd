class_name TerminalCommandOptional
extends Node

var value: Variant

func _init(name: String, value: Variant = null) -> void:
	self.name = name
	self.value = value
