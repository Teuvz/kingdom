package com.ukuleledog.games.kingdom.elements;

import com.ukuleledog.games.core.AnimatedObject;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Riku extends AnimatedObject
{

	public function new() 
	{
		super();
		
		this.bmd = Assets.getBitmapData( 'img/characters.png' );
		
		createAnimation( 'idle', 50, 25, 1, 80, 40 );
		animate();
	}
	
}