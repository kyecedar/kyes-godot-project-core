class_name TerminalCommandGroup
extends Node

var description : String
var commands : Array[String] = []

func _init(description: String) -> void:
	self.description = description

func add(commands: PackedStringArray = []) -> TerminalCommandGroup:
	for command: String in commands:
		self.commands.push_back(command)
	return self

func remove(command: String) -> void:
	var i = commands.find(command)
	if i == -1:
		return
	commands.remove_at(i)
