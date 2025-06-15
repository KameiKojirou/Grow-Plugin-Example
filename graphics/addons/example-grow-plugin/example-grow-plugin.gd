@tool
extends EditorPlugin


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	print("Example Grow Plugin Enabled")
	add_autoload_singleton("example_grow_plugin", "res://addons/example-grow-plugin/grow-plugin.gd")


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	print("Example Grow Plugin Disabled")
	remove_autoload_singleton("example_grow_plugin")
