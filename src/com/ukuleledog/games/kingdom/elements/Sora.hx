package com.ukuleledog.games.kingdom.elements;

import com.ukuleledog.games.core.AnimatedObject;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Sora extends AnimatedObject
{

	public var speed:UInt = 2;
	
	public function new() 
	{
		super();
		
		this.bmd = Assets.getBitmapData( 'img/characters.png' );
		
		createAnimation( 'floating', 0, 0, 1, 25, 60 );
		createAnimation( 'idle', 0, 25, 1, 80, 40 );
		createAnimation( 'run-down', 0, 100, 8, 50, 50, 0.1 );
		createAnimation( 'run-up', 0, 150, 8, 55, 50, 0.1 );
		createAnimation( 'run-left', 0, 205, 8, 50, 50, 0.1 );
		createAnimation( 'run-right', 0, 255, 8, 50, 50, 0.1 );
		animate();
	}
	
}