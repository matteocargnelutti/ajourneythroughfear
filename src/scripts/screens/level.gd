#-----------------------------------------------------------------------------##
# A JOURNEY THROUGH FEAR
# LEVEL.GD - Global Screen script
#-----------------------------------------------------------------------------##
extends Node2D

#-----------------------------------------------------------------------------##
# Datas
#-----------------------------------------------------------------------------##

#
# Tech
#
var Global = null;

#
# Level datas
#

# Game
var pause = false;
var game_over = false;
var score = 0;
var difficulty = 1;
var life = 100;
var beam = 0;

# Player controls
var player_offset_max = 53;
var player_offset_left = 0;
var player_offset_right = 0;

# Monsters generation
var monster_last_index = 0;
var monster_indicator_opacity = 0.0;

# Particules
var particule_last_index = 0;

#-----------------------------------------------------------------------------##
# Initialization
#-----------------------------------------------------------------------------##
func _ready():
	
	#
	# Launch process
	#
	set_fixed_process(true);
	
	#
	# Get reference to global
	#
	self.Global = get_node("/root/Global");
	
	#
	# Init animation
	#
	
	# Normal version
	if( !Global.has_already_played ) :
		get_node("AnimationPlayer").play("Init");
		Global.has_already_played = true; # Mark that the player has played at least one time
	# Shorter version
	else :
		get_node("AnimationPlayer").play("Init shortversion");
	
	#
	# Bonus ?
	#
	if( Global.bonus ) :
		self.life += 50;
		self.beam = 100;
		Global.bonus = false;
	
	#
	# Hud init
	#
	self.score_update();
	self.life_update();
	
	# Sound state
	if( Global.sound_is_muted ) :
		get_node("Top Menu/Sound").set_text("Sound : No");
	


#-----------------------------------------------------------------------------##
# Process
#-----------------------------------------------------------------------------##
func _fixed_process(delta):

	#
	# Do nothing if pause mode
	#
	if( self.pause ) :
		return;

	#
	# Do nothing if game over 
	#
	if( self.game_over ) :
		return;
	
	#
	# Controls
	#
	
	# Left
	if( Input.is_action_pressed("player_left") ):
		
		if( self.player_offset_left <= self.player_offset_max ) :
		
			# Calcultate the amount of offset to apply
			var offset = 4;
			
			#if( self.player_offset_left < 8 ) :
			#	offset = 5;
			
			if( self.player_offset_left > 40 ) :
				offset = 2;
			
			# Move
			get_node("Player").move_local_x(-offset);
			self.player_offset_left += offset;
			self.player_offset_right -= offset;
		
	
	# Right
	if( Input.is_action_pressed("player_right") ):
		
		if( self.player_offset_right <= self.player_offset_max ) :
		
			# Calcultate the amount of offset to apply
			var offset = 4;
			
			#if( self.player_offset_right < 8 ) :
			#	offset = 5;
			
			if( self.player_offset_right > 40 ) :
				offset = 2;
			
			# Move
			get_node("Player").move_local_x(offset);
			self.player_offset_right += offset;
			self.player_offset_left -= offset;
	
	#
	# Generated objects movement
	#
	for generated in get_node("Generated").get_children() :
		
		#
		# Move generated object by its parameter "pixels_per_second" * (difficulty * 0.5)
		#
		generated.move_local_y( - generated.pixels_per_second * (self.difficulty * 0.5) );
		
		# Specific move : monster 3
		if( generated.is_monster == true && generated.type == 3 ) :
			
			# Direction
			var direction = 0.5;
			
			if( generated.configuration == 1 ) :
				direction = direction-(direction*2); 
			
			generated.get_node("Area2D").move_local_x( direction );
		
		#
		# Indicator for monsters position
		#
		if( generated.is_monster ):
			
			# Set position
			var indicator_x = generated.get_node("Area2D").get_pos().x;
			var indicator_y = 170;
			
			# Special : if "Beam Ready" is visible, set y 10px upper
			if( get_node("Hud/Beam Ready").get_opacity() == 1 ) :
				indicator_y = 160;
			
			get_node("Hud/Monster Indicator").set_pos( Vector2(indicator_x, indicator_y) );
			
			# Set opacity
			get_node("Hud/Monster Indicator").set_opacity( self.monster_indicator_opacity );
			self.monster_indicator_opacity -= 0.03;
	
	#
	# Is beam ready ?
	#
	if( self.beam >= 100 ) :
		get_node("Hud/Beam Ready").set_disabled(false);
		get_node("Hud/Beam Ready").set_opacity(1);


