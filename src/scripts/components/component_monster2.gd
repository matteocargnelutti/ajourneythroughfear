#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# COMPONENT_MONSTER2.GD
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;
var name = "monster2";
var is_monster = true;
var is_particule = false;
var type = 2; # Type of monster
var pixels_per_second = 3; # Scrolling speed


#-----------------------------------------------------------------------------##
# Initialization
#-----------------------------------------------------------------------------##
func _ready():
	
	#
	# Get reference to global
	#
	self.Global = get_node("/root/Global");
	