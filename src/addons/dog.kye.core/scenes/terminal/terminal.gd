@tool
class_name TerminalNode
extends Control

@onready var titlebar : Label = $content/vbox/titlebar/text_region/title
@onready var titlebar_drag : Panel = $content/vbox/titlebar/text_region/drag

@onready var history : RichTextLabel = $content/vbox/scroll/container/history
@onready var caret   : Label    = $content/vbox/scroll/container/input/caret_container/caret
@onready var input   : TextEdit = $content/vbox/scroll/container/input/lines/main
@onready var ghost   : TextEdit = $content/vbox/scroll/container/input/lines/ghost
@onready var caret_container : Control       = $content/vbox/scroll/container/input/caret_container
@onready var input_container : HBoxContainer = $content/vbox/scroll/container/input

@onready var edge_t  : Panel = $edge_t
@onready var edge_r  : Panel = $edge_r
@onready var edge_b  : Panel = $edge_b
@onready var edge_l  : Panel = $edge_l
@onready var edge_tl : Panel = $edge_tl
@onready var edge_tr : Panel = $edge_tr
@onready var edge_br : Panel = $edge_br
@onready var edge_bl : Panel = $edge_bl

@export var title : String = "TERMINAL" : set = _set_title ## Text to be put in the titlebar.
@export_range(6, 48) var font_size : int = 10 : set = _set_font_size ## Font size of history and input.[br]Does not apply to titlebar.
@export var drag_and_resize : bool = true : set = _set_drag_and_resize ## If false, hide edges.
@export var minimum_size := Vector2i(250, 250) : set = _set_minimum_size ## Minimum size of window.
@export_range(0, 10) var edge_size   : int = 4 : set = _set_edge_size ## Size of draggable edges.
@export_range(0, 10) var corner_size : int = 6 : set = _set_corner_size ## Size of draggable corners.
@export var boot_text_enabled : bool = true ## If boot text should be shown when terminal is ready.
@export_multiline var boot_text : String = "[color=#ffffff88]running v{{TERMINAL_VERSION}} of terminal.\nchange this text in the inspector.\n\n\"help\" for help.[/color]"
@export var log_input_on_submit : bool = true ## If the command should be printed and logged when submitting.

var command_history     : PackedStringArray = []
var command_index       : int = -1 ## Points to a command in the command history.[br]Changes when user navigates through command history with arrow keys.
var command_temp        : String = "" ## When user navigates from the command they're typing, store it here and recover it when index reaches -1 again.
var parent_control_node : Control ## Parent. Used to constrain terminal inside.
var character_width     : int ## Width of a single character.[br]Obtained by getting width of caret.
var character_height    : int ## Height of a single character.[br]Obtained by getting height of caret.

# TODO : remember to keep zero width spaces in ghost line.

func _ready() -> void:
	parent_control_node = get_parent_control()
	
	Logger.set_variable("TERMINAL_VERSION", "0.8")
	
	# invoking setters.
	title = title
	font_size = font_size
	drag_and_resize = drag_and_resize
	minimum_size = minimum_size
	edge_size = edge_size
	corner_size = corner_size
	
	input.text_changed.connect(_on_input_change)
	get_viewport().size_changed.connect(_on_viewport_resize)
	get_tree().get_root().connect("size_changed", _on_viewport_resize)
	
	titlebar_drag.mouse_entered.connect(func(): if not dragging: hovering_titlebar = true)
	titlebar_drag.mouse_exited.connect(func(): if not dragging: hovering_titlebar = false)
	
	_handle_hovering_for_edge(edge_t)
	_handle_hovering_for_edge(edge_r)
	_handle_hovering_for_edge(edge_b)
	_handle_hovering_for_edge(edge_l)
	_handle_hovering_for_edge(edge_tl)
	_handle_hovering_for_edge(edge_tr)
	_handle_hovering_for_edge(edge_br)
	_handle_hovering_for_edge(edge_bl)
	
	if boot_text_enabled:
		history.parse_bbcode(Logger.format_string(boot_text))
	
	game.set_current_terminal(self)