# Clear generated items
func clear_generated_items():
	
	for generated in get_node("Generated").get_children() :
		#print( str(generated.get_name(), " freed") );
		generated.queue_free();

#-----------------------------------------------------------------------------##
# Monster indicator sound
#-----------------------------------------------------------------------------##
# Triggered by Indicator Sound Timer, called by monster generator
func play_monster_indicator_sound():
	self.sfx_play("sound6");

#-----------------------------------------------------------------------------##
# Collisions with screen end
#-----------------------------------------------------------------------------##
func object_reached_screen_end( object ):
	
	# Current object is children RigidBody
	object = object.get_parent();
	
	#
	# If it's a monster : we destroy it and generate another one
	#
	if( object.is_monster == true ) :
		object.queue_free();
		monster_generate();
		return;

	#
	# If it's a particule : we just destroy it 
	#
	if( object.is_particule == true ) :
		object.queue_free();
		return;


#-----------------------------------------------------------------------------##
# Collisions objects w/ player
#-----------------------------------------------------------------------------##
func object_touched_player( object ):

	# Current object is children Area
	object = object.get_parent();
	
	# Collision with monster
	if( object.is_monster == true ) :
		monster_collision_against_player( object );
	
	# Collision with particule
	if( object.is_particule == true ) :
		particule_collision_against_player( object );


#-----------------------------------------------------------------------------##
# Monsters
#-----------------------------------------------------------------------------##
func monster_generate():

	# Preload
	var monsters = {
		1: preload("res://scenes/components/component_monster1.tscn"),
		2: preload("res://scenes/components/component_monster2.tscn"),
		3: preload("res://scenes/components/component_monster3.tscn"),
		4: preload("res://scenes/components/component_monster4.tscn"),
		5: preload("res://scenes/components/component_monster5.tscn"),
		6: preload("res://scenes/components/component_monster6.tscn"),
		7: preload("res://scenes/components/component_monster7.tscn"),
		8: preload("res://scenes/components/component_monster8.tscn"),
		9: preload("res://scenes/components/component_monster9.tscn")
	};
	
	# Pick a random monster
	randomize();
	
	var index = self.monster_last_index;
	
	while( index == self.monster_last_index ) : 
		index = rand_range( 1, 10 );
		index = int(index);
	
	self.monster_last_index = index;
	
	var monster = monsters[index];
	
	# Inject monster
	get_node("Generated").add_child( monster.instance() );
	
	# Reload indicator opacity
	self.monster_indicator_opacity = 1;
	
	# Init indicator sound timer
	get_node("Timers/Indicator Sound Timer").start();
	
	# Reset particules x position (to avoid misplaced ones)
	for generated in get_node("Generated").get_children() :
		
		if( generated.is_particule == true && generated.get_pos().y >= -45 ):
			generated.set_x_position();
	

func monster_collision_against_player( monster ):
	
	
	# Damage to player
	self.life -= 20;
	self.life_update();
	
	# Play sound
	if( self.life > 0 ) :
		self.sfx_play("sound1");
	
	# Animation if life > 0
	if( self.life > 0 ) :
		#if( !get_node("AnimationPlayer").is_playing() ) :
		get_node("AnimationPlayer").play("Player damage");


#-----------------------------------------------------------------------------##
# Particules
#-----------------------------------------------------------------------------##
func particule_generate():
	
	# Preload
	var particules = {
		1: preload("res://scenes/components/component_life.tscn"),
		2: preload("res://scenes/components/component_beam.tscn")
	};
	
	# Pick a random particule
	randomize();
	
	var index = self.particule_last_index;
	
	while( index == self.particule_last_index ) : 
		index = rand_range( 1, 3 );
		index = int(index);
	
	self.particule_last_index = index;
	
	var particule = particules[index];
	
	# Inject particule
	get_node("Generated").add_child( particule.instance() );
	

