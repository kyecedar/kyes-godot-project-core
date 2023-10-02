class_name TerminalCommandGroup
extends Node

var description : String
var commands : Array[String] = []

func _init(description: String) -> void:
	self.description = description

func add_command(command: String) -> void:
	commands.push_back(command)

func remove_command(command: String) -> void:
	var i = commands.find(command)
	if i == -1:
		return
	commands.remove_at(i)