func _input(event: InputEvent) -> void:
	if input.has_focus():
		if event is InputEventKey:
			if (Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER)):
				# https://www.reddit.com/r/godot/comments/xn2tmg/comment/j1dyaeg
				if not Input.is_key_pressed(KEY_SHIFT):
					get_viewport().set_input_as_handled()
					submit_input()
				else:
					input.insert_text_at_caret('\n')
			elif Input.is_key_pressed(KEY_UP):
				if not command_history:
					return
				
				# test if caret is at top of input.
				if not input.get_caret_line(0):
					# TODO : increment through command history.
					if command_index == -1:
						command_temp = input.text
					
					command_index = min(len(command_history) - 1, command_index + 1)
					print(command_index)
					input.text = command_history[command_index]
				pass
			elif Input.is_key_pressed(KEY_DOWN):
				print(input.get_caret_line(0) == input.get_line_count() - 1)
				if not command_history:
					return
				
				if input.get_caret_line(0) == input.get_line_count() - 1:
					command_index = max(command_index - 1, -1)
					
					if command_index > -1:
						input.text = command_history[command_index]
					else:
						input.text = command_temp
				# TODO : test if caret is at bottom of input.
				pass
	
	if not drag_and_resize:
		return
	
	if event is InputEventMouseMotion:
		if dragging:
			_handle_drag(event)
		elif resizing:
			_handle_edge_drag(event)
	
	elif event is InputEventMouseButton:
		if hovering_edge:
			if not resizing:
				resize_position = position
				resize_size = size
			resizing = event.button_index == MOUSE_BUTTON_LEFT and event.pressed
			if not resizing:
				hovering_edge = null
		
		elif hovering_titlebar or (event.button_index == MOUSE_BUTTON_MIDDLE and mouse_over()):
			if not dragging:
				resize_position = position - event.position
			dragging = (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_MIDDLE) and event.pressed

#region //  FONT.

func set_font_size(size: int) -> void:
	if not history:
		return
	
	# history.
	history.add_theme_font_size_override("normal_font_size"       , size)
	history.add_theme_font_size_override("bold_font_size"         , size)
	history.add_theme_font_size_override("italics_font_size"      , size)
	history.add_theme_font_size_override("bold_italics_font_size" , size)
	history.add_theme_font_size_override("mono_font_size"         , size)
	
	# input.
	input.add_theme_font_size_override("font_size", size)
	ghost.add_theme_font_size_override("font_size", size)
	
	# caret.
	caret.add_theme_font_size_override("font_size", size)
	_update_caret_sizing.call_deferred() # call at end of frame.

#endregion  FONT.

#region //  INPUT.

## Submits and clears input. Adds input text to history.
func submit_input() -> void:
	# log and print command.
	if log_input_on_submit:
		var split_input : PackedStringArray = input.text.split('\n')
		var display_input : String = caret.text
		
		if split_input.size() == 0:
			return
		
		display_input += split_input[0]
		split_input.remove_at(0)
		
		for line in split_input:
			display_input += '\n' + ' '.repeat(caret.text.length()) + line
		
		history.add_text('\n' + display_input)
		print(display_input)
	
	# TODO : send command to be parsed.
	if input.text:
		command_history.append(input.text)
		Terminal.execute(Terminal.parse_command(input.text))
		
		input.text = ""

func _on_input_change() -> void:
	pass

## Updates minimum sizes for caret.
func _update_caret_sizing() -> void:
	caret_container.custom_minimum_size.x = caret.size.x
	input_container.custom_minimum_size.y = input.size.y + caret.size.y * 2
	input_container.size.y = input_container.custom_minimum_size.y

#endregion  INPUT.

#region //  ETCH.

func etch(text: String) -> void:
	history.append_text(text)

#endregion  ETCH.

#region // 󰁌 RESIZE & DRAG.

var hovering_titlebar : bool = false ## If user is hovering over titlebar.
var hovering_edge     : Panel ## Panel the user is hovering over.
var resizing          : bool = false ## If terminal is being resized.
var dragging          : bool = false ## If terminal is being dragged.
var resize_position   : Vector2i = Vector2i.ZERO ## When resizing, use this as reference for what position will be.[br]Also used for dragging offset and temp window size in [method _constrain].
var resize_size       : Vector2i = Vector2i.ZERO ## When resizing, use this as reference for what size will be.[br]Also used for temp parent size in [method _constrain].

func mouse_over() -> bool:
	return Rect2(Vector2(), size).has_point(get_local_mouse_position())

## Constrains terminal to fit within screen.
func _constrain() -> void:
	resize_position = DisplayServer.window_get_size()
	resize_size = _get_parent_size()
	
	# keep minimum size.
	size.x = max(size.x, minimum_size.x)
	size.y = max(size.y, minimum_size.y)
	
	# keep within screen size.
	size.x = min(size.x, resize_size.x)
	size.y = min(size.y, resize_size.y)
	
	# keep within screen bounds.
	position.x = min(position.x + size.x, resize_size.x) - size.x
	position.y = min(position.y + size.y, resize_size.y) - size.y
	position.x = max(position.x, 0)
	position.y = max(position.y, 0)

