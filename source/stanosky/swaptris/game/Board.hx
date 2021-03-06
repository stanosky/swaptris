package stanosky.swaptris.game;

import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.events.Event;
import stanosky.swaptris.game.bricks.BrickGroup;
import stanosky.swaptris.game.bricks.Cell;
import stanosky.swaptris.game.bricks.IBrick;
import stanosky.swaptris.game.bricks.IBrickFactory;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import openfl.errors.RangeError;
import stanosky.swaptris.game.Grid;

/**
 * ...
 * @author Krzysztof Stano
 */
 
class Board 
{
	
	private var _grid:Grid;
	private var _brickSize:Int;
	private var _x:Int;
	private var _y:Int;
	private var _rows:Int;
	private var _columns:Int;
	private var _allRows:Int;
	private var _minGroupSize:Int = 3;
	private var _tempStartRowIndex:Int;
	private var _mainStartRowIndex:Int;
	private var _factory:IBrickFactory;
	private var _drawArea:FlxSpriteGroup;
	private var _groups:Array<BrickGroup>;
	private var _toDestroy:Array<IBrick>;
	private var _moveAnimNum:Int = 0;
	private var _removeAnimNum:Int = 0;
	private var _fallAnimNum:Int = 0;
	private var _isReady:Bool = false;
	private var _swapSound:FlxSound;
	
	
	
	public function new(x:Int,y:Int,columns:Int, rows:Int, brickSize:Int, drawArea:FlxSpriteGroup) {
		if (columns < 1) throw new RangeError("Ilość kolumn musi być wieksza od zera!");
		if (rows < 1) throw new RangeError("Ilość wierszy musi być wieksza od zera!");
		_x = x;
		_y = y;
		_rows = rows;
		_allRows = _rows * 2;
		_columns = columns;
		_tempStartRowIndex = 0;
		_mainStartRowIndex = _allRows - _rows;
		_drawArea = drawArea;
		_brickSize = brickSize;
		_toDestroy = [];
		_groups = [];
		//_animManager = new AnimManager();
		_swapSound = FlxG.sound.load(AssetPaths.swap__wav);
		_grid = new Grid(_columns, _allRows);
		
	}
	
	public function clearTempGrid() {
		clearGrid(_tempStartRowIndex);
	}
	
	public function clearMainGrid() {
		clearGrid(_mainStartRowIndex);
	}
	
	public function setBrickFactory(factory:IBrickFactory) {
		_factory = factory;
	}
	
	public function fillTempGrid() {
		fillGrid(_tempStartRowIndex);
	}
	
	public function fillMainGrid() {
		fillGrid(_mainStartRowIndex);		
	}
	
	private function fillGrid(startRowIndex:Int) {
		var brick:IBrick;
		for (c in 0..._columns) {
			for (r in 0..._rows) {
				//removeBrick(c,r + startRowIndex);
				if (!_grid.isCellOccupied(c, r + startRowIndex)) {
					brick = _factory.getBrick(c, r);
					if(brick != null) {
						brick.moveBrickTo(c * _brickSize,(r + startRowIndex) * _brickSize);
						_grid.addBrick(brick, c,r + startRowIndex);
						_drawArea.add(cast(brick, FlxSprite));
					}
				}
			}
		}
	}
	
	private function clearGrid(startRowIndex:Int) {
		for (c in 0..._columns) {
			for (r in 0..._rows) {
				removeBrick(c,r + startRowIndex);
			}
		}		
	}
	
	private function removeBrick(col:Int,row:Int) {
		var brick:IBrick = _grid.getBrick(col,row);
		if(brick != null) {
			_drawArea.remove(cast(brick,FlxSprite));
			_grid.removeBrick(col,row);
		}		
	}
	
