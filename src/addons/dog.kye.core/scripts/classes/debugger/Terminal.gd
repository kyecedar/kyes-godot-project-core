@tool
class_name Terminal
extends Control

## Registry of all commands.[br]
## See TODO : make command registry functions.
static var command_registry : Dictionary = {}

static var INFO_CHAR    = '' ## Character to be displayed next to an informational log.
static var SUCCESS_CHAR = '' ## Character to be displayed next to a successful log.
static var WARNING_CHAR = '' ## Character to be displayed next to a warning log.
static var ERROR_CHAR   = '' ## Character to be displayed next to an error log.
static var FATAL_CHAR   = '' ## Character to be displayed next to a fatal log.

## Etches with newline to terminal node if [member game.terminal] exists.[br]
## Formats text with [method Logger.formatString][br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch(status: Logger.STATUS, text: String) -> void:
	if not game.terminal:
		return
	
	match status:
		Logger.STATUS.SUCCESS:
			pass
		Logger.STATUS.WARNING:
			pass
		Logger.STATUS.ERROR:
			pass
		Logger.STATUS.FATAL:
			pass
		_:
			pass
	
	game.terminal.etch(Logger.formatString(text) + '\n')

## Etches without newline to terminal node if [member game.terminal] exists.[br]
## Formats text with [method Logger.formatString][br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_raw(text: String) -> void:
	if not game.terminal:
		return
	
	game.terminal.etch(Logger.formatString(text))
