/**
  * This class is meant to be the main driver behind a simple game.
  *
  * Author: Michael Albanese
  * Creation Date: January 25, 2015
  * Project: CS413 project 1
  */
package com.cykon.haxe;

import com.cykon.haxe.movable.*;
import starling.utils.AssetManager;
import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.display.Stage;

class Sandbox extends starling.display.Sprite {
	
	// The desired frame rate which the game should run at
	static var frameRate : Int = 60;
	
	/* The 'perfect' update time, used to modify velocities in case
	   the game is not quite running at $frameRate */
	static var perfectDeltaTime : Float = 1/60; //1 / frameRate;
	
	// Reference to the global stage
	static var globalStage : Stage = null;
	
	// Keep track of game assets
	var assets : AssetManager  = new AssetManager();
	
	// Reference to the player circle, which the user will control
	var player : PlayerCircle;
	
	// Reference to the main circle array
	var a_Circle : Array<Circle> = new Array<Circle>();
	
    public function new() {
        super();
		populateAssetManager();
    }
	
	/** Function used to load in any assets to be used during the game */
	private function populateAssetManager() {
		assets.enqueue("../assets/circle.png");
		assets.enqueue("../assets/circle_green_glow.png");
		assets.loadQueue(function(percent){
			// Ideally we would have some feedback here (loading screen)
			
			// When percent is 1.0 all assets are loaded
			if(percent == 1.0){
				startGame();
			}
		});
	}
	
	/** Function to be called when we are ready to start the game */
	private function startGame() {
		// Instantiate a new player at the center of the screen with radius 15 and speed 15
		player = new PlayerCircle(assets.getTexture("circle"), globalStage.stageWidth/2.0, globalStage.stageHeight/2.0, 15, 15);
		
		// Add our player to the scene graph
		this.addChild(player);
		
		// Demo circle object
		var circle : Circle = new Circle(assets.getTexture("circle_green_glow"), -25, -25, 25);
		circle.setVelocity(10, 10);
		a_Circle.push(circle);
		this.addChild(circle);
		
		// Start the onEnterFrame calls
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);	
		globalStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		globalStage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	/** Function called every frame update, main game logic loop */
	private function onEnterFrame( event:EnterFrameEvent ) {
		// Calculate how time actually passed
		var modifier = event.passedTime / perfectDeltaTime;
		
		// Update the player object's velocities
		player.applyVelocity( modifier );
		
		// Update circle velocities
		for( i in 0...a_Circle.length ){
			a_Circle[i].applyVelocity( modifier );
		}
	}
	
	/** Used to keep track when a key is pressed down */
	private function keyDown(event:KeyboardEvent){
		player.keyDown(event.keyCode);
	}
	
	/** Used to keep track of when a key is unpressed */
	private function keyUp(event:KeyboardEvent){
		player.keyUp(event.keyCode);
	}
	
	/** Main method, used to set up the initial game instance */
    public static function main() {
		// Frame rate the game ~should~ run at
		flash.Lib.current.stage.frameRate = 60;
		
        try {
			// Attempt to start the game logic
			var starling = new starling.core.Starling(Sandbox, flash.Lib.current.stage);
			starling.antiAliasing = 6;
            globalStage = starling.stage; 
			starling.start();
        } catch(e:Dynamic){
            trace(e);
        }
    }
}