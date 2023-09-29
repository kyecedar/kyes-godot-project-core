@tool
class_name Bunch
extends Node

func _init(name: String) -> void:
	self.name = name

#region //  BLURBS.

var blurbs : Array[Blurb] = []

func addBlurb() -> Bunch:
	
	return self

#endregion  BLURBS.
