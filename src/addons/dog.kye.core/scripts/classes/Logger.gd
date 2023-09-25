@tool
class_name Logger
extends Node

# constants.
enum STATUS {
	INFO    = 0,
	SUCCESS = 1,
	WARNING = 2,
	ERROR   = 3,
	FATAL   = 4,
}

const MAX_LINE_COUNT : int = 100

static func etch(status: STATUS, value: String) -> void:
	pass

static func etch_verbose(status: STATUS, value: String) -> void:
	pass

static func etch_rich(value: String) -> void:
	pass

static func etch_raw(value: String) -> void:
	pass
