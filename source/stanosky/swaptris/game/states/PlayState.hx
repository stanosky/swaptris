package stanosky.swaptris.game.states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import stanosky.swaptris.game.Board;
import stanosky.swaptris.game.bricks.IBrick;
import stanosky.swaptris.game.bricks.IBrickFactory;
import stanosky.swaptris.game.bricks.Pattern;
import stanosky.swaptris.game.bricks.PatternBrickFactory;
import stanosky.swaptris.game.bricks.RandomBrickFactory;

import flixel.input.mouse.FlxMouse;



/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _brickSize:Int = 30;
	private var _board:Board;
	private var _randomFactory:IBrickFactory;
	private var _patternFactory:IBrickFactory;
	private var _boardHolder:FlxSpriteGroup;

	private var _mousePressX:Int;
	private var _mousePressY:Int;
	private var _validPress:Bool = false;
	private var _swapSound:FlxSound;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_swapSound = FlxG.sound.load(AssetPaths.swap__wav);
		_boardHolder = new FlxSpriteGroup();
		_board = new Board(10, 10, _brickSize, _boardHolder);
		_randomFactory = new RandomBrickFactory(_brickSize);
		_patternFactory = new PatternBrickFactory(_brickSize);
		cast(_patternFactory, PatternBrickFactory).setPattern(Pattern.GROUPS);
		_board.setBrickFactory(_patternFactory);
		//_board.setBrickFactory(_randomFactory);
		_board.fillTempGrid();
		//_board.setBrickFactory(_randomFactory);
		//_board.fillMainGrid();
		_boardHolder.x = (FlxG.width - _boardHolder.width) * .5;
		_boardHolder.y = (FlxG.height - _boardHolder.height) * .5;		
		add(_boardHolder);
		
		_board.findBrickGroups();
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		//_board.fillMainGrid();		
		if (FlxG.mouse.justPressed) onMousePress();
		if (FlxG.mouse.justReleased) onMouseRelease();
		super.update();
	}	
	
	private function onMouseRelease() {
		if(_validPress) {
			var mouseX:Int = Math.round(FlxG.mouse.screenX);
			var mouseY:Int = Math.round(FlxG.mouse.screenY);
			var diffX:Int  = mouseX - _mousePressX;
			var diffY:Int  = mouseY - _mousePressY;
			var colIndex:Int = Math.floor(_mousePressX / _brickSize);
			var rowIndex:Int = Math.floor(_mousePressY / _brickSize);
			var brick1:IBrick;
			var brick2:IBrick;
			//trace(boardIndex.toString());
			if (Math.abs(diffX) > Math.abs(diffY)) {
				if (diffX > 0) {
					_board.swapBricks(colIndex, rowIndex, colIndex + 1, rowIndex);
				} else {
					_board.swapBricks(colIndex, rowIndex, colIndex - 1, rowIndex);
				}
				_swapSound.play();
			} else if (Math.abs(diffX) < Math.abs(diffY)) {
				if (diffY > 0) {
					_board.swapBricks(colIndex, rowIndex, colIndex, rowIndex + 1);
				} else {
					_board.swapBricks(colIndex, rowIndex, colIndex, rowIndex - 1);
				}
				_swapSound.play();
			}
			
		}
	}
	
	private function onMousePress():Void {
		var mouseX:Int = Math.round(FlxG.mouse.screenX);
		var mouseY:Int = Math.round(FlxG.mouse.screenY);
		if (mouseX >= 0 && mouseX <= FlxG.width && mouseY >= 0 && mouseY <= FlxG.height) {
			_validPress = true;
			_mousePressX = Math.round(FlxG.mouse.screenX);
			_mousePressY = Math.round(FlxG.mouse.screenY);
		} else {
			_validPress = false;
		}
	}
	
}