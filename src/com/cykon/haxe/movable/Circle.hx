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
	var massMod = 1.0;		   // Modifier to change mass by...
	
	public function hasBeenHit() : Bool {
		return beenHit;
	}
	
	/** Reterns whether or not there is leftoverMag from a hit */
	public function hasLeftOverMag() : Bool{
		return (leftoverMag != 0);
	}
	
	/** Return the X location of this (note: it's the center of the circle) */
	public function getX() : Float{
		return x + radius;
	}
	
	/** Return the Y location of this (note: it's the center of the circle) */
	public function getY() : Float{
		return y + radius;
	}
	
	/** Return the vx of this */
	public function getVX() : Float{
		return vx;
	}
	
	/** Return the vy of this */
	public function getVY() : Float{
		return vy;
	}
	
	/** Return the radius of this */
	public function getRadius() : Float{
		return radius;
	}
	
	/** Returns the mass of this object */
	public function getMass() : Float {
		return Math.PI * radius * radius * massMod;
	}
	
	/** Set the density of the mass of this object */
	public function setMassMod(massMod:Float){
		this.massMod = massMod;
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
		leftoverMag = 0;
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
	
	private function simpleSort(a:Float,b:Float):Int{
		if(a < b) return -1;
		if(a > b) return 1;
		return 0;
	}
	
	public function boundingVectorHit( circle : Circle, modifier : Float = 1.0 ):Bool{
		var xBound = [this.getX(), this.getX() + this.vx*modifier];
		var yBound = [this.getY(), this.getY() + this.vy*modifier];
		
		var XBound = [circle.getX(), circle.getX() + circle.vx*modifier];
		var YBound = [circle.getY(), circle.getY() + circle.vy*modifier];
	
		xBound.sort(simpleSort);  	yBound.sort(simpleSort);
		XBound.sort(simpleSort);  	YBound.sort(simpleSort);
		
		return !(XBound[0] > xBound[1]
			  || XBound[1] < xBound[0]
		      || YBound[0] > yBound[1]
			  || YBound[1] < yBound[0]);
	}
	
	/** Test if this circle has collided with another circle */
	public function circleHit( other : Circle, modifier : Float = 1.0 ) : Bool{
		//if(boundingVectorHit(other,modifier))
		//	return false;
		
		var otherVector = new Vector(other.vx,other.vy);
		var thisVector = new Vector(this.vx,this.vy);
					
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
		var subtractDist = Math.sqrt( totRadius*totRadius - shortestDist*shortestDist );// + 1;
		
		// Multiply the normalized regVector by dotDist - subtractDist
		regVector.multiply(dotDist - subtractDist);
		
		// If the magnitude of the new regVector is less than the old one... we have a hit!!!
		if(regVector.mag <= origVector.mag){
			var hitPosition = regVector.mag / origVector.mag;
			
			this.x += this.vx*modifier*hitPosition;
			this.y += this.vy*modifier*hitPosition;
			other.x += other.vx*modifier*hitPosition;
			other.y += other.vy*modifier*hitPosition;
			
			this.beenHit = other.beenHit = true;		
			this.hitVector = Vector.getVector(getX(),getY(),other.getX(),other.getY()).normalize();
			other.hitVector = this.hitVector.clone();	
			
			return true;
		}
		
		return false;
	}
	
	public function realisticBounce( other : Circle ){
		var otherVector = new Vector(other.vx,other.vy);
		var thisVector = new Vector(this.vx,this.vy);
		
		var a1 = otherVector.dot( hitVector );
		var a2 = thisVector.dot( hitVector );
		
		var hitP = (2.0 * (a1 - a2)) / ( this.getMass() + other.getMass() );
		
		otherVector.subtract( other.hitVector.multiply(hitP*this.getMass()) );
		thisVector.add( this.hitVector.multiply(hitP*other.getMass()));
		
		this.vx = thisVector.vx;
		this.vy = thisVector.vy;
		other.vx = otherVector.vx;
		other.vy = otherVector.vy;
	}
	
	/** Recalculates the velocities so it bounces about the point of impact */
	public function hitBounce(){
		if(beenHit){
			var velVector = new Vector(vx,vy);
			velVector = velVector.clone().subtract(hitVector.multiply(2*velVector.dot(hitVector))).normalize().multiply(velVector.mag);
		
			vx = velVector.vx;
			vy = velVector.vy;
		}
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