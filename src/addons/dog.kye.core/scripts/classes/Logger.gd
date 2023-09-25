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

## Get string of given status.
## Returns "INFO", "SUCCESS", "WARNING", "ERROR", or "FATAL".
static func get_etch_status(status: STATUS) -> String:
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
