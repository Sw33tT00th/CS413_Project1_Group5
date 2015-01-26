package com.cykon.haxe.generator;
/**
  * This class is meant to manage static circles which spawn within the stage
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

class SCircleGenerator {
	
	var parent : Sprite;	  // Parent container object
	var texture : Texture;	  // Texture to spawn circles with
	var stageWidth : Float;	  // Stage Width
	var stageHeight : Float;  // Stage Height
	
	var lastTime : Float = 0; // Last time a circle was spawned
	var radius : Float;
	
	// List used to keep track of circle objects
	var a_Circle : List<Circle> = new List<Circle>();
	
	public function new(parent : Sprite, texture : Texture, radius : Float, stageWidth : Float, stageHeight : Float){
		this.parent = parent;
		this.texture = texture;
		this.radius = radius;
		this.stageWidth = stageWidth;
		this.stageHeight = stageHeight;
	}
	
	/** External hit detection method to check whether or not any circles have been hit by something */
	public function circleHit( circle : Circle ) : Bool {
		for( hcircle in a_Circle ){
			if( hcircle.circleHit( circle ) ){
				hcircle.removeFromParent();
				a_Circle.remove(hcircle);
				return true;
			}
		}
		return false;
	}
	
	/** Generates and adds a new circle to the generator's list */
	public function generate() : Circle{
		// Coordinates which the circle will fly towards
		var targetX = Math.random() * (stageWidth-radius*2) + radius;
		var targetY = Math.random() * (stageHeight-radius*2) + radius;
		
		var circle = new Circle(texture, targetX, targetY, radius);

		parent.addChild(circle);
		a_Circle.add(circle);
		return circle;
	}
}