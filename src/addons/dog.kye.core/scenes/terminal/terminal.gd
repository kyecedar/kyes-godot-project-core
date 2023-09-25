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
