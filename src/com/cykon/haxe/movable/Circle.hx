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

import com.cykon.haxe.cmath.Vector;
import starling.textures.Texture;

class Circle extends starling.display.Image {

	var radius:Float;	// Circle radius
	var vx:Float = 0;	// X Velocity
	var vy:Float = 0;	// Y Velocity
	
	/** Return the X location of this (note: it's the center of the circle) */
	public function getX() : Float{
		return x + radius;
	}
	
	/** Return the Y location of this (note: it's the center of the circle) */
	public function getY() : Float{
		return y + radius;
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
	public function circleHit( other : Circle ) : Bool{
		// Translate the movement vector of the two circles as if one wasn't moving
		var _regVector = new Vector(this.vx-other.vx, this.vy-other.vy);
		var regVector = _regVector.clone();
		
		// Get the direct vector between the two circles
		var dirVector = new Vector(other.getX()-this.getX(), other.getY()-this.getY());
		
		// No velocity || not moving towards each other, no need to compute
		if(regVector.mag == 0 || regVector.dot(dirVector) <= 0)
			return false;
		
		// Get the normalized dot product of the two vectors
		var dotDist = regVector.normalize().dot( dirVector );
		
		// Gets the shortest distance between the two vectors
		var shortestDist = Math.sqrt(dirVector.mag*dirVector.mag - dotDist*dotDist);
		
		// Calculate the sum of the radii
		var totRadius = this.radius + other.radius;
		
		// If shortest distance is greater than totRadius, no collision will happen
		if(shortestDist > totRadius)
			return false;
		
		// Get the distance which must be subtracted from dotDistance (makes the circles close enough to touch)
		var subtractDist = Math.sqrt( totRadius*totRadius - shortestDist*shortestDist );
		
		// Multiply the normalized regVector by dotDist - subtractDist
		regVector.multiply(dotDist - subtractDist);
		
		// If the magnitude of the new regVector is less than the old one... we have a hit!!!
		if(regVector.mag <= _regVector.mag){
			this.x += regVector.vx;
			this.y += regVector.vy;
			this.vx = this.vy = other.vx = other.vy = 0;
			return true;
		}

		return false;
	}
	
	public function new(texture:Texture, x:Float, y:Float, radius:Float){
		super(texture);

		this.width = radius*2;
		this.height = radius*2;
		this.radius = radius;
		
		setLoc(x,y);
    }
}