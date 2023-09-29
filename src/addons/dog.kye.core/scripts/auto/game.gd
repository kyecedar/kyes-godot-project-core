@tool
extends Node

static var on_ready : Callable = (func() -> void: pass)

func _ready() -> void:
	Logger.info("this is what info looks like.",           "GAME")
	Logger.success("this is what a success looks like.",   "GAME")
	Logger.warn("this is what a warning looks like.",      "GAME")
	Logger.error("this is what an error looks like.",      "GAME")
	Logger.fatal("this is what a fatal error looks like.", "GAME")
	
	if on_ready:
		on_ready.call()

#region //  LOGGER.

static var logs : Array[String] = []

static func etch(status: Logger.STATUS, system: System) -> void:
	pass

#endregion  LOGGER.

#region //  TERMINAL.

static var terminal : TerminalNode
static var on_terminal_ready : Callable

## Set current terminal node to given node.[br]
## All etches and logs will be shown on it when assigned.[br]
## Calls [member game.on_terminal_ready].
static func set_current_terminal(node: TerminalNode) -> void:
	terminal = node
	Terminal._handle_missed_logs()
	if on_terminal_ready:
		on_terminal_ready.call()

#endregion  TERMINAL.
