@tool
extends Node

#region //  LOGGER.

static var logs : Array[String] = []

static func etch(status: Logger.STATUS, fuck: String) -> void:
	pass

func _ready():
	etch(Logger.STATUS.INFO, "shit")

#endregion  LOGGER.
