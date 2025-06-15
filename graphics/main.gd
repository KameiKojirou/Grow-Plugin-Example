extends Control

@onready var label = $Label
@onready var number = example_grow_plugin.multiply(2, 3)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	print("Hello World")
	label.set_text(str(number))
	pass


func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	pass
