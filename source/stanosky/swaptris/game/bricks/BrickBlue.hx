package stanosky.swaptris.game.bricks;
import flixel.util.FlxColor;

/**
 * ...
 * @author ...
 */
class BrickBlue extends SimpleBrick
{

	public function new(size:Int) 
	{
		
		super(size, FlxColor.BLUE);
		
	}
	
	override private function initBrick():Void {
		loadGraphic(AssetPaths.brickBlue__png);
		setGraphicSize(_size, _size);
		updateHitbox();
	}
	
	//override public function setGroup(id:Int):Void {
		//super.setGroup(id);
		//
	//}
}