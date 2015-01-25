/**
  * This class is meant to represent a simple circular object.
  * Velocities can be applied to it, and it will move based off
  * of it's vx and vy.
  *
  * Author: Michael Albanese
  * Creation Date: January 25, 2015
  * Project: CS413 project 1
  */
  
package com.cykon.haxe.movable;

import starling.textures.Texture;

class Circle extends starling.display.Image {

	var radius:Float;	// Circle radius
	var vx:Float;		// X Velocity
	var vy:Float;		// Y Velocity
	
	/** Return the X location of this (note: it's the center of the circle) */
	public function getX() : Float{
		return x;
	}
	
	/** Return the Y location of this (note: it's the center of the circle) */
	public function getY() : Float{
		return y;
	}
	
	/** Return the radius of this */
	public function getRadius() : Float{
		return radius;
	}
	
	/** Set the location of the circle, (note: this is in relation to the CENTER of the circle) */
	public function setLoc(x:Float, y:Float){
		this.x = x - radius;
		this.y = y - radius;
	}
	
	/** Set the velocities of the circle */
	public function setVelocity(vx:Float, vy:Float){
		this.vx = vx;
		this.vy = vy;
	}
	
	/** Applies the velocities of the circle to the x & y coordinates */
	public function applyVelocity(modifier:Float){
		x += vx*modifier;
		y += vy*modifier;
	}
	
	/** Test if this circle has collided with another circle */
	public function circleHit(){}
	
	public function new(texture:Texture, x:Float, y:Float, radius:Float){
		super(texture);

		this.width = radius*2;
		this.height = radius*2;
		this.radius = radius;
		
		setLoc(x,y);
    }
}