func particule_collision_against_player( object ):

	#
	# Play sound
	#
	self.sfx_play("sound7");
	
	#
	# Life
	#
	if( object.name == "life" ) :
		
		# Life bonus
		self.life += 5;
		self.life_update();
		
		# Particule desctruction
		object.queue_free();
		
		# Animation
		#if( !get_node("AnimationPlayer").is_playing() ) :
		get_node("AnimationPlayer").play("Player Bonus");
	
	#
	# Beam point
	#
	if( object.name == "beam" ) :
	
		# Beam bonus
		self.beam += 25;
		
		# Score bonus
		self.score += 5;
		self.score_update();
		
		# Particule desctruction
		object.queue_free();
		
		# Animation
		#if( !get_node("AnimationPlayer").is_playing() ) :
		get_node("AnimationPlayer").play("Player Bonus");

#-----------------------------------------------------------------------------##
# Game Over
#-----------------------------------------------------------------------------##
func game_over():
	
	self.game_over = true;
	
	#
	# Manage best score
	#
	if( self.score > Global.datas.best_score ) :
		Global.datas.best_score = self.score;
		Global.datas_save();
	
	#
	# Show infos
	#
	get_node("Retry Menu/Score").set_text( str("your score : ", self.score) );
	get_node("Retry Menu/Best Score").set_text( str("best score : ", Global.datas.best_score) );
	
	# New record
	if( self.score == Global.datas.best_score ) :
		get_node("Retry Menu/Best Score").set_text("New record !");
	
	#
	# Animation
	#
	get_node("AnimationPlayer").stop();
	get_node("AnimationPlayer").play("Game Over");

#
# Retry
#
func retry_animation():
	get_node("AnimationPlayer").play("Close level and retry");

# Called by "Close level and retry" animation
func retry():
	Global.screen_set("level");

#
# Quit
#
func quit_animation():
	get_node("AnimationPlayer").play("Close level and quit");

# Called by "Close level and quit" animation
func quit():
	Global.screen_set("home");

#
# Twitter
#
func share_twitter():
	var url = str("http://www.twitter.com/share?text=I just played A JOURNEY THROUGH FEAR and made a score of ",self.score," ! Come and play at http://elseif.eu/a-journey-through-fear");
	OS.shell_open(url);

#
# Facebook
#
func share_facebook():
	var url = str("http://www.facebook.com/sharer.php?u=http://elseif.eu/a-journey-through-fear?score=",self.score);
	OS.shell_open(url);


#-----------------------------------------------------------------------------##
# Sound
#-----------------------------------------------------------------------------##
func mute_switch():

	# Switch 
	Global.mute_state_switch();
	
	# Display
	if( Global.sound_is_muted ) :
		get_node("Top Menu/Sound").set_text("Sound : No");
	else :
		get_node("Top Menu/Sound").set_text("Sound : On");
		

func sfx_play(name):
	Global.sfx_play(name);

func theme_fade_in(speed):
	Global.theme_fade_in(speed);

func theme_fade_out(speed):
	Global.theme_fade_out(speed);

#-----------------------------------------------------------------------------##
# Score
#-----------------------------------------------------------------------------##

# Called by timer each 0.5s
func scoring():

	if( self.game_over ) :
		return;

	self.score += 1 * self.difficulty;
	self.score_update();

# Update score
func score_update():
	
	# To int
	self.score = int(self.score);
	
	# Display
	get_node("Hud/Score").set_text( str("score : ",self.score) );
	
	# Update difficulty
	if( self.score > 100  && self.score < 200 && self.difficulty != 1.5 ) :
		self.difficulty_update(1.5);
	
	if( self.score > 200  && self.score < 350 && self.difficulty != 1.75 ) :
		self.difficulty_update(1.75);
	
	if( self.score > 350  && self.score < 500 && self.difficulty != 2 ) :
		self.difficulty_update(2);
	
	if( self.score > 500  && self.score < 700 && self.difficulty != 2.25 ) :
		self.difficulty_update(2.25);
	
	if( self.score > 700  && self.difficulty != 2.50 ) :
		self.difficulty_update(2.50);


