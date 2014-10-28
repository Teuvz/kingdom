package com.ukuleledog.games.core;
import com.ukuleledog.games.kingdom.elements.Dialog;
import com.ukuleledog.games.kingdom.elements.Sora;
import flash.display.BitmapData;
import flash.display.Sprite;
import motion.Actuate;
import flash.display.Bitmap;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import openfl.Assets;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;

/**
 * ...
 * @author Matt
 */
class Room extends GameObject
{	
	
	private var keysPressed:Array<Bool>;
	private var background:Bitmap;
	private var dialog:Dialog;
	private var logo:Bitmap;
	private var playable:Bool = false;
	private var sora:Sora;
	public var blockedAreas:Array<Sprite>;
	public var actionAreas:Array<Sprite>;
	
	private var limits:Bitmap;
	private var limitTop:UInt;
	private var limitBottom:UInt;
	private var limitLeft:UInt;
	private var limitRight:UInt;
	
	private var music:SoundChannel;
	private var musicFile:Sound;
	
	public function new() 
	{
		super();
		keysPressed = new Array<Bool>();
		
		limitTop = 0;
		limitBottom = 600;
		limitLeft = 0;
		limitRight = 480;
	}
	
	public function startMusic( file:String )
	{
		musicFile = Assets.getMusic( 'music/' + file+'.mp3' );
		var transform:SoundTransform = new SoundTransform();
		transform.volume = 0.3;
		music = musicFile.play(0, 0, transform);
	}
	
	public function stopMusic()
	{
		if ( music != null )
			music.stop();
	}
	
	public function setLimit( bg:BitmapData, width:UInt, height:UInt, srcX:UInt = 0, srcY:UInt = 0, limitX:UInt = 0, limitY:UInt = 0 )
	{
		var limitData:BitmapData = new BitmapData( width, height, true );
		limitData.copyPixels( bg, new Rectangle( srcX, srcY, width, height), new Point() );
		var limits:Bitmap = new Bitmap( limitData );
		limits.y = limitX;
		limits.x = limitY;
		addChild( limits );
	}
	
	public function setBackground( bg:BitmapData, width:UInt, height:UInt, offsetLeft:UInt = 0, offsetTop:UInt = 0, srcX:UInt = 0, srcY:UInt = 0 )
	{
		background = new Bitmap();
		background.bitmapData = new BitmapData( 600, 480, false, 0x000000 );
		background.bitmapData.copyPixels( bg, new Rectangle(srcX, srcY, width, height), new Point( offsetLeft, offsetTop ) );
		addChild( background );		
	}
	
	public function setLogo( bg:BitmapData, width, height, srcX:UInt, srcY:UInt )
	{
		logo = new Bitmap();
		logo.bitmapData = new BitmapData( width, height, true );
		logo.bitmapData.copyPixels( bg, new Rectangle(srcX, srcY, width, height), new Point( 0, 0 ) );
	}
	
	public function displayLogo()
	{
		logo.x = (stage.stageWidth / 2) - (logo.width / 2);
		logo.y = (stage.stageHeight / 2) - (logo.height / 2);
		addChild( logo );
	}
	
	public function setPlayable()
	{
		keysPressed = new Array<Bool>();
		playable = true;
		stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandle );
		addEventListener( Event.ENTER_FRAME, loop );
	}
	
	public function setNotPlayable()
	{
		keysPressed = new Array<Bool>();
		playable = false;
		stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDownHandle );
		stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandle );
		removeEventListener( Event.ENTER_FRAME, loop );
	}
	
	private function keyDownHandle( e:KeyboardEvent )
	{
		keysPressed[e.keyCode] = true;
	}
	
	private function keyUpHandle( e:KeyboardEvent )
	{
		keysPressed[e.keyCode] = false;
	}
		
	private function testContactTop() : Bool
	{
		for ( area in blockedAreas )
		{
			if ( area.hitTestPoint( sora.x, sora.y, true ) || area.hitTestPoint( sora.x + sora.width, sora.y, true ) )
			{
				return false;
			}
		}
		
		return true;
	}
	
	private function testContactBottom() : Bool
	{
		for ( area in blockedAreas )
		{
			if ( area.hitTestPoint( sora.x, sora.y + sora.height, true ) || area.hitTestPoint( sora.x + sora.width, sora.y + sora.height, true ) )
			{
				return false;
			}
		}
		
		return true;
	}
	
	private function testContactLeft() : Bool
	{
		for ( area in blockedAreas )
		{
			if ( area.hitTestPoint( sora.x, sora.y, true ) || area.hitTestPoint( sora.x, sora.y + sora.height, true ) )
			{
				return false;
			}
		}
		
		return true;
	}
	
	private function testContactRight() : Bool
	{
		for ( area in blockedAreas )
		{
			if ( area.hitTestPoint( sora.x + sora.width, sora.y, true ) || area.hitTestPoint( sora.x + sora.width, sora.y + sora.height, true ) )
			{
				return false;
			}
		}
		
		return true;
	}
	
	private function loop( e:Event )
	{		
		if ( keysPressed[Keyboard.DOWN] == true && sora.y < limitBottom && testContactBottom() )
		{
			sora.setAnimation('run-down');
			sora.y += sora.speed;
		}
		else if ( keysPressed[Keyboard.UP] == true && sora.y > limitTop && testContactTop() )
		{
			sora.setAnimation('run-up');
			sora.y -= sora.speed;
		}
		else if ( keysPressed[Keyboard.LEFT] == true && sora.x > limitLeft && testContactLeft() )
		{
			sora.setAnimation('run-left');
			sora.x -= sora.speed;
		}
		else if ( keysPressed[Keyboard.RIGHT] == true && sora.x < limitRight && testContactRight() )
		{
			sora.setAnimation('run-right');
			sora.x += sora.speed;
		}
		else
		{
			sora.setAnimation('idle');
		}
		
		for ( actionArea in actionAreas )
		{
			if ( keysPressed[Keyboard.SPACE] && sora.hitTestObject( actionArea ) )
			{
				doAction( actionArea.name ); 
			}
		}
		
	}
	
	public function doAction( action:String )
	{
		trace( 'nope' );
	}
	
}