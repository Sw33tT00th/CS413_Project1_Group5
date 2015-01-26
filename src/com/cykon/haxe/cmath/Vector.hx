/**
  * This class is meant to represent vectors and some simple math.
  *
  * Author: Michael Albanese
  * Creation Date: January 25, 2015
  * Project: CS413 project 1
  */
  
package com.cykon.haxe.cmath;

class Vector {
	public var vx : Float;
	public var vy : Float;
	public var mag : Float;
	
	public function new(vx : Float, vy : Float){
		this.vx = vx;
		this.vy = vy;
		updateMag();
	}
	
	/** Returns a vector about two points */
	public static function getVector(x1:Float,y1:Float,x2:Float,y2:Float):Vector{
		return new Vector(x2-x1,y2-y1);
	}
	
	/** Creates an identical instance of this object */
	public function clone() : Vector{
		return new Vector(vx,vy);
	}
	
	/** Multiplies this vector by some value */
	public function multiply(mag : Float) : Vector{
		vx *= mag;
		vy *= mag;
		updateMag();
		return this;
	}
	
	/** Subtracts a vector from this one */
	public function subtract(vector : Vector):Vector{
		vx -= vector.vx;
		vy -= vector.vy;
		updateMag();
		return this;
	}
	
	/** Adds a vector with this one */
	public function add(vector : Vector):Vector{
		vx += vector.vx;
		vy += vector.vy;
		updateMag();
		return this;
	}
	
	/** Normalizes this vector */
	public function normalize() : Vector{
		vx = vx / mag;
		vy = vy / mag;
		updateMag();
		return this;
	}
	
	/** Adds some magnitude to this vector */
	public function addMagnitude(magnitude:Float):Vector{
		if(magnitude == 0)
			return this;

		magnitude += this.mag;
		return normalize().multiply(magnitude);
	}
	
	/** Performs a dot product between this and another vector */
	public function dot( vector : Vector ) : Float{
		return (this.vx*vector.vx + this.vy*vector.vy);
	}
	
	/** Projects this vector onto another vector */
	public function onto( vector : Vector ) : Vector{
		var multiplier = dot(vector) / (vector.mag*vector.mag);
		var newVector = new Vector(multiplier*vector.vx, multiplier*vector.vy);
		return newVector;
	}
	
	/** Obtains a perpendicular vector */
	public function getPerpendicular(){
		return new Vector(-vy,vx);
	}
	
	/** Returns a vector in the opposite direction */
	public function getOpposite() : Vector{
		return new Vector(-vx,-vy);
	}
	
	/** Returns the angle of this vector */
	public function getAngle() : Float{
		return Math.atan2(vy,vx);
	}
	
	/** Updates this vector's magnitude */
	private function updateMag(){
		this.mag = Math.sqrt(vx*vx + vy*vy);
	}
}