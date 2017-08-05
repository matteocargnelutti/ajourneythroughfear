#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# COMPONENT_LIFE.GD
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;
var Screen = null;
var name = "life";
var is_monster = false;
var is_particule = true;
var pixels_per_second = 3.5; # Scrolling speed
var configuration = 0; # Specific configuration

#-----------------------------------------------------------------------------##
# Initialization
#-----------------------------------------------------------------------------##
func _ready():
	
	#
	# Get reference to global
	#
	self.Global = get_node("/root/Global");
	self.Screen = Global.get_node("Screen Handler/Screen");
	
	#
	# Set x position
	#
	self.set_x_position();

# Reset x position
func set_x_position():
	
	#
	# Get position of current generated monster (in Level so parent x2)
	#
	var x_position = 0;
	for generated in Screen.get_node("Generated").get_children() :
		if( generated.is_monster == true ) :
			x_position = generated.get_node("Area2D").get_pos();
			x_position = x_position.x;
	
	# If there are generated objects on the right
	if( x_position > 54 ) :
		x_position = 20; # Put bonus on the left
	# If there are generated objects on the left
	else :
		x_position = 85; # Put bonus on the right
	
	# Set position 
	var y_position = get_node("Area2D").get_pos().y;
	get_node("Area2D").set_pos( Vector2(x_position, y_position) );
