class_name TerminalCommandParsed
extends Node

var type  : int
var value : Variant

func _init(type: int, value: Variant) -> void:
	self.type = type
	self.value = value