	public function swapBricks(brick1Col:Int, brick1Row:Int, brick2Col:Int, brick2Row:Int):Void {
		//GameDispatcher.dispatchEvent(new Event(GameEvent.BOARD_BUSY));
		var cell1Exists:Bool = _grid.cellExists(brick1Col, brick1Row /*+ _mainStartRowIndex*/);
		var cell2Exists:Bool = _grid.cellExists(brick2Col, brick2Row /*+ _mainStartRowIndex*/);
		//trace("1:", cell1Exists , cell2Exists);
		if(cell1Exists && cell2Exists) {
			var cell1Occupied:Bool = _grid.isCellOccupied(brick1Col, brick1Row /*+ _mainStartRowIndex*/);
			var cell2Occupied:Bool = _grid.isCellOccupied(brick2Col, brick2Row /*+ _mainStartRowIndex*/);
			//trace("2:", cell1Occupied , cell2Occupied);
			if (cell1Occupied && cell2Occupied) {
				//najpierw pobieramy tylko referencje do kostek ale nie usuwamy z tablicy
				var brick1:IBrick = _grid.getBrick(brick1Col, brick1Row /*+ _mainStartRowIndex*/);
				var brick2:IBrick = _grid.getBrick(brick2Col, brick2Row /*+ _mainStartRowIndex*/);
				var b1Group:Int = brick1.getGroup();
				var b2Group:Int = brick2.getGroup();
				//trace("3:",brick1.getGroup() , brick2.getGroup());
				if (brick1.getColor() != brick2.getColor() && (b1Group != b2Group || (b1Group == -1 && b2Group == -1))) {
					if (b1Group > -1) ungroupById(b1Group);
					if (b2Group > -1) ungroupById(b2Group);
					//dopiero teraz "zdejmujemy" kostki z tablicy i zamieniamy miejscami
					brick1 = _grid.pickBrick(brick1Col, brick1Row /*+ _mainStartRowIndex*/);
					brick2 = _grid.pickBrick(brick2Col, brick2Row /*+ _mainStartRowIndex*/);					
					_grid.addBrick(brick2, brick1Col, brick1Row /*+ _mainStartRowIndex*/);
					_grid.addBrick(brick1, brick2Col, brick2Row /*+ _mainStartRowIndex*/);
					createMoveAnimaton(brick1, _x + brick2Col * _brickSize, _y + (brick2Row /*+ _mainStartRowIndex*/) * _brickSize);
					createMoveAnimaton(brick2, _x + brick1Col * _brickSize, _y + (brick1Row /*+ _mainStartRowIndex*/) * _brickSize);
					_swapSound.play();
				} else {
					//dźwiek odmowy i być może animacja pokazująca niemożność zamiany kostek
				}
			}
		}
	}
	
	private function createMoveAnimaton(brick:IBrick, x:Float, y:Float):Void {
		_moveAnimNum++;
		FlxTween.tween(brick, { x:x, y:y }, .2, {ease:FlxEase.quadInOut , complete:onMoveAnimComplete} );
	}
	
	private function onMoveAnimComplete(tween:FlxTween) {
		if (--_moveAnimNum == 0) {
			trace("koniec animacji ruchu");
			//ungroupAll();
			findBrickGroups();
			destroyAllGroups();
			moveBricksDown();
			//GameDispatcher.dispatchEvent(new Event(GameEvent.BOARD_READY));
		}
	}
	
	public function findBrickGroups():Void {
		var group:BrickGroup;
		var tempIndex:Int = 0;
		var brick:IBrick;

		for (r in 0..._allRows) {
			for (c in 0..._columns) {
				brick = _grid.getBrick(c, r);
				if(brick != null) {
					//upewniamy sie, że kostka nie nalezy do zadnej grupy
					if (brick.getGroup() == -1) {
						//nadajemy kostce tymczasowy index grupy
						brick.setTempGroup(tempIndex);
						//trace("brick", brick);
						group = tryFindGroupForBrick(brick);
						if (group != null) _groups.push(group);
						tempIndex++;
					}
				}
			}
		}
		//trace("created groups:", _groups.length);
	}
	
	private function tryFindGroupForBrick(brick:IBrick):BrickGroup {
		var tempGroup:Array<Cell> = [];
		var cell:Cell;
		var tmpBrick:IBrick;
		findNextSameTypeNeighbour(brick, tempGroup);
		if (tempGroup.length == 4) {
		//if (tempGroup.length >= _minGroupSize) {
			var bGroup:BrickGroup = new BrickGroup();
			for (j in 0...tempGroup.length) {
				cell = tempGroup[j];
				tmpBrick = _grid.getBrick(cell.col, cell.row);
				tmpBrick.setTempGroup( -1);
				tmpBrick.setGroup(bGroup.getId());
				bGroup.addCell(cell);
			}
			return bGroup;
		} else {
			for (i in 0...tempGroup.length) {
				cell = tempGroup[i];
				tmpBrick = _grid.getBrick(cell.col, cell.row);
				tmpBrick.setTempGroup( -1);
			}
		}
		return null;
	}
	
	private function findNextSameTypeNeighbour(brick:IBrick, output:Array<Cell>):Void {
		var neighbours:Array<IBrick> = getBrickNeighbours(brick,true);
		var currentNeighbour:Int = 0;
		var nBrick:IBrick;//reprezentuje kostke sąsiada
		output.push({col:brick.getCol(),row:brick.getRow()});
		while (currentNeighbour < neighbours.length && output.length < 4) {
			nBrick = neighbours[currentNeighbour];
			if (nBrick.getGroup() == -1	&& brick.getColor() == nBrick.getColor() && nBrick.getTempGroup() == -1) {
				//trace(currentNeighbour, nBrick);
				nBrick.setTempGroup(brick.getTempGroup());
				findNextSameTypeNeighbour(nBrick,output);
			}
			++currentNeighbour;
		}
	}
	
	private function getBrickNeighbours(brick:IBrick,all:Bool = false):Array<IBrick> {
		var col:Int = brick.getCol();
		var row:Int = brick.getRow();
		return getCellNeighbours(col,row,all);
	}
	
	private function getCellNeighbours(col:Int, row:Int,all:Bool = false):Array<IBrick> {
		var output:Array<IBrick> = [];
		if (_grid.cellExists(col, row) && _grid.isCellOccupied(col, row)) {
			//pierwsza kostka jest zwracana jedynie jeśli chcemy znać wszystkich sąsiadów, do innych zastosowań wystarczą pozostałe 3
			if (_grid.isCellOccupied(col, row - 1) && all) output.push(_grid.getBrick(col, row - 1));
			if (_grid.isCellOccupied(col - 1, row)) output.push(_grid.getBrick(col - 1, row));			
			if (_grid.isCellOccupied(col + 1, row)) output.push(_grid.getBrick(col + 1, row));
			if (_grid.isCellOccupied(col, row + 1)) output.push(_grid.getBrick(col, row + 1));
			
		}
		return output;
	}
	
	public function tryDestroyGroupAt(col:Int, row:Int):Void {
		if (_grid.isCellOccupied(col, row)) {
			var brick:IBrick = _grid.getBrick(col, row);
			var brickGroup:Int = brick.getGroup();
			if (brickGroup >= 0) {
				destroyGroupById(brickGroup);
				moveBricksDown();
			}
		} else {
			trace("kostka jest pusta albo nie jest w grupie");
		}
	}
	
	private function destroyGroupById(groupId:Int):Void {
		var groupIndex:Int = findGroupIndexById(groupId);
		if (groupIndex > -1) {
			var group:BrickGroup = _groups.splice(groupIndex, 1)[0];
			destroyGroup(group);
		}
	}
	
	private function destroyGroup(group:BrickGroup):Void {
		var cells:Array<Cell> = group.getCells();
		for (i in 0...cells.length) {
			destroyBrickInCell(cells[i]);
		}
		group.destroy();		
	}
	
	private function destroyAllGroups():Void {
		var len:Int = _groups.length;
		for (i in 0...len) {
			destroyGroup(_groups.pop());
		}
	}	
	
	private function findGroupIndexById(groupId:Int):Int {
		for (i in 0..._groups.length) {
			if (_groups[i].getId() == groupId) return i;
		}
		return -1;
	}
	
	private function destroyBrickInCell(cell:Cell):Void {
		var brick:IBrick = _grid.pickBrick(cell.col, cell.row);
		if(brick != null) {
			_removeAnimNum++;
			_toDestroy.push(brick);
			FlxTween.tween(brick, { alpha:0 }, .2, { ease:FlxEase.quadInOut , complete:onRemoveAnimComplete } );
		}
	}
	
	private function onRemoveAnimComplete(tween:FlxTween) {
		if (--_removeAnimNum == 0) {
			var brick:IBrick;
			var col:Int;
			var row:Int;
			for (i in 0..._toDestroy.length) {
				brick = _toDestroy.pop();
				_drawArea.remove(cast(brick,FlxSprite), true);
				brick.destroy();
			}
		}
		trace("_toDestroy.length", _toDestroy.length);
	}
	
	private function moveBricksDown():Void {
		var shift:Array<Int> = [];
		var brick:IBrick;
		var rowIndex:Int;
		for (c in 0..._columns) {
			shift.push(0);
			for (r in 0..._allRows) {
				rowIndex = _allRows - r - 1;
				brick = _grid.getBrick(c, rowIndex);
				if (brick != null) {
					if (shift[c] > 0) {
						if (brick.getGroup() >= -1) ungroupById(brick.getGroup());
						moveBrickDown(c, rowIndex, shift[c]);
					}
				} else {
					shift[c]++;
				}
			}
		}
	}
	
	private function ungroupById(groupId:Int):Void {
		var groupIndex:Int = findGroupIndexById(groupId);
		ungroupByIndex(groupIndex);
	}
	
	private function ungroupByIndex(groupIndex:Int):Void {
		if (groupIndex > -1) {
			var group:BrickGroup = _groups.splice(groupIndex, 1)[0];
			var cells:Array<Cell> = group.getCells();
			var brick:IBrick;
			for (i in 0...cells.length) {
				brick =	_grid.getBrick(cells[i].col, cells[i].row);
				brick.setTempGroup( -1);
				brick.setGroup( -1);
			}
			group.destroy();
		}			
	}
	
	private function ungroupAll():Void {
		var len:Int = _groups.length;
		var current:Int = len;
		for (i in 0...len) {
			//trace("group index:", i);
			ungroupByIndex(--current);
		}
	}
	
	private function moveBrickDown(col:Int, row:Int, shift:Int):Void {
		var brick:IBrick = _grid.pickBrick(col, row);
		_fallAnimNum++;
		_grid.addBrick(brick, col, row + shift);
		FlxTween.tween(brick, {y:_y + (row + shift) * _brickSize }, .1 * shift, {ease:FlxEase.quadInOut , complete:onFallAnimComplete} );
		
	}
	
	private function onFallAnimComplete(tween:FlxTween) {
		if (--_fallAnimNum == 0) {
			trace("fall animation end");
			ungroupAll();
			findBrickGroups();
			fillTempGrid();
			if (_groups.length > 0) {
				destroyAllGroups();
				moveBricksDown();
			}
		}
	}
}