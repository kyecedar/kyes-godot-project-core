@tool
class_name Terminal
extends Control

## Registry of all commands.[br]
## See TODO : make command registry functions.
static var command_registry : Dictionary = {}

static var INFO_CHAR    = '' ## Character to be displayed next to an informational log.
static var SUCCESS_CHAR = '' ## Character to be displayed next to a successful log.
static var WARNING_CHAR = '' ## Character to be displayed next to a warning log.
static var ERROR_CHAR   = '' ## Character to be displayed next to an error log.
static var FATAL_CHAR   = '󰚌' ## Character to be displayed next to a fatal log.

## A queue of logs yet to be put on the terminal.
static var log_queue : Array[Array] = []

## Etches logs that were not added to the terminal yet.
static func _handle_missed_logs() -> void:
	while log_queue.size():
		var log = log_queue.pop_front()
		etch(log[0], log[1], log[2])

## Etches with newline to terminal node if [member game.terminal] exists.[br]
## Formats text with [method Logger.format_string][br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch(status: Logger.STATUS, text: String, system: String = '') -> void:
	if not game.terminal:
		log_queue.push_back([status, text, system])
		return
	
	var text_status = Logger._get_etch_status(status)
	
	if not status == Logger.STATUS.INFO:
		return game.terminal.etch("\n[color=%s][lb]%s%s[rb] %s[/color]" % [
			Debugger[text_status + "_COLOR"],
			(system + ' ' if system else ''),
			Terminal[text_status + "_CHAR"],
			
			Logger.format_string(text)
		])
	
	game.terminal.etch('\n' + ("[lb]" + system + "[rb] " if system else '') + Logger.format_string(text))

## Etches without newline to terminal node if [member game.terminal] exists.[br]
## Formats text with [method Logger.format_string][br][br]
## [url=https://docs.godotengine.org/en/stable/tutorials/ui/bbcode_in_richtextlabel.html#reference]BBCode Reference[/url]
static func etch_raw(text: String) -> void:
	if not game.terminal:
		return
	
	game.terminal.etch(Logger.format_string(text))
