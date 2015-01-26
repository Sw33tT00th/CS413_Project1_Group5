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
	
	var beenHit:Bool = false;  // Tells the updateVelocity method whether we can move or not
	var hitVector:Vector;	   // The normal vector representing a wall which was hit
	var leftoverMag:Float = 0; // The leftover magnitude from the last hit;
	
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
	public function applyVelocity(modifier:Float):Bool{
		
		if(beenHit){
			beenHit = false;
			return false;
		}

		var movVector = new Vector(vx,vy).multiply(modifier);
		if(leftoverMag <= 0)
			movVector = new Vector(vx,vy).multiply(modifier);
		else
			movVector = new Vector(vx,vy).normalize().multiply(leftoverMag*modifier);
		
		if(Math.isNaN(movVector.mag)){
			movVector.vx = movVector.vy = 0;
		}
		
		leftoverMag = 0;
		x += movVector.vx;
		y += movVector.vy;
		return true;
	}
	
	/** Test if this circle has collided with another circle */
	public function circleHit( other : Circle, modifier : Float = 1.0 ) : Bool{
		//If leftover Mag is -1, we can set it to use the full magnitude
		
		var otherVector = new Vector(other.vx,other.vy);
		var thisVector = new Vector(this.vx,this.vy);
		
		if(other.leftoverMag != 0)
			otherVector.normalize().multiply(other.leftoverMag);
		if(this.leftoverMag != 0)
			thisVector.normalize().multiply(this.leftoverMag);
					
		// Translate the movement vector of the two circles as if one wasn't moving
		var origVector = thisVector.clone().subtract(otherVector).multiply(modifier).addMagnitude(leftoverMag);
		var regVector = origVector.clone();
		
		// Get the direct vector between the two circles
		var dirVector = Vector.getVector(this.getX(),this.getY(),other.getX(),other.getY());
		
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
		if(shortestDist > totRadius){
			this.leftoverMag = 0;
			return false;
		}
		
		// Get the distance which must be subtracted from dotDistance (makes the circles close enough to touch)
		var subtractDist = Math.sqrt( totRadius*totRadius - shortestDist*shortestDist );
		
		// Multiply the normalized regVector by dotDist - subtractDist
		regVector.multiply(dotDist - subtractDist);
		
		// If the magnitude of the new regVector is less than the old one... we have a hit!!!
		if(regVector.mag <= origVector.mag){
			
			this.x += regVector.vx;
			this.y += regVector.vy;
			this.beenHit = other.beenHit = true;
			
			this.hitVector = other.hitVector = Vector.getVector(getX(),getY(),other.getX(),other.getY()).normalize();	
			
			this.leftoverMag = thisVector.mag - Vector.getVector(this.x,this.y,this.x-regVector.vx,this.y-regVector.vy).mag;
			other.leftoverMag = otherVector.mag;
			
			if(this.leftoverMag < 0)
				this.leftoverMag = 0;
			
			return true;
		}
		
		return false;
	}
	
	/** Recalculates the velocities so it bounces about the point of impact */
	public function hitBounce(){
		var velVector = new Vector(vx,vy);
		velVector.subtract(hitVector.multiply(2*velVector.dot(hitVector)));
		
		vx = velVector.vx;
		vy = velVector.vy;
	}
	
	/** Recalculates the velocities so it slides about the point of impact */
	public function hitSlide(){
		if(beenHit){
			var velVector = new Vector(vx,vy);
			var p1Vector = hitVector.getPerpendicular().normalize().multiply( velVector.mag );
			var p2Vector = hitVector.getPerpendicular().getOpposite().normalize().multiply( velVector.mag );
			
			if(p1Vector.dot(velVector) > p2Vector.dot(velVector)){
				vx = p1Vector.vx;
				vy = p1Vector.vy;
			} else {
				vx = p2Vector.vx;
				vy = p2Vector.vy;
			}
		}
	}
	
	
	public function new(texture:Texture, x:Float, y:Float, radius:Float){
		super(texture);

		this.width = radius*2;
		this.height = radius*2;
		this.radius = radius;
		
		setLoc(x,y);
    }
}