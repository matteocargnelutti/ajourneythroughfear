#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# COMPONENT_MONSTER5.GD
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;
var name = "monster5";
var is_monster = true;
var is_particule = false;
var type = 5; # Type of monster
var pixels_per_second = 4; # Scrolling speed
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
	self.configuration = rand_range( 0, 3 );
	self.configuration = int(self.configuration);
	
	# 0 Left
	if( self.configuration == 0 ) :
		
		# Position
		var x_position = 25;
		var y_position = get_node("Area2D").get_pos().y;
		get_node("Area2D").set_pos( Vector2(x_position, y_position) );
		
		
	# 1 = Right
	elif( self.configuration == 1 ) :
		
		# Position
		var x_position = 95;
		var y_position = get_node("Area2D").get_pos().y;
		get_node("Area2D").set_pos( Vector2(x_position, y_position) );
	
	# 2 = Rand
	else:
		
		# Position
		var x_position = 70;
		var y_position = get_node("Area2D").get_pos().y;
		get_node("Area2D").set_pos( Vector2(x_position, y_position) );
	
	
	
