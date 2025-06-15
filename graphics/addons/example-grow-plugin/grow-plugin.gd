extends Node

@onready var go_utils = GoUtils.new()
func multiply(a, b):
	return go_utils.multiply(a, b)
