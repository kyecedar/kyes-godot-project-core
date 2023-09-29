@tool
class_name Debugger
extends Control

#region // 󰉦 COLORS.

# be wary of bbcode injection. dunno why or where that'd be a problem, but yeah.
static var LIGHT_TEXT_COLOR  : String = "#FFFFFF" ## BBCode text color.
static var RED_TEXT_COLOR    : String = "#FF5F5F" ## BBCode text color.
static var YELLOW_TEXT_COLOR : String = "#FFDE66" ## BBCode text color.
static var GREEN_TEXT_COLOR  : String = "#FFDE66" ## BBCode text color.
static var BLUE_TEXT_COLOR   : String = "#328FF3" ## BBCode text color.

static var INFO_COLOR    : String = LIGHT_TEXT_COLOR  ## BBCode text color for info log colors.
static var SUCCESS_COLOR : String = BLUE_TEXT_COLOR   ## BBCode text color for success log colors.
static var WARNING_COLOR : String = YELLOW_TEXT_COLOR ## BBCode text color for warning log colors.
static var ERROR_COLOR   : String = RED_TEXT_COLOR    ## BBCode text color for error log colors.
static var FATAL_COLOR   : String = RED_TEXT_COLOR    ## BBCode text color for fatal log colors.

static var MEMBER_NAME_COLOR : String = LIGHT_TEXT_COLOR + "88"  ## BBCode text color for member names.
static var NULL_COLOR        : String = RED_TEXT_COLOR           ## BBCode text color for null values.
static var VECTOR_X_COLOR    : String = RED_TEXT_COLOR           ## BBCode text color for vector x values.
static var VECTOR_Y_COLOR    : String = GREEN_TEXT_COLOR         ## BBCode text color for vector y values.
static var VECTOR_Z_COLOR    : String = BLUE_TEXT_COLOR          ## BBCode text color for vector z values.
static var TIMER_EMPTY_COLOR : String = LIGHT_TEXT_COLOR         ## BBCode text color for timer values when empty.
static var TIMER_WAIT_COLOR  : String = YELLOW_TEXT_COLOR + "88" ## BBCode text color for timer values while waiting.
static var TIMER_FULL_COLOR  : String = BLUE_TEXT_COLOR          ## BBCode text color for timer values while full/executing.

#endregion 󰉦 COLORS.

## Only allow the debugger to be accessed in project's debug mode.
@export var only_allow_in_debug : bool = true

func _ready() -> void:
	if only_allow_in_debug and not OS.is_debug_build() and not Engine.is_editor_hint():
		queue_free()

#region //  BLURBS.

static var bunches : Dictionary = {}

# TODO : only update bunch if blurbs is visible.
# self, "member name"

static func createBunch(name: String) -> Bunch:
	return Bunch.new(name)

#endregion  BLURBS.