## Connect signals to given panel.[br]
## When hovered, it is stored in [member TerminalNode.hovering_edge].
func _handle_hovering_for_edge(edge: Panel) -> void:
	edge.mouse_entered.connect(func(): if not resizing: hovering_edge = edge)
	edge.mouse_exited.connect(func(): if not resizing: hovering_edge = null) # TODO : make it so this calls when it needs to.

func _handle_drag(event: InputEvent) -> void:
	position.x = min(max(event.position.x + resize_position.x, 0), _get_parent_size().x - size.x)
	position.y = min(max(event.position.y + resize_position.y, 0), _get_parent_size().y - size.y)

func _handle_edge_drag(event: InputEvent) -> void:
	match hovering_edge.name:
		'edge_t':
			position.y = max(min(event.position.y, (resize_position.y + resize_size.y) - minimum_size.y), 0)
			size.y = max(minimum_size.y, (resize_position.y - max(position.y, 0)) + resize_size.y)
		'edge_r':
			size.x = max(minimum_size.x, min(event.position.x, _get_parent_size().x) - resize_position.x)
		'edge_b':
			size.y = max(minimum_size.y, min(event.position.y, _get_parent_size().y) - resize_position.y)
		'edge_l':
			position.x = max(min(event.position.x, (resize_position.x + resize_size.x) - minimum_size.x), 0)
			size.x = max(minimum_size.x, (resize_position.x - max(position.x, 0)) + resize_size.x)
		'edge_tl':
			position.y = max(min(event.position.y, (resize_position.y + resize_size.y) - minimum_size.y), 0)
			size.y = max(minimum_size.y, (resize_position.y - max(position.y, 0)) + resize_size.y)
			position.x = max(min(event.position.x, (resize_position.x + resize_size.x) - minimum_size.x), 0)
			size.x = max(minimum_size.x, (resize_position.x - max(position.x, 0)) + resize_size.x)
		'edge_tr':
			position.y = max(min(event.position.y, (resize_position.y + resize_size.y) - minimum_size.y), 0)
			size.y = max(minimum_size.y, (resize_position.y - max(position.y, 0)) + resize_size.y)
			size.x = max(minimum_size.x, min(event.position.x, _get_parent_size().x) - resize_position.x)
		'edge_br':
			size.y = max(minimum_size.y, min(event.position.y, _get_parent_size().y) - resize_position.y)
			size.x = max(minimum_size.x, min(event.position.x, _get_parent_size().x) - resize_position.x)
		'edge_bl':
			size.y = max(minimum_size.y, min(event.position.y, _get_parent_size().y) - resize_position.y)
			position.x = max(min(event.position.x, (resize_position.x + resize_size.x) - minimum_size.x), 0)
			size.x = max(minimum_size.x, (resize_position.x - max(position.x, 0)) + resize_size.x)

func _on_viewport_resize() -> void:
	# don't allow terminal resizing or dragging during viewport resizing.
	hovering_titlebar = false
	hovering_edge = null
	
	# constrain to fit parent. call deferred so that the parent sizes update before doing calculations.
	_constrain.call_deferred()

#endregion 󰁌 RESIZE & DRAG.

#region // GETTERS.

## Get size of parent. If no parent control node, then use window size.
func _get_parent_size() -> Vector2i:
	return parent_control_node.size if parent_control_node else DisplayServer.window_get_size()

#endregion GETTERS.

#region // SETTERS.

## Sets text of titlebar.
func _set_title(value: String) -> void:
	title = value
	if titlebar:
		titlebar.text = value

## Sets font size and updates associated theme overrides.
func _set_font_size(value: int) -> void:
	font_size = value
	set_font_size(value)

## Hides edges if disabled.
func _set_drag_and_resize(value: bool) -> void:
	drag_and_resize = value
	
	if not edge_t:
		return
	
	if drag_and_resize:
		edge_t.show()
		edge_r.show()
		edge_b.show()
		edge_l.show()
		edge_tl.show()
		edge_tr.show()
		edge_br.show()
		edge_bl.show()
	else:
		edge_t.hide()
		edge_r.hide()
		edge_b.hide()
		edge_l.hide()
		edge_tl.hide()
		edge_tr.hide()
		edge_br.hide()
		edge_bl.hide()

## Clamps and rounds vector between 0 and 1000.
func _set_minimum_size(value: Vector2) -> void:
	minimum_size.x = round(clamp(value.x, 0, 1000))
	minimum_size.y = round(clamp(value.y, 0, 1000))
	custom_minimum_size = minimum_size

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
