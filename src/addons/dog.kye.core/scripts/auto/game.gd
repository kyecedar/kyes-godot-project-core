@tool
extends Node

#region // COLORS.

# be wary of bbcode injection. dunno why or where that'd be a problem, but yeah.
static var LIGHT_TEXT_COLOR  : String = "#FFFFFF88" ## BBCode text color.
static var RED_TEXT_COLOR    : String = "#FF5F5F"   ## BBCode text color.
static var YELLOW_TEXT_COLOR : String = "#FFDE66"   ## BBCode text color.
static var GREEN_TEXT_COLOR  : String = "#FFDE66"   ## BBCode text color.
static var BLUE_TEXT_COLOR   : String = "#328FF3"   ## BBCode text color.

static var MEMBER_NAME_COLOR : String = LIGHT_TEXT_COLOR         ## BBCode text color for member names.
static var NULL_COLOR        : String = RED_TEXT_COLOR           ## BBCode text color for null values.
static var VECTOR_X_COLOR    : String = RED_TEXT_COLOR           ## BBCode text color for vector x values.
static var VECTOR_Y_COLOR    : String = GREEN_TEXT_COLOR         ## BBCode text color for vector y values.
static var VECTOR_Z_COLOR    : String = BLUE_TEXT_COLOR          ## BBCode text color for vector z values.
static var TIMER_EMPTY_COLOR : String = LIGHT_TEXT_COLOR         ## BBCode text color for timer values when empty.
static var TIMER_WAIT_COLOR  : String = YELLOW_TEXT_COLOR + "88" ## BBCode text color for timer values while waiting.
static var TIMER_FULL_COLOR  : String = BLUE_TEXT_COLOR          ## BBCode text color for timer values while full/executing.

#endregion COLORS.

static var on_ready : Callable = func(): pass

static var s_entity    : System = create_system("ENTITY")
static var s_component : System = create_system("COMPONENT")
static var s_system    : System = create_system("SYSTEM")

static var s_logger    : System = create_system("LOGGER")
static var s_terminal  : System = create_system("TERMINAL")
static var s_blurb     : System = create_system("BLURB")

func _ready() -> void:
	game.order_system(s_entity)
	game.order_system(s_component)
	game.order_system(s_system)
	
	game.order_system(s_logger)
	game.order_system(s_terminal)
	game.order_system(s_blurb)
	
	if on_ready:
		on_ready.call()

#region //  COMPONENT.



#endregion  COMPONENT.

#region //  SYSTEMS.

static var system_registry : Dictionary = {}
static var execution_order : Array[System] = []

## Adds system to execution order.
static func order_system(system: System) -> game:
	execution_order.push_back(system)
	return game

## Creates and adds system to registry
static func create_system(name: String) -> System:
	var system = System.new(name)
	if system_registry.has(name) :
		Logger.warn("System %s already existed. Did not replace." % [name], s_system)
	else:
		system_registry[name] = system
	return system

#endregion  SYSTEMS.



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
	if on_terminal_ready:
		on_terminal_ready.call()

#endregion  TERMINAL.
