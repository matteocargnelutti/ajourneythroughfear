#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# GLOBAL.GD - Global script
#-----------------------------------------------------------------------------##
extends Node

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##
var version = "1.0.0";

#
# Global datas handler
# These datas can be loaded / saved
#
var datas = {};

#
# Temporary data
#
var next_screen = "";
var sound_is_muted = false;
var bonus = false;
var has_already_played = false;


#-----------------------------------------------------------------------------##
# Initialization
#-----------------------------------------------------------------------------##
func _ready():
	
	#
	# Set theme stream
	#
	var stream = preload("res://audio/theme.ogg");
	get_node("Theme").set_stream(stream);
	get_node("Theme").play();
	
	#
	# Set locale
	#
	TranslationServer.set_locale("en");
	
	#
	# Load datas
	#
	self.datas_load();
	
	#
	# Go to home screen
	#
	self.screen_set("epilepsy_warning");
	

#-----------------------------------------------------------------------------##
# Datas handling
#-----------------------------------------------------------------------------##

#
# Begin a new set of datas
# THIS IS THE GLOBAL DATAS REFERENCE
#
func datas_new():
	
	self.datas = {};

	#
	# Time
	#
	self.datas.best_score = 0;
	

#
# Load datas from file
#
func datas_load():
	
	# Init base datas
	self.datas_new();
	
	# Open file
	var file = File.new()
	var save_path = "user://ajourneythroughfear_savegame.bin";
	
	# If there are some datas to load
	if file.file_exists(save_path):
	
		file.open(save_path, File.READ);
		
		var tmp = file.get_var();
		
		for i in tmp :
			self.datas[i] = tmp[i];
		
		file.close();
		


#
# Save datas to file
#
func datas_save():
	
	var file = File.new()
	var save_path = "user://ajourneythroughfear_savegame.bin";
		
	file.open(save_path, File.WRITE);
	file.store_var(self.datas);
	file.close();

#-----------------------------------------------------------------------------##
# SCREENS Handling
#-----------------------------------------------------------------------------##
func screen_set( screen_name ) :
	
	# Loading the scene
	var scene = load( str("res://scenes/screens/",screen_name,".tscn") );
	var screen = scene.instance();
	
	self.next_screen = screen; # We save the loaded screen to
	
	# Freeing the current screen
	if( get_node("Screen Handler").get_child(0) ) :
		get_node("Screen Handler").get_child(0).queue_free();
	
	# Inputing the new screen 
	get_node("Screen Handler").add_child(self.next_screen);


func screen_get():
	return get_node("Screen Handler").get_child(0);


#-----------------------------------------------------------------------------##
# Sound
#-----------------------------------------------------------------------------##
# Mute / unmute
func mute_state_switch():
	
	self.sound_is_muted = !self.sound_is_muted;
	
	if( self.sound_is_muted ) :
		get_node("Theme").set_volume_db(-999);
		get_node("Sounds").set_default_volume_db(-999);
	else :
		get_node("Theme").set_volume_db(0);
		get_node("Sounds").set_default_volume_db(-1.25);

# Theme fade in
func theme_fade_in(speed):
	
	if( self.sound_is_muted):
		return;
	
	get_node("Theme/AnimationPlayer").play("Fade In", 1, speed);

# Theme fade out
func theme_fade_out(speed):
	
	if( self.sound_is_muted):
		return;
	
	get_node("Theme/AnimationPlayer").play("Fade Out", 1, speed);

# Play sfx
func sfx_play(name):
	
	if( self.sound_is_muted):
		return;
		
	get_node("Sounds").play(name);