#-----------------------------------------------------------------------------##
# Life
#-----------------------------------------------------------------------------##

# Update life
func life_update():

	if( self.life <= 0 ) :
		self.life = 0;

	get_node("Hud/Life").set_text( str("life : ",self.life) );
	
	if( self.life <= 0 ) :
		self.game_over();
	


#-----------------------------------------------------------------------------##
# Beam
#-----------------------------------------------------------------------------##

func beam():
	
	# If beam is really ready
	if( self.beam < 100 ):
		return;
	
	# Destroy every enemy and particules
	clear_generated_items();
	
	# Empty beam
	self.beam = 0;
	
	# Play animation
	get_node("AnimationPlayer").stop();
	get_node("AnimationPlayer").play("Beam");
	
func beam_callback():
	
	# Score bonus
	self.score += 20;
	self.score_update();
	
	# Re-launch monster timer
	get_node("Timers/Monster Timer").start();


#-----------------------------------------------------------------------------##
# Difficulty update
#-----------------------------------------------------------------------------##
func difficulty_update( value ):

	self.difficulty = value;
	
	# Animation
	if( !get_node("AnimationPlayer").is_playing() ) :
		get_node("AnimationPlayer").play("Player Bonus");
	
	# 1.5
	if( value == 1.5 ) :
	
		# New background
		get_node("Background/AnimatedSprite").set_modulate( Color("4affff") );
		
		# New speeds
		get_node("Background/AnimationPlayer").set_speed(1.15);
		get_node("Player/Area2D/Particles").set_time_scale(1.75);
	
	# 1.75
	if( value == 1.75 ) :
		
		# New background
		get_node("Background/AnimatedSprite").set_modulate( Color("00ffa2") );
		
		# New speeds
		get_node("Background/AnimationPlayer").set_speed(1.35);
		get_node("Player/Area2D/Particles").set_time_scale(2);
	
	# 2
	if( value == 2 ) :
	
		# New background
		get_node("Background/AnimatedSprite").set_modulate( Color("ff0000") );
		
		# New speeds
		get_node("Background/AnimationPlayer").set_speed(1.50);
		get_node("Player/Area2D/Particles").set_time_scale(2.25);
	
	# 2.25
	if( value == 2.25 ) :
	
		# New background
		get_node("Background/AnimatedSprite").set_modulate( Color("0000ff") );
		
		# New speeds
		get_node("Background/AnimationPlayer").set_speed(1.75);
		get_node("Player/Area2D/Particles").set_time_scale(2.50);
	
	# 2.50
	if( value == 2.50 ) :
	
		# New background
		get_node("Background/AnimatedSprite").set_modulate( Color("e56c2384") );
		
		# New speeds
		get_node("Background/AnimationPlayer").set_speed(2);
		get_node("Player/Area2D/Particles").set_time_scale(2.75);

#-----------------------------------------------------------------------------##
# Top Menu
#-----------------------------------------------------------------------------##

# Appear / Disapear
func top_menu_switch():
	
	# Only play when nothing happens
	if( get_node("AnimationPlayer").is_playing() ) :
		return;
	
	var top_menu_position = get_node("Top Menu").get_global_pos();

	# If the menu is shown
	if( top_menu_position.x == 0 ) :
		get_node("AnimationPlayer").play("Top Menu Disappear");
	#If the menu is hidden
	else :
		get_node("AnimationPlayer").play("Top Menu Appear");


#-----------------------------------------------------------------------------##
# Pause mode
#-----------------------------------------------------------------------------##
func pause_mode_on():

	# Trigger
	self.pause = true;
	
	# Pause background animation
	get_node("Background/AnimationPlayer").set_active(false);
	
	# Pause timers
	get_node("Timers/Particules Timer").stop();
	get_node("Timers/Scoring").stop();
	get_node("Timers/Indicator Sound Timer").stop();

func pause_mode_off():

	# Trigger
	self.pause = false;
	
	# Play animations
	get_node("Background/AnimationPlayer").set_active(true);
	
	# Relaunch timers
	get_node("Timers/Particules Timer").start();
	get_node("Timers/Scoring").start();