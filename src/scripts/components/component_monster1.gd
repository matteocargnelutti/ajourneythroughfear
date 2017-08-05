#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# COMPONENT_MONSTER1.GD
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;
var name = "monster1";
var is_monster = true;
var is_particule = false;
var type = 1; # Type of monster
var pixels_per_second = 3; # Scrolling speed
var configuration = 0;


#-----------------------------------------------------------------------------##
# Initialization
#-----------------------------------------------------------------------------##
func _ready():
	
	#
	# Get reference to global
	#
	self.Global = get_node("/root/Global");
	
	#
	# Pick a random configuration
	#
	randomize();
	self.configuration = rand_range( 0, 2 );
	self.configuration = int(self.configuration);
	
	# 0 Left
	if( configuration == 0 ) :
		
		# Position
		var x_position = 16;
		var y_position = get_node("Area2D").get_pos().y;
		get_node("Area2D").set_pos( Vector2(x_position, y_position) );
		
		# Rotation
		get_node("Area2D").set_rot( -0.6 );
		
		
	# 1 = Right
	else :
		
		# Position
		var x_position = 92;
		var y_position = get_node("Area2D").get_pos().y;
		get_node("Area2D").set_pos( Vector2(x_position, y_position) );
		
		
		# Rotation
		get_node("Area2D").set_rot( 0.6 );
		
	