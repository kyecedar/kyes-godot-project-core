@tool
class_name Debugger
extends Control

static var blurbs : Array[Blurb] = []

## Indentation of blurbs.[br]
## [code]-1[/code] = indent on left.[br]
## [code]0[/code] = don't indent.[br]
## [code]1[/code] = indent on right.
static var indent : int = 1

static func createBlurb() -> Blurb:
	var b = Blurb.new(Blurb.TYPE.STRING)
	b.update("shit")
	return b
