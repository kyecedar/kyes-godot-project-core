@tool
extends Node

#region //  LOGGER.

static var logs : Array[String] = []

static func etch(status: Logger.STATUS, fuck: String) -> void:
	pass

func _ready():
	etch(Logger.STATUS.INFO, "shit")

#endregion  LOGGER.

#region //  TERMINAL.

static var terminal : TerminalNode
static var on_terminal_ready : Callable

## Set current terminal node to given node.[br]
## All etches and logs will be shown on it when assigned.[br]
## Calls [member game.on_terminal_ready].
static func set_current_terminal(node: TerminalNode) -> void:
	terminal = node
	if on_terminal_ready:
		on_terminal_ready.call()

#endregion  TERMINAL.
