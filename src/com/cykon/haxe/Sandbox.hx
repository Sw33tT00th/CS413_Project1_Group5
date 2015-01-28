/**
  * This class is meant to be the main driver behind a simple game.
  *
  * Author: Michael Albanese
  * Creation Date: January 25, 2015
  * Project: CS413 project 1
  */
package com.cykon.haxe;

import com.cykon.haxe.generator.*;
import com.cykon.haxe.movable.*;
import starling.utils.AssetManager;
import starling.textures.Texture;
import starling.events.EnterFrameEvent;
import starling.events.KeyboardEvent;
import starling.display.Stage;
import flash.system.System;
import com.cykon.haxe.cmath.Polynomial;
import com.cykon.haxe.cmath.Vector;

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
	
	// Generator which will spawn enemys periodically
	var enemyGenerator : DCircleGenerator;
	
	// Generator which will spawn points!
	var pointGenerator : SCircleGenerator;
	var points = 0;
	
	// Simple constructor
    public function new() {
        super();
		
		var c1 = new Vector(0,5);
		var v1 = new Vector(5,-15);
		var r1 = 2;
		
		var c2 = new Vector(0,0);
		var v2 = new Vector(5,15);
		var r2 = 2;
		
		populateAssetManager();
    }
	
	/** Function used to load in any assets to be used during the game */
	private function populateAssetManager() {
		assets.enqueue("../assets/circle.png");
		assets.enqueue("../assets/circle_point.png");
		assets.enqueue("../assets/circle_green_glow.png");
		assets.enqueue("../assets/circle_green_boss.png");
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
		player = new PlayerCircle(assets.getTexture("circle"), globalStage.stageWidth/2.0, globalStage.stageHeight/2.0, 25, 8);
		
		// Add our player to the scene graph
		this.addChild(player);
		
		// Initiate our enemy generator
		enemyGenerator = new DCircleGenerator(this, assets.getTexture("circle_green_glow"), 1, 5, 10, 70, 500, globalStage.stageWidth, globalStage.stageHeight);		
		pointGenerator = new SCircleGenerator(this, assets.getTexture("circle_point"), 20, globalStage.stageWidth, globalStage.stageHeight);
		pointGenerator.generate();
		
		
		// Start the onEnterFrame calls
		this.addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrame);	
		globalStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		globalStage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	
	var running = true;
	/** Function called every frame update, main game logic loop */
	private function onEnterFrame( event:EnterFrameEvent ) {
		if(!running)
			return;
			
		// Create a modifier based on time passed / expected time
		var modifier = event.passedTime / perfectDeltaTime;
		
		if(pointGenerator.circleHit( player )){
			points += 10;
			pointGenerator.generate();
			
			if(points % 50 == 0){
				enemyGenerator.generateBoss(assets.getTexture("circle_green_boss"), player);
			}
		}
		
		// Check if the player was hit by anything contained in the generator
		if(enemyGenerator.circleHit( player )){
			trace("You lose! " + "Score: " + points + " | Time: " + flash.Lib.getTimer());
			running = false;
		}
		
		// Trigger our generator so it can update the objects it's in charge of
		enemyGenerator.trigger(modifier,flash.Lib.getTimer());
		
		// Update the player's position
		player.applyVelocity(modifier);
	}
	
	/** Used to keep track when a key is pressed down */
	private function keyDown(event:KeyboardEvent){
		player.keyDown(event.keyCode);
	}
	
	/** Used to keep track of when a key is unpressed */
	private function keyUp(event:KeyboardEvent){
		player.keyUp(event.keyCode);
		
		if(event.keyCode == 32){
			//enemyGenerator.generateBoss(assets.getTexture("circle_green_boss"), player);
		}		
	}
	
	/** Main method, used to set up the initial game instance */
    public static function main() {
		// Frame rate the game ~should~ run at
		flash.Lib.current.stage.frameRate = 60;
		
        try {
			// Attempt to start the game logic
			var starling = new starling.core.Starling(Sandbox, flash.Lib.current.stage);
			//starling.antiAliasing = 16;
            globalStage = starling.stage; 
			starling.start();  
        } catch(e:Dynamic){
            trace(e);
        }
    }
}