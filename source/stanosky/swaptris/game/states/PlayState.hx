package stanosky.swaptris.game.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import haxe.Timer;
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
	
	private var _brickSize:Int = 44;
	private var _board:Board;
	private var _boardX:Int = 20;
	private var _boardY:Int = 64;
	private var _boardColumns:Int = 10;
	private var _boardRows:Int = 12;
	private var _boardWidth:Int;
	private var _boardHeight:Int;
	private var _randomFactory:IBrickFactory;
	private var _patternFactory:IBrickFactory;
	private var _boardHolder:FlxSpriteGroup;
	private var _background:FlxSprite;

	private var _mousePressX:Int;
	private var _mousePressY:Int;
	private var _validPress:Bool = false;
	private var _swapSound:FlxSound;
	
	//double click stuff
	private var _lastClick:Float=0;
    private var _doubleClickFired:Bool = false;
    private static inline var DOUBLE_CLICK_TIMER = 0.2; //seconds to determine a double click/tap
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		_background = new FlxSprite(0, 0, AssetPaths.playView__png);
		_swapSound = FlxG.sound.load(AssetPaths.swap__wav);
		_boardHolder = new FlxSpriteGroup();
		_boardWidth = _brickSize * _boardColumns;
		_boardHeight = _brickSize * _boardRows;
		_board = new Board(_boardX,_boardY, _boardColumns, _boardRows, _brickSize, _boardHolder);
		_randomFactory = new RandomBrickFactory(_brickSize);
		_patternFactory = new PatternBrickFactory(_brickSize);
		//cast(_patternFactory, PatternBrickFactory).setPattern(Pattern.GROUPS);
		//_board.setBrickFactory(_patternFactory);
		_board.setBrickFactory(_randomFactory);
		_board.fillTempGrid();
		//_board.setBrickFactory(_randomFactory);
		//_board.fillMainGrid();
		_boardHolder.x = _boardX;// (FlxG.width - _boardHolder.width) * .5;
		_boardHolder.y = _boardY;// (FlxG.height - _boardHolder.height) * .5;		
		add(_background);
		add(_boardHolder);
		
		_board.findBrickGroups();
		FlxG.stage.doubleClickEnabled = true;
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
			var mouseX:Int = Math.round(FlxG.mouse.screenX - _boardX);
			var mouseY:Int = Math.round(FlxG.mouse.screenY - _boardY);
			var colIndex:Int = Math.floor(_mousePressX / _brickSize);
			var rowIndex:Int = Math.floor(_mousePressY / _brickSize);			
			var diffX:Int  = mouseX - _mousePressX;
			var diffY:Int  = mouseY - _mousePressY;
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
        if (haxe.Timer.stamp()-_lastClick<DOUBLE_CLICK_TIMER) { //a double click is 2 clicks within 0.3sec
            _lastClick = 0;
            onDoubleClick();
        } else {
            _doubleClickFired = false;
            _lastClick = haxe.Timer.stamp();
			FlxTween.num(0, DOUBLE_CLICK_TIMER + 0.01, DOUBLE_CLICK_TIMER + 0.01, {complete: onSingleClick, type: FlxTween.ONESHOT });
			//FlxTween.tween(this, { }, DOUBLE_CLICK_TIMER + 0.01, { complete:onSingleClick } );
            //Actuate.timer(DOUBLE_CLICK_TIMER+0.01).onComplete(onSingleClick,[event]);
        }			
		var mouseX:Int = Math.round(FlxG.mouse.screenX - _boardX);
		var mouseY:Int = Math.round(FlxG.mouse.screenY - _boardY);
		//trace(mouseX, mouseY);
		if (mouseX >= 0 && mouseX <= _boardWidth && mouseY >= 0 && mouseY <= _boardHeight) {
			_validPress = true;
			_mousePressX = mouseX;
			_mousePressY = mouseY;
		} else {
			_validPress = false;
		}
	}
	
    function onSingleClick(tween:FlxTween):Void {
        if (_doubleClickFired) return;
        // STUFF to do on single click/tap
        trace('single click');
    }

    function onDoubleClick():Void {
        _doubleClickFired = true;
        // STUFF on double click/tap
        //trace('double click');
		if (_validPress) {
			var mouseX:Int = Math.round(FlxG.mouse.screenX - _boardX);
			var mouseY:Int = Math.round(FlxG.mouse.screenY - _boardY);
			var colIndex:Int = Math.floor(_mousePressX / _brickSize);
			var rowIndex:Int = Math.floor(_mousePressY / _brickSize);
			_board.tryDestroyGroupAt(colIndex, rowIndex);
		}
    }	
	
}