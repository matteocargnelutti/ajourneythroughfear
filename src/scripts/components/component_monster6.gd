#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# COMPONENT_MONSTER6.GD
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;
var name = "monster6";
var is_monster = true;
var is_particule = false;
var type = 6; # Type of monster
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
