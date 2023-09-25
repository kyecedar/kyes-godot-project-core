@tool
extends EditorPlugin

const SINGLETON : String = "game"

func _enter_tree():
	add_autoload_singleton(SINGLETON, "res://addons/dog.kye.core/scripts/auto/game.gd")

func _exit_tree():
	remove_autoload_singleton(SINGLETON)
