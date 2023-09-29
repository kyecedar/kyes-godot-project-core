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

## If verbose logs should be shown. See [method Logger.etch_verbose]
static var verbose : bool = false

## Format variables. See [method Logger.formatString]
static var variables : Dictionary = {}
static var logs : Array = []

#region //  ETCH.

# TODO : log to file.

static func etch(status: STATUS, text: String, system: String = '') -> void:
	Terminal.etch(status, text, system)
	print_rich("%s %s" % [
		_get_etch_color_status(status, system),
		Logger.format_string(text),
	])

static func info(text: String, system: String = '') -> void:
	etch(STATUS.INFO, text, system)

static func success(text: String, system: String = '') -> void:
	etch(STATUS.SUCCESS, text, system)

static func warn(text: String, system: String = '') -> void:
	etch(STATUS.WARNING, text, system)

static func error(text: String, system: String = '') -> void:
	etch(STATUS.ERROR, text, system)

static func fatal(text: String, system: String = '') -> void:
	etch(STATUS.FATAL, text, system)

## Etches to terminal if [member Logger.verbose] is enabled.[br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_verbose(text: String) -> void:
	if verbose:
		etch(STATUS.INFO, '\n' + text)

## Etches to terminal with newline.[br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_rich(text: String) -> void:
	Terminal.etch_raw('\n' + text)
	print_rich(text)

## Etches to terminal without newline.[br]
## Uses newline on terminal.[br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_raw(text: String) -> void:
	Terminal.etch_raw(text)
	print_rich(text)

static func _get_etch_color_status(status: STATUS, system: String = '') -> String:
	return "[color=" + (Debugger[_get_etch_status(status) + "_COLOR"]) + ']' + (system + ' ' if system else '') + _get_etch_status(status) + "[/color]"

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
static func set_variable(key: String, value: String) -> void:
	variables[key] = value

## Formats [code]{{}}[/code] variables to replace their values.[br]
## Use [method Logger.setVariable] to set variables to be replaced within text.[br][br]
## Use [code]"{--}"[/code] within a variable to not convert it.[br]
## Example : [code]"Terminal v{{TERM{--}INAL_VERSION}}"[/code]
static func format_string(text: String) -> String:
	var formatted = text
	
	for key in Logger.variables.keys():
		formatted = formatted.replace("{{%s}}" % key, variables[key])
	
	formatted = formatted.replace("{--}", "")
	
	return formatted

#endregion 󰫧 VARIABLES.
