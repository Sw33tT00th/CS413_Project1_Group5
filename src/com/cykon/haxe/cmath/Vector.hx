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
		this.mag = Math.sqrt(vx*vx + vy*vy);
	}
	
	/** Creates an identical instance of this object */
	public function clone() : Vector{
		return new Vector(vx,vy);
	}
	
	/** Multiplies this vector by some value */
	public function multiply(mag : Float) : Vector{
		vx *= mag;
		vy *= mag;
		this.mag = Math.sqrt(vx*vx + vy*vy);
		return this;
	}
	
	/** Normalizes this vector */
	public function normalize() : Vector{
		vx = vx / mag;
		vy = vy / mag;
		mag = 1.0;
		return this;
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
}