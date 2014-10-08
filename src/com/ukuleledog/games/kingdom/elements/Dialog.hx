package com.ukuleledog.games.kingdom.elements;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.ui.Keyboard;
import haxe.Timer;
import motion.Actuate;
import openfl.Assets;

/**
 * ...
 * @author Matt
 */
class Dialog extends Sprite
{

	private var backgroundData:BitmapData;
	private var rightBackground:Bitmap;
	private var leftBackground:Bitmap;
	
	private var faceData:BitmapData;
	private var soraFace:Bitmap;
	private var rikuFace:Bitmap;
	
	private var currentCharacter:Array<String>;
	private var currentDialog:Array<String>;
	private var preciseChacater:String;
	private var readyForClick:Bool = false;
	
	private var textField:TextField;
	private var key:DialogKey;
	
	public function new() 
	{
		super();
		
		var bmpData:BitmapData = Assets.getBitmapData( 'img/dialog.png' );
		
		backgroundData = new BitmapData( 237, 52, true );
		backgroundData.copyPixels( bmpData, new Rectangle(0, 0, 237, 52), new Point() );
		rightBackground = new Bitmap( backgroundData );
		rightBackground.x = 600;
		rightBackground.y = 350;
		rightBackground.scaleX = 1.5;
		rightBackground.scaleY = 1.5;
		
		backgroundData = new BitmapData( 237, 52, true );
		backgroundData.copyPixels( bmpData, new Rectangle(0, 52, 237, 52), new Point() );
		leftBackground = new Bitmap( backgroundData );
		leftBackground.x = -237;
		leftBackground.y = 350;
		leftBackground.scaleX = 1.5;
		leftBackground.scaleY = 1.5;
		
		faceData = new BitmapData( 100, 100, true );
		faceData.copyPixels( bmpData, new Rectangle( 0, 110, 100, 100), new Point() );
		soraFace = new Bitmap( faceData );
		soraFace.scaleX = 1.5;
		soraFace.scaleY = 1.5;
		soraFace.y = 300;
		soraFace.x = 840;
		
		faceData = new BitmapData( 100, 100, true );
		faceData.copyPixels( bmpData, new Rectangle( 100, 110, 100, 100), new Point() );
		rikuFace = new Bitmap( faceData );
		rikuFace.scaleX = 1.5;
		rikuFace.scaleY = 1.5;
		rikuFace.y = 300;
		rikuFace.x = -280;
		
		textField = new TextField();
		textField.multiline = true;
		textField.selectable = false;
		textField.border = false;
		textField.borderColor = 0xFFFFFF;
		textField.y = 353;
		textField.height = 70;
		textField.width = 260;
		
		key = new DialogKey();
		key.y = 402;
		
		this.addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		removeEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	public function display( dialog:String, character:String )
	{
		currentDialog = dialog.split( "/" );
		currentCharacter = character.split( "/" );
		
		stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
		
		displayNextText();
		
	}
	
	private function displayNextText()
	{		
		preciseChacater = currentCharacter.shift();
		
		switch( preciseChacater )
		{
			case 'sora':
				addChild( rightBackground );
				addChild( soraFace );
				textField.x = 610;
				key.x = 610;
			case 'riku':
				addChild( leftBackground );
				addChild( rikuFace );
				textField.x = -150;
				key.x = 76;
		}
		
		textField.text = currentDialog.shift();
		addChild( textField );
		
		addChild( key );
		
		if ( preciseChacater == 'sora' || preciseChacater == 'kairi' )
			Actuate.tween( this, 1, { x: -350 } );
		else			
			Actuate.tween( this, 1, { x: 237 } );	
		
		Timer.delay( unlockClick, 500 );
	}
	
	private function unlockClick()
	{
		readyForClick = true;
	}
	
	private function keyUpHandler( e:KeyboardEvent )
	{
		if ( e.keyCode != Keyboard.SPACE || !readyForClick )
		return;
		
		readyForClick = false;
		
		removeChild( key );
			
		if ( preciseChacater == 'sora' || preciseChacater == 'kairi' )
			Actuate.tween( this, 1, { x: 350 } );
		else
			Actuate.tween( this, 1, { x: -237 } );
						
		switch( preciseChacater )
		{
			case 'sora':
				removeChild( rightBackground );
				removeChild( soraFace );
			case 'riku':
				removeChild( leftBackground );
				removeChild( rikuFace );
		}
		
		if ( currentDialog.length > 0 )
		{
			displayNextText();
			return;
		}
		
		stage.removeEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
		dispatchEvent( new Event( Event.COMPLETE ) );		
		
	}
	
}