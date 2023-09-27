@tool
class_name Blurb
extends RichTextLabel

enum TYPE {
	GROUP      =  0,
	BOOL       =  1,
	NUMBER     =  2,
	STRING     =  3,
	PARAGRAPH  =  4,
	ARRAY      =  5,
	OBJECT     =  6,
	DICTIONARY =  7,
	COLOR      =  8,
	COLOUR     =  8,
	TIMER      =  9,
	VECTOR2    = 10,
	VECTOR3    = 11,
	NODE       = 12,
}

var type  : TYPE
var value : Variant = null

func _init(type: TYPE, value: Variant = null) -> void:
	self.type = type
	self.value = value

func display(indentation: int) -> void:
	var output = ""
	
	# TODO : parse and display value.
	
	# indent on left.
	if Debugger.indent == -1:
		pass
	
	# don't indent.
	elif Debugger.indent == 0:
		pass
	
	# indent on right.
	else:
		pass

func update(value: Variant) -> void:
	self.value = value
