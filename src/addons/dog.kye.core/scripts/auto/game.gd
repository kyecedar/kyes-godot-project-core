@tool
extends Node

static var on_ready : Callable = (func() -> void: pass)

func _ready() -> void:
	Logger.info("this is what info looks like.",           "GAME")
	Logger.success("this is what a success looks like.",   "GAME")
	Logger.warn("this is what a warning looks like.",      "GAME")
	Logger.error("this is what an error looks like.",      "GAME")
	Logger.fatal("this is what a fatal error looks like.", "GAME")
	
	# TODO : find somewhere to put this : etch("\n[color=#478CBF][font_size=60][/font_size][/color] made with godot.")
	
	# register terminal commands.
	var command_test = Terminal.add_command("test").add_flag("--shit")
	command_test.add_command("bingus").add_flag("--bingusalso").set_execute(func(options: Dictionary):
		print(options)
		print(options.has("--bingusalso"))
	)
	
	print(Terminal.command_registry)
	
	Terminal.execute(Terminal.parse_command("test bingus --bingusalso"))
	
	Terminal._get_help()
	
	#for i in Terminal.parse_command('test 10 1.00 true TRUE fuck bingus --help "SHIT this is a string !!!!"'):
		#var bingu := ""
		#var biigiegng := get_string_type(i.type)
		#if biigiegng:
			#bingu = biigiegng
		#elif i.type == TerminalCommandOptional.TYPE_COMMAND:
			#bingu = "COMMAND"
		#else:
			#bingu = "FLAG"
#
		#print(str(typeof(i.value)) + ' ' + str(i.value))
	
	if on_ready:
		on_ready.call()

#region //  LOGGER.

static var logs : Array[String] = []

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

#region // 󱍔 UTILITY.

enum VARIANT_TYPE {
	NIL                  = Variant.Type.TYPE_NIL,
	BOOL                 = Variant.Type.TYPE_BOOL,
	INT                  = Variant.Type.TYPE_INT,
	FLOAT                = Variant.Type.TYPE_FLOAT,
	STRING               = Variant.Type.TYPE_STRING,
	VECTOR2              = Variant.Type.TYPE_VECTOR2,
	VECTOR2I             = Variant.Type.TYPE_VECTOR2I,
	RECT2                = Variant.Type.TYPE_RECT2,
	RECT2I               = Variant.Type.TYPE_RECT2I,
	VECTOR3              = Variant.Type.TYPE_VECTOR3,
	VECTOR3I             = Variant.Type.TYPE_VECTOR3I,
	TRANSFORM2D          = Variant.Type.TYPE_TRANSFORM2D,
	VECTOR4              = Variant.Type.TYPE_VECTOR4,
	VECTOR4I             = Variant.Type.TYPE_VECTOR4I,
	PLANE                = Variant.Type.TYPE_PLANE,
	QUATERNION           = Variant.Type.TYPE_QUATERNION,
	AABB                 = Variant.Type.TYPE_AABB,
	BASIS                = Variant.Type.TYPE_BASIS,
	TRANSFORM3D          = Variant.Type.TYPE_TRANSFORM3D,
	PROJECTION           = Variant.Type.TYPE_PROJECTION,
	COLOR                = Variant.Type.TYPE_COLOR,
	STRING_NAME          = Variant.Type.TYPE_STRING_NAME,
	NODE_PATH            = Variant.Type.TYPE_NODE_PATH,
	RID                  = Variant.Type.TYPE_RID,
	OBJECT               = Variant.Type.TYPE_OBJECT,
	CALLABLE             = Variant.Type.TYPE_CALLABLE,
	SIGNAL               = Variant.Type.TYPE_SIGNAL,
	DICTIONARY           = Variant.Type.TYPE_DICTIONARY,
	ARRAY                = Variant.Type.TYPE_ARRAY,
	PACKED_BYTE_ARRAY    = Variant.Type.TYPE_PACKED_BYTE_ARRAY,
	PACKED_INT32_ARRAY   = Variant.Type.TYPE_PACKED_INT32_ARRAY,
	PACKED_INT64_ARRAY   = Variant.Type.TYPE_PACKED_INT64_ARRAY,
	PACKED_FLOAT32_ARRAY = Variant.Type.TYPE_PACKED_FLOAT32_ARRAY,
	PACKED_FLOAT64_ARRAY = Variant.Type.TYPE_PACKED_FLOAT64_ARRAY,
	PACKED_STRING_ARRAY  = Variant.Type.TYPE_PACKED_STRING_ARRAY,
	PACKED_VECTOR2_ARRAY = Variant.Type.TYPE_PACKED_VECTOR2_ARRAY,
	PACKED_VECTOR3_ARRAY = Variant.Type.TYPE_PACKED_VECTOR3_ARRAY,
	PACKED_COLOR_ARRAY   = Variant.Type.TYPE_PACKED_COLOR_ARRAY,
	MAX                  = Variant.Type.TYPE_MAX,
}

## Gets corresponding type string for int.[br]
## Returns empty string if not valid.
static func get_string_type(type: int) -> String:
	if type > -1 and type < VARIANT_TYPE.MAX:
		return VARIANT_TYPE.keys()[type]
	return ''

#endregion 󱍔 UTILITY.
