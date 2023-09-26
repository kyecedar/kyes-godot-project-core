@tool
class_name Logger
extends Node

## Log statuses.
enum STATUS {
	INFO    = 0,
	SUCCESS = 1,
	WARNING = 2,
	ERROR   = 3,
	FATAL   = 4,
}

## Maximum amount before removing oldest lines.
const MAX_LINE_COUNT : int = 100

## Format variables. See [method Logger.formatString]
static var variables : Dictionary = {}

#region //  ETCH.

static func etch(status: STATUS, value: String) -> void:
	pass

static func etch_info(value: String) -> void:
	etch(STATUS.INFO, value)

static func etch_success(value: String) -> void:
	etch(STATUS.SUCCESS, value)

static func etch_warning(value: String) -> void:
	etch(STATUS.WARNING, value)

static func etch_error(value: String) -> void:
	etch(STATUS.ERROR, value)

static func etch_fatal(value: String) -> void:
	etch(STATUS.FATAL, value)

static func etch_verbose(value: String) -> void:
	# always use info.
	pass

static func etch_rich(value: String) -> void:
	pass

static func etch_raw(value: String) -> void:
	pass

## Get string of given status.[br]
## Used for logging to editor or file.[br]
## Returns [code]"INFO"[/code], [code]"SUCCESS"[/code], [code]"WARNING"[/code], [code]"ERROR"[/code], or [code]"FATAL"[/code].
static func _get_etch_status(status: STATUS) -> String:
	match status:
		STATUS.SUCCESS:
			return "SUCCESS"
		STATUS.WARNING:
			return "WARNING"
		STATUS.ERROR:
			return "ERROR"
		STATUS.FATAL:
			return "FATAL"
		_:
			return "INFO"

#endregion  ETCH.

#region // 󰫧 VARIABLES.

## Set format variable to be replaced in format strings.[br]
## See [method Logger.formatString].
static func setVariable(key: String, value: String) -> void:
	variables[key] = value

## Formats [code]{{}}[/code] variables to replace their values.[br]
## Use [method Logger.setVariable] to set variables to be replaced within text.[br][br]
## Use [code]"{--}"[/code] within a variable to not convert it.[br]
## Example : [code]"Terminal v{{TERM{--}INAL_VERSION}}"[/code]
static func formatString(text: String) -> String:
	var formatted = text
	
	for key in Logger.variables.keys():
		formatted = formatted.replace("{{%s}}" % key, variables[key])
	
	formatted = formatted.replace("{--}", "")
	
	return formatted

#endregion 󰫧 VARIABLES.
