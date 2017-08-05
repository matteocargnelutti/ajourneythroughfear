#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# HOME.GD 
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;


#-----------------------------------------------------------------------------##
# Initialization
#-----------------------------------------------------------------------------##
func _ready():
	
	#
	# Get reference to global
	#
	self.Global = get_node("/root/Global");
	
	#
	# Display best score
	#
	get_node("UI/Best Score").set_text( str("best : ", Global.datas.best_score) );


#-----------------------------------------------------------------------------##
# Sound
#-----------------------------------------------------------------------------##
func mute_switch():

	Global.mute_state_switch();
	
	if( Global.sound_is_muted ) :
		get_node("UI/Mute").set_text("Sound : no");
	else :
		get_node("UI/Mute").set_text("Sound : on");

func theme_start():
	if( !Global.get_node("Theme").is_playing() ):
		Global.get_node("Theme").play();

func sfx_play(name):
	Global.sfx_play(name);

#-----------------------------------------------------------------------------##
# Credits
#-----------------------------------------------------------------------------##

# Open from main menu
func credits_open():
	Global.sfx_play("sound5");
	get_node("AnimationPlayer").play("Credits Open");

# Close from credits menu
func credits_close():
	Global.sfx_play("sound5");
	get_node("AnimationPlayer").play("Credits Close");

# Go to elseif.eu
func credits_goto_elseif():
	OS.shell_open("http://elseif.eu");

# Twitter
func share_twitter():
	var url = str("http://www.twitter.com/share?text=Indie Game : A JOURNEY THROUGH FEAR ! Come and play at http://elseif.eu/a-journey-through-fear");
	OS.shell_open(url);

# Facebook
func share_facebook():
	var url = str("http://www.facebook.com/sharer.php?u=http://elseif.eu/a-journey-through-fear");
	OS.shell_open(url);


#-----------------------------------------------------------------------------##
# Play
#-----------------------------------------------------------------------------##

# On play button pressed : play transition
func play_goto_level():
	Global.sfx_play("sound5");
	get_node("AnimationPlayer").play("Quit");

# Level switching called by "Quit" animation callback
func quit_animation_callback():
	Global.screen_set("level");