package stanosky.swaptris.game.engine;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import stanosky.swaptris.game.Board;
import stanosky.swaptris.game.bricks.IBrick;

/**
 * ...
 * @author k.stano
 */
class LoopInput implements ILoop
{
	private var _board:Board;
	private var _boardX:Int;
	private var _boardY:Int;
	private var _boardWidth:Int;
	private var _boardHeight:Int;	
	private var _brickSize:Int;
	
	private var _mousePressX:Int;
	private var _mousePressY:Int;	
	private var _validPress:Bool = false;
	private var _swapSound:FlxSound;
	
	//double click stuff
	private var _lastClick:Float=0;
    private var _doubleClickFired:Bool = false;
    private static inline var DOUBLE_CLICK_TIMER = 0.2; //seconds to determine a double click/tap	
	
	public function new(board:Board,boardX:Int,boardY:Int,boardWidth:Int,boardHeight:Int,brickSize:Int) {
		_board = board;
		_boardX = boardX;
		_boardY = boardY;
		_boardWidth = boardWidth;
		_boardHeight = boardHeight;
		_brickSize = brickSize;
		_swapSound = FlxG.sound.load(AssetPaths.swap__wav);
		FlxG.stage.doubleClickEnabled = true;
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
	
    private function onSingleClick(tween:FlxTween):Void {
        if (_doubleClickFired) return;
        // STUFF to do on single click/tap
        trace('single click');
    }

    private function onDoubleClick():Void {
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
	
	/* INTERFACE stanosky.swaptris.game.engine.ILoop */
	
	public function update():Void {
		if (FlxG.mouse.justPressed) onMousePress();
		if (FlxG.mouse.justReleased) onMouseRelease();
	}
	
}