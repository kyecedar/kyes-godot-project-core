@tool
class_name Blurb
extends Node

enum TYPE {
	BOOL       =  0,
	NUMBER     =  1,
	STRING     =  2,
	PARAGRAPH  =  3,
	ARRAY      =  4,
	OBJECT     =  5,
	DICTIONARY =  6,
	COLOR      =  7,
	COLOUR     =  8,
	TIMER      =  8,
	VECTOR2    =  9,
	VECTOR3    = 10,
	NODE       = 11,
}

var type   : TYPE
var object : Object
var member : String

func _init(type: TYPE, object: Object, member: String) -> void:
	self.type = type
	self.object = object
	self.member = member

## Appends text to given [RichTextLabel].
#static var append_text : Callable = func(label: RichTextLabel) -> void:
	#if object:
		#if not object[member]:
			#Blurb.append_member_name.call(label, member)
			#label.push_color(game.NULL_COLOR)
			#label.add_text("null")
			#label.pop()
			#return
#
		#match type:
			#TYPE.BOOL:
				#append_bool.call(label, object, member)
	#else:
		#Logger.etch_error("blurb; object is null, can't get member.")

#region // 󰎜 APPENDATION.

#static var append_bool : Callable = func(label: RichTextLabel, object: Object, member: String) -> void:
	#Blurb.append_member_name.call(label, member)

#static var append_member_name : Callable = func(label: RichTextLabel, member: String) -> void:
	#label.push_color(game.MEMBER_NAME_COLOR)
	#label.add_text(member + ' ')
	#label.pop()

#endregion 󰎜 APPENDATION.

## Gets the value of the tracked variables.
func get_value() -> Variant:
	if not object:
		return null
	return object[member]
