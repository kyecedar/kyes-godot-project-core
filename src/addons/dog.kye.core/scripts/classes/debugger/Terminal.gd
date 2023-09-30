@tool
class_name Terminal
extends Control

## System name of Terminal system. Used in logger.
const SYSTEM : String = "TERMINAL"

## Registry of all commands.[br]
## See TODO : make command registry functions.
static var command_registry : Dictionary = {}

#region //  COMMANDS.

static func execute(base_command: String, parsed_optionals: Array[TerminalCommandOptional]) -> void:
	if not command_registry.has(base_command):
		return _invalid_command(base_command)
	
	var subcommand : TerminalCommand = command_registry[base_command]
	var optional : TerminalCommandOptional
	var is_base       : bool = true
	var is_subcommand : bool = false
	var is_help_flag  : bool = false
	var is_flag       : bool = false
	var is_ghost      : bool = false
	
	var options : Dictionary = {}
	
	while parsed_optionals.size():
		optional = parsed_optionals.pop_front()
		
		is_subcommand = subcommand.subcommands.has(optional.name)
		is_flag       = subcommand.flags.has(optional.name)
		is_ghost      = subcommand.ghosts.has(optional.name)
		
		if is_subcommand and is_ghost:
			is_subcommand = false if optional.value else true
			is_ghost = not is_subcommand
		
		if is_ghost:
			# check if valid type.
			if not typeof(optional.value) == subcommand.ghosts[optional.name]:
				return _invalid_value_type(
					optional.name,
					typeof(optional.value),
					subcommand.ghosts[optional.name]
				)
			
			options[optional.name] = optional.value
			
		elif is_flag:
			# check if valid type.
			if not typeof(optional.value) == subcommand.flags[optional.name]:
				return _invalid_value_type(
					optional.name,
					typeof(optional.value),
					subcommand.flags[optional.name]
				)
			
			options[optional.name] = optional.value
			
		elif is_subcommand:
			subcommand = subcommand.subcommands[optional.name]
			is_base = false
		
		else:
			return _invalid_subcommand(base_command, optional.name)
	
	if not subcommand.has_method("execute"):
		if subcommand.execute is Callable:
			subcommand.execute.call_deferred(options)
	else:
		_no_execution_method(base_command, subcommand.name if not is_base else '')

static func _invalid_command(command_name: String) -> void:
	return Logger.error("Invalid command \"%s\"." % command_name, SYSTEM)

static func _invalid_subcommand(base_command: String, sub_command: String) -> void:
	return Logger.error("Invalid subcommand \"%s\" of \"%s\"." % [sub_command, base_command], SYSTEM)

static func _invalid_value_type(optional_name: String, optional_expected_type: int, optional_recieved_type: int) -> void:
	return Logger.error("Invalid value of %s. Expected type of %s, instead got type of %s." % [
		optional_name,
		game.get_string_type(optional_expected_type),
		game.get_string_type(optional_recieved_type),
	], SYSTEM)

static func _no_execution_method(base_command: String, sub_command: String = '') -> void:
	if not sub_command:
		return Logger.error("Command \"%s\" in registry, but no execution method provided." % base_command, SYSTEM)
	
	return Logger.error("Subcommand \"%s\" of \"%s\" in registry, but no execution method provided." % [sub_command, base_command], SYSTEM)

## Creates and adds command to registry if command under given name doesn't exist.[br]
## Returns null if command already exists.
static func add_command(name: String) -> TerminalCommand:
	# command already exists, return null.
	if command_registry.has(name):
		Logger.error("Command under \"%s\" already registered. Command not created." % name, SYSTEM)
		return null
	
	# create and return command.
	command_registry[name] = TerminalCommand.new(name)
	return command_registry[name]

#endregion  COMMANDS.

#region //  LOGGING.

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

#endregion  LOGGING.
