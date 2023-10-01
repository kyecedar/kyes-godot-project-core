@tool
class_name Terminal
extends Control

## System name of Terminal system. Used in logger.
const SYSTEM : String = "TERMINAL"

## Registry of all commands.[br]
## See TODO : make command registry functions.
static var command_registry : Dictionary = {}

static var regex_command    : RegEx = RegEx.new()
static var regex_string     : RegEx = RegEx.new()
static var regex_flag       : RegEx = RegEx.new()
static var regex_number     : RegEx = RegEx.new()
static var regex_int        : RegEx = RegEx.new()
static var regex_bool       : RegEx = RegEx.new()
static var regex_true       : RegEx = RegEx.new()
static var regex_whitespace : RegEx = RegEx.new()

#region //  COMMANDS.

## Returns array that looks like[br]
## [ [[member TerminalCommandOptional.TYPE_COMMAND], "set"], [[member TerminalCommandOptional.TYPE_COMMAND], "playername"], [TYPE_STRING, "Billy"] ]
static func parse_command(text: String) -> Array[Array]:
	_register_regex()
	
	var strings = regex_string.search_all(text)
	
	var split_text : PackedStringArray = text.split(" ")
	var parsed     : Array[Variant] = []
	var command    : Array[TerminalCommandParsed] = []
	
	# loop through all the string positions.
	# "command "string" subcommand -flag "string"
	if strings:
		var last_index : int = strings.size() - 1
		var last_position : int = 0
		var string_match: RegExMatch
		for i in strings.size():
			string_match = strings[i]
			
			# command --flag "string" 0.0 "another string" bingus "bongus"
			
			# i == 1 : [ "command --flag ", [TYPE_STRING, "string"] ]
			# i == 2 : [ " 0.0 ", [TYPE_STRING, "another string"] ]
			# i == 3 : [ " bingus ", [TYPE_STRING, "bongus"], "" ]
			
			parsed.push_back(text.substr(last_position, string_match.get_start() - last_position)) # get from last position to before string starts.
			parsed.push_back(TerminalCommandParsed.new(TYPE_STRING, string_match.get_string().substr(1, string_match.get_string().length() - 2))) # get text inside quotations.
			
			last_position = string_match.get_end()
			
			if i == last_index:
				if text.substr(string_match.get_end()):
					parsed.push_back(text.substr(string_match.get_end())) # get remaining text, from end of match to end of text.
	else:
		parsed = [text]
	
	var n : Variant
	
	# loop and store it all in "command".
	while parsed.size():
		n = parsed.pop_front()
		
		# if already parsed out, send it to the gay zone.
		if not n is String:
			command.push_back(n)
			continue
		
		split_text = n.split(' ', false)
		
		for s in split_text:
			if regex_command.search(s):
				command.push_back([])
	
	return command

static func _register_regex() -> void:
	regex_command.compile('^[A-Za-z]+$')
	regex_string.compile('(?<!\\\\)"([\\S\\s]*?)(?<!\\\\)"')
	regex_flag.compile('^--?[A-Za-z]+$')
	regex_number.compile('^\\d+(\\.\\d*)?$')
	regex_int.compile('^\\d+(?!(.\\d*))')
	regex_bool.compile('^((true|false)|((enable|disable)d?))$')
	regex_true.compile('^(true|enabled?)$')
	regex_whitespace.compile('[^\\s​⠀]')

static func execute(base_command: String, parsed_optionals: Array[TerminalCommandOptional]) -> void:
	if not command_registry.has(base_command):
		return _invalid_command(PackedStringArray([base_command]))
	
	var command_path  : PackedStringArray = [base_command]
	var subcommand    : TerminalCommand = command_registry[base_command]
	var optional      : TerminalCommandOptional
	var is_base       : bool = true
	var is_subcommand : bool = false
	var is_help_flag  : bool = false
	var is_flag       : bool = false
	var is_ghost      : bool = false
	
	var options : Dictionary = {}
	
	while parsed_optionals.size():
		optional = parsed_optionals.pop_front()
		
		is_subcommand = subcommand.subcommands.has(optional.name)
		is_help_flag  = optional.name == "-h" or optional.name == "--help"
		is_flag       = subcommand.flags.has(optional.name)
		is_ghost      = subcommand.ghosts.has(optional.name)
		
		if is_subcommand and is_ghost:
			is_subcommand = false if optional.value else true
			is_ghost = not is_subcommand
		
		if is_help_flag:
			return _get_help(subcommand)
			
		if is_subcommand:
			subcommand = subcommand.subcommands[optional.name]
			command_path.append(optional.name)
		
		elif is_flag:
			# check if valid type.
			if not typeof(optional.value) == subcommand.flags[optional.name]:
				return _invalid_value_type(
					command_path,
					optional.name,
					typeof(optional.value),
					subcommand.flags[optional.name]
				)
			
			options[optional.name] = optional.value
			
		elif is_ghost:
			# check if valid type.
			if not typeof(optional.value) == subcommand.ghosts[optional.name]:
				return _invalid_value_type(
					command_path,
					optional.name,
					typeof(optional.value),
					subcommand.ghosts[optional.name]
				)
			
			options[optional.name] = optional.value
		
		else:
			return _invalid_command(command_path)
	
	if not subcommand.has_method("execute"):
		if subcommand.execute is Callable:
			subcommand.execute.call_deferred(options)
	else:
		_no_execution_method(command_path)

static func _get_help(command: TerminalCommand = null) -> void:
	if not command:
		# TODO : print all commands and their descriptions.
		#      loop through command_registry keys.
		#      get descriptions and print them side-by-side.
		
		var first : bool = true
		
		# recurse through all commands in registry if no specific command given.
		for c: TerminalCommand in command_registry:
			if not first:
				Terminal.etch_raw('\n')
			first = false
			_get_help(c)
	
	var first_comma : bool
	
	# print name.
	Terminal.etch_raw("\n[color=%s]%s[/color]" % [ Debugger.INFO_COLOR, command.name ])
	
	# print subcommands
	if command.subcommands:
		first_comma = true
		Terminal.etch_raw(" [color=%s]" % Debugger.MEMBER_NAME_COLOR)
		for subcommand in command.subcommands:
			if not first_comma:
				Terminal.etch_raw(", ")
			first_comma = false
			Terminal.etch_raw(subcommand.name)
		Terminal.etch_raw("[/color]")
	
	
	
	# print flags
	# print ghosts
	# print description
	# TODO : get help for command.
	#      loop through command's flags and ghosts first, then go to subcommands.
	pass

static func _invalid_command(command_path: PackedStringArray) -> void:
	return Logger.error("Invalid command \"%s\"." % ' '.join(command_path), SYSTEM)

static func _invalid_value_type(command_path: PackedStringArray, optional_name: String, optional_expected_type: int, optional_recieved_type: int) -> void:
	return Logger.error("Invalid value of %s in command \"%s\". Expected type of %s, instead got type of %s." % [
		optional_name,
		' '.join(command_path),
		game.get_string_type(optional_expected_type),
		game.get_string_type(optional_recieved_type),
	], SYSTEM)

static func _no_execution_method(command_path: PackedStringArray) -> void:
	return Logger.error("Command \"%s\" in registry, but no execution method provided." % ' '.join(command_path), SYSTEM)

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
		if typeof(log) == TYPE_ARRAY:
			etch(log[0], log[1], log[2])
			continue
		etch_raw(log)

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
		log_queue.push_back(text)
		return
	
	game.terminal.etch(Logger.format_string(text))

#endregion  LOGGING.
