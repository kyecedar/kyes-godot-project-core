@tool
extends Control

@onready var history : RichTextLabel
@onready var input   : TextEdit
@onready var ghost   : TextEdit

@onready var edge_t  : Panel = $edge_t
@onready var edge_r  : Panel = $edge_r
@onready var edge_b  : Panel = $edge_b
@onready var edge_l  : Panel = $edge_l
@onready var edge_tl : Panel = $edge_tl
@onready var edge_tr : Panel = $edge_tr
@onready var edge_br : Panel = $edge_br
@onready var edge_bl : Panel = $edge_bl

@export var minimum_size := Vector2.ZERO : set = _set_minimum_size
@export_range(0, 10) var edge_size   : int = 4 : set = _set_edge_size
@export_range(0, 10) var corner_size : int = 6 : set = _set_corner_size

var parent_control_node : Control

func _ready() -> void:
	parent_control_node = get_parent_control()
	
	# invoking setters.
	edge_size = edge_size
	corner_size = corner_size
	
	_handle_hovering_for_edge(edge_t)
	_handle_hovering_for_edge(edge_r)
	_handle_hovering_for_edge(edge_b)
	_handle_hovering_for_edge(edge_l)
	_handle_hovering_for_edge(edge_tl)
	_handle_hovering_for_edge(edge_tr)
	_handle_hovering_for_edge(edge_br)
	_handle_hovering_for_edge(edge_bl)

#region // 󰁌 RESIZE.

var hovering_edge : Panel ## panel the user is hovering over.
var resizing := false ## if terminal is resizing.

## constrains terminal to fit within screen.
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

## connect signals to given panel. when hovered, it is stored in "hover_edge".
func _handle_hovering_for_edge(edge: Panel) -> void:
	edge.mouse_entered.connect(func(): hovering_edge = edge)
	edge.mouse_exited.connect(func(): hovering_edge = null)

#endregion 󰁌 RESIZE.

#region // GETTERS.

## get size of parent. if no parent control node, then use window size.
func _get_parent_size() -> Vector2i:
	return parent_control_node.size if parent_control_node else DisplayServer.window_get_size()

#endregion GETTERS.

#region // SETTERS.

## clamps and rounds vector between 0 and 1000.
func _set_minimum_size(value: Vector2) -> void:
	minimum_size.x = round(clamp(value.x, 0, 1000))
	minimum_size.y = round(clamp(value.y, 0, 1000))

## sets size of draggable edges.
func _set_edge_size(value: int) -> void:
	edge_size = value
	edge_t.custom_minimum_size.y = value
	edge_r.custom_minimum_size.x = value
	edge_b.custom_minimum_size.y = value
	edge_l.custom_minimum_size.x = value

## sets the size of draggable corners.
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
