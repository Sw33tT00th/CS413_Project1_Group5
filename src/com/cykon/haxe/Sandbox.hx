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
import flash.system.System;

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
	var a_Circle : Array<DespawningCircle> = new Array<DespawningCircle>();
	
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
		player = new PlayerCircle(assets.getTexture("circle"), globalStage.stageWidth/2.0, globalStage.stageHeight/2.0, 15, 10);
		
		// Add our player to the scene graph
		this.addChild(player);
		
		// Demo circle object
		var circle : DespawningCircle = new DespawningCircle(assets.getTexture("circle_green_glow"), 400, 100, 50, globalStage.stageWidth, globalStage.stageHeight);
		circle.setVelocity(0, 2);
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
		
		if( player.circleHit( a_Circle[0], modifier ) ){
			a_Circle[0].hitSlide();
			player.hitSlide();
		}
		
		player.applyVelocity( modifier );
			
		// Update circle velocities
		for( i in 0...a_Circle.length ){
			a_Circle[i].applyVelocity( modifier );
			//if(a_Circle[i].hasDespawned())
			//	trace("nooo");
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