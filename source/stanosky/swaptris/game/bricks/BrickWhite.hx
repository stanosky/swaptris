package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BrickWhite extends SimpleBrick
{

	public function new(size:Int) 
	{
		
		super(size, FlxColor.WHITE);
		
	}
	
	override private function initBrick():Void {
		loadGraphic(AssetPaths.brickTransparent__png);
		setGraphicSize(_size, _size);
		updateHitbox();		
	}
	
}