class_name TerminalCommand
extends Node

## System name of Terminal system. Used in logger.
const SYSTEM : String = "COMMAND"

var description : String = "No description."

var subcommands : Dictionary = {}
var flags       : Dictionary = {} ## Like [code]"--gravity": [TYPE_FLOAT, "Description."][/code]
var ghosts      : Dictionary = {} ## Like [code]"filepath": [TYPE_STRING, "Description."][/code]

var groups : Array[TerminalCommandGroup] = []

## Function that is called when command is executed.[br]
## Flags can look like [code]--help[/code], [code]-f: false[/code], [code]-g: 9.8[/code]. Use [method Dictionary.has] to check if flag exists.[br]
## Values can look like [code]name: "John Doe"[/code], [code]iterations: 200[/code], [code]gravity: 9.8[/code], or [code]include: false[/code]. Use [method Dictionary.has] to check if value exists.
var execute : Callable = (func(options: Dictionary) -> void: Logger.info("Execution method of \"%s\" has not been registered yet." % name))

func _init(name: String, description: String = "No description.") -> void:
	if name.length() > 9:
		Logger.warn("Try to keep command names under 10 characters.", SYSTEM)
	self.name = name
	self.description = description

## Creates and returns new subcommand. [br]
## Returns null if subcommand under given name already exists.
func add_command(name: String, description: String = "No description.") -> TerminalCommand:
	if subcommands.has(name):
		Logger.error("Subcommand under \"%s\" already registered. Subcommand not created." % name, SYSTEM)
		return null
	
	subcommands[name] = TerminalCommand.new(name, description)
	return subcommands[name]

## Creates new flag if flag under given name doesn't exist.[br]
## Returns self.
func add_flag(name: String, type: int = TYPE_NIL, description: String = "No description.") -> TerminalCommand:
	# TODO : pre-register help flags.
	if name == "-h" or name == "--help":
		Logger.error("Cannot replace helper flag. Flag not created.", SYSTEM)
		return self
	
	if flags.has(name):
		Logger.error("Flag under \"%s\" already registered. Flag not created." % name, SYSTEM)
		return self
	
	flags[name] = [type, description]
	return self

## Creates new ghost value if ghost under given name doesn't exist.[br]
## Returns self.
func add_ghost(name: String, type: int, description: String = "No description.") -> TerminalCommand:
	if ghosts.has(name):
		Logger.error("Ghost under \"%s\" already registered. Ghost not created." % name, SYSTEM)
		return self
	
	ghosts[name] = [type, description]
	return self

func add_group(description: String) -> TerminalCommandGroup:
	var group = TerminalCommandGroup.new(description)
	groups.push_back(group)
	return group

## Sets the execution function of command.[br]
## Returns self.
func set_execute(callable: Callable) -> TerminalCommand:
	execute = callable
	return self
