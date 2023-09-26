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

#region //  ETCH.

# TODO : log to file.

static func etch(status: STATUS, text: String) -> void:
	Terminal.etch(status, text)
	print_rich("[code]%s[/code] %s" % [_get_etch_status(status), formatString(text)])

static func etch_info(text: String) -> void:
	etch(STATUS.INFO, text)

static func etch_success(text: String) -> void:
	etch(STATUS.SUCCESS, text)

static func etch_warning(text: String) -> void:
	etch(STATUS.WARNING, text)

static func etch_error(text: String) -> void:
	etch(STATUS.ERROR, text)

static func etch_fatal(text: String) -> void:
	etch(STATUS.FATAL, text)

## Etches to terminal if [member Logger.verbose] is enabled.[br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_verbose(text: String) -> void:
	if verbose:
		etch(STATUS.INFO, text + '\n')

## Etches to terminal with newline.[br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_rich(text: String) -> void:
	Terminal.etch_raw(text + '\n')
	print_rich(text)

## Etches to terminal without newline.[br]
## Uses newline on terminal.[br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_raw(text: String) -> void:
	Terminal.etch_raw(text)
	print_rich(text)

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
