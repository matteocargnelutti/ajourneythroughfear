#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# COMPONENT_MONSTER3.GD
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;
var name = "monster3";
var is_monster = true;
var is_particule = false;
var type = 3; # Type of monster
var pixels_per_second = 3; # Scrolling speed
var configuration = 0; # Specific configuration

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
	if( self.configuration == 0 ) :
		
		# Position
		var x_position = 20;
		var y_position = get_node("Area2D").get_pos().y;
		get_node("Area2D").set_pos( Vector2(x_position, y_position) );
		
		
	# 1 = Right
	else :
		
		# Position
		var x_position = 85;
		var y_position = get_node("Area2D").get_pos().y;
		get_node("Area2D").set_pos( Vector2(x_position, y_position) );
		
	