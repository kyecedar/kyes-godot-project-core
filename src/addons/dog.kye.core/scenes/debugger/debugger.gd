@tool
class_name Debugger
extends Control

## Only allow the debugger to be accessed in project's debug mode.
@export var only_allow_in_debug : bool = true

func _ready() -> void:
	if only_allow_in_debug and not OS.is_debug_build() and not Engine.is_editor_hint():
		queue_free()

#region //  BLURBS.

static var blurbs : Array[Blurb] = []

# TODO : only update bunch if blurbs is visible.
# self, "member name"

static func createBunch() -> Bunch:
	return Bunch.new()

#endregion  BLURBS.
