package com.cykon.haxe.generator;
/**
  * This class is meant to manage DespawningCircles which fly inward
  * to the stage
  *
  * Author: Michael Albanese
  * Creation Date: January 25, 2015
  * Project: CS413 project 1
  */

import starling.display.Sprite;
import starling.textures.Texture;
import com.cykon.haxe.movable.*;
import com.cykon.haxe.cmath.Vector;

class DCircleGenerator {
	
	var parent : Sprite;	  // Parent container object
	var texture : Texture;	  // Texture to spawn circles with
	var interval : Float;	  // Millisecond interval to spawn circles at
	var stageWidth : Float;	  // Stage Width
	var stageHeight : Float;  // Stage Height
	var spawnDist : Float;	  // Distance from stage to spawn circles
	var lastTime : Float = 0; // Last time a circle was spawned
	
	var minSpeed : Float;
	var maxSpeed : Float;
	var minRadius : Float;
	var maxRadius : Float;
	
	// List used to keep track of circle objects
	var a_Circle : List<DespawningCircle> = new List<DespawningCircle>();
	
	public function new(parent : Sprite, texture : Texture, minSpeed : Float, maxSpeed : Float, minRadius : Float, maxRadius : Float, interval : Float, stageWidth : Float, stageHeight : Float){
		this.parent = parent;
		this.texture = texture;
		this.minSpeed = minSpeed;
		this.maxSpeed = maxSpeed;
		this.minRadius = minRadius;
		this.maxRadius = maxRadius;
		this.interval = interval;
		this.stageWidth = stageWidth;
		this.stageHeight = stageHeight;
		this.spawnDist = Math.max(stageWidth,stageHeight)*1.2;
	}
	
	/** External hit detection method to check whether or not any circles have been hit by something */
	public function circleHit( circle : Circle ) : Bool {
		for( hcircle in a_Circle ){
			if( circle.circleHit( hcircle ) )
				return true;
		}
		return false;
	}
	
	public function generateBoss(texture:Texture, player:Circle) : DespawningCircle {
		var targetX = stageWidth/2;
		var targetY = stageHeight/2;
		var circle = new TrackingCircle(texture, targetX - 1000, targetY, 100, stageWidth, stageHeight, player);
		circle.setVelocity(2,0);
		parent.addChild(circle);
		a_Circle.add(circle);
		return circle;
	}
	
	/** Generates and adds a new circle to the generator's list */
	public function generate() : DespawningCircle{
		// Coordinates which the circle will fly towards
		var targetX = Math.random() * stageWidth;
		var targetY = Math.random() * stageHeight;
		
		// Randomized angle to spawn the circle away from target coords
		var randAngle = Math.random() * Math.PI*2;
		
		// New vector representing the spawn location
		var vector = new Vector(1,randAngle).normalize().multiply(spawnDist);
		
		// Randomize the quadrant which the circle will spawn in (default only spawns in the bottom right quadrent
		var quad = Math.round( Math.random() * 3 );
		if(quad == 1)
			vector = vector.getOpposite();
		else if(quad == 2)
			vector = vector.getPerpendicular();
		else if(quad == 3)
			vector = vector.getOpposite().getPerpendicular();
		
		// Create a new circle instance
		var radius = Math.random()*(maxRadius - minRadius) + minRadius;
		var speed = Math.random()*(maxSpeed - minSpeed) + minSpeed;
		var circle = new DespawningCircle(texture, targetX+vector.vx, targetY+vector.vy, radius, stageWidth, stageHeight);
		
		// Get the velocity vector of the circle
		vector = vector.normalize().multiply(speed).getOpposite();
		circle.setVelocity(vector.vx,vector.vy);
		
		// Add the new circle to the graph && the list
		parent.addChild(circle);
		a_Circle.add(circle);
		return circle;
	}
	
	/** Method called to update the circles in this generator */
	public function trigger(modifier : Float, time : Float){
	
		// Check to see whether a new circle should be spawned or not
		if(time - lastTime >= interval){
			generate();
			lastTime = time;
		}
		
		// Perform hit detection on the circles
		for( circle in a_Circle ){
			for( hcircle in a_Circle ){
				if( hcircle != circle && !hcircle.hasBeenHit() && circle.circleHit(hcircle, modifier)){
					circle.realisticBounce(hcircle);
					break;
				}
			}
			
			// Apply the bounce effect to the circle (only works if it was hit)
			//circle.hitBounce();
			
			// Update the circle's velocity
			circle.applyVelocity( modifier );
			
			// If the circle has despawned, remove it from the list
			if(circle.hasDespawned()){
				a_Circle.remove(circle);
			}
		}
	}
}