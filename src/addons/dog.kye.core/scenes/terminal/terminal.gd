@tool
class_name TerminalNode
extends Control

@onready var history : RichTextLabel = $content/vbox/scroll/container/history
@onready var caret   : Label    = $content/vbox/scroll/container/input/caret_container/caret
@onready var input   : TextEdit = $content/vbox/scroll/container/input/lines/main
@onready var ghost   : TextEdit = $content/vbox/scroll/container/input/lines/ghost
@onready var input_container : HBoxContainer = $content/vbox/scroll/container/input

@onready var edge_t  : Panel = $edge_t
@onready var edge_r  : Panel = $edge_r
@onready var edge_b  : Panel = $edge_b
@onready var edge_l  : Panel = $edge_l
@onready var edge_tl : Panel = $edge_tl
@onready var edge_tr : Panel = $edge_tr
@onready var edge_br : Panel = $edge_br
@onready var edge_bl : Panel = $edge_bl

@export var boot_text_enabled : bool = true ## If boot text should be shown when terminal is ready.
@export_multiline var boot_text : String = "[color=#ffffff88]running v{{TERMINAL_VERSION}} of terminal.\nchange this text in the inspector.\n\n\"help\" for help.[/color]"
@export var minimum_size := Vector2.ZERO : set = _set_minimum_size ## Minimum size of window.
@export_range(0, 10) var edge_size   : int = 4 : set = _set_edge_size ## Size of draggable edges.
@export_range(0, 10) var corner_size : int = 6 : set = _set_corner_size ## Size of draggable corners.

var parent_control_node : Control ## Parent. Used to constrain terminal inside.
var character_width  : int ## Width of a single character.[br]Obtained by getting width of caret.
var character_height : int ## Height of a single character.[br]Obtained by getting height of caret.

# TODO : remember to keep zero width spaces in ghost line.

func _ready() -> void:
	parent_control_node = get_parent_control()
	character_width  = caret.size.x / caret.text.length()
	character_height = caret.size.y
	
	Logger.setVariable("TERMINAL_VERSION", "0.5")
	
	# invoking setters.
	minimum_size = minimum_size
	edge_size = edge_size
	corner_size = corner_size
	
	input.text_changed.connect(_on_input_change)
	
	_handle_hovering_for_edge(edge_t)
	_handle_hovering_for_edge(edge_r)
	_handle_hovering_for_edge(edge_b)
	_handle_hovering_for_edge(edge_l)
	_handle_hovering_for_edge(edge_tl)
	_handle_hovering_for_edge(edge_tr)
	_handle_hovering_for_edge(edge_br)
	_handle_hovering_for_edge(edge_bl)
	
	if boot_text_enabled:
		history.parse_bbcode(Logger.formatString(boot_text))
	
	game.set_current_terminal(self)

func _input(event: InputEvent) -> void:
	if input.has_focus():
		pass

#region //  INPUT.

func _on_input_change() -> void:
	input_container.custom_minimum_size.y = input.size.y + character_height * 2
	input_container.size.y = input_container.custom_minimum_size.y

#endregion  INPUT.

#region //  ETCH.

func etch(text: String) -> void:
	history.append_text(text)

#endregion  ETCH.

#region // 󰁌 RESIZE.

var hovering_edge : Panel ## Panel the user is hovering over.
var resizing := false ## If terminal is resizing.

## Constrains terminal to fit within screen.
func _constrain() -> void:
	# keep minimum size.
	size.x = max(size.x, minimum_size.x)
	size.y = max(size.y, minimum_size.y)
	
	# keep within screen size.
	size.x = min(size.x, _get_parent_size().x)
	size.y = min(size.y, _get_parent_size().y)
	
	# keep within screen bounds.
	position.x = max(position.x, 0)
	position.y = max(position.y, 0)
	position.x = min(position.x - size.x, _get_parent_size().x - size.x)
	position.y = min(position.y - size.y, _get_parent_size().y - size.y)

## Connect signals to given panel.[br]
## When hovered, it is stored in [member TerminalNode.hovering_edge].
func _handle_hovering_for_edge(edge: Panel) -> void:
	edge.mouse_entered.connect(func(): hovering_edge = edge)
	edge.mouse_exited.connect(func(): hovering_edge = null)

#endregion 󰁌 RESIZE.

#region // GETTERS.

## Get size of parent. If no parent control node, then use window size.
func _get_parent_size() -> Vector2i:
	return parent_control_node.size if parent_control_node else DisplayServer.window_get_size()

#endregion GETTERS.

#region // SETTERS.

## Clamps and rounds vector between 0 and 1000.
func _set_minimum_size(value: Vector2) -> void:
	minimum_size.x = round(clamp(value.x, 0, 1000))
	minimum_size.y = round(clamp(value.y, 0, 1000))

## Sets size of draggable edges.
func _set_edge_size(value: int) -> void:
	edge_size = value
	edge_t.custom_minimum_size.y = value
	edge_r.custom_minimum_size.x = value
	edge_b.custom_minimum_size.y = value
	edge_l.custom_minimum_size.x = value

## Sets size of draggable corners.
func _set_corner_size(value: int) -> void:
	corner_size = value
	edge_tl.custom_minimum_size.x = value
	edge_tl.custom_minimum_size.y = value
	edge_tr.custom_minimum_size.x = value
	edge_tr.custom_minimum_size.y = value
	edge_br.custom_minimum_size.x = value
	edge_br.custom_minimum_size.y = value
	edge_bl.custom_minimum_size.x = value
	edge_bl.custom_minimum_size.y = value

#endregion SETTERS.
