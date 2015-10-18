package stanosky.swaptris.game;
//import cpp.Void;
import stanosky.swaptris.game.anim.AnimManager;
import stanosky.swaptris.game.bricks.BrickGroup;
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
	private var _rows:Int;
	private var _columns:Int;
	private var _allRows:Int;
	private var _tempStartRowIndex:Int;
	private var _mainStartRowIndex:Int;
	private var _factory:IBrickFactory;
	private var _drawArea:FlxSpriteGroup;

	
	
	public function new(columns:Int, rows:Int, brickSize:Int, drawArea:FlxSpriteGroup) {
		if (columns < 1) throw new RangeError("Ilość kolumn musi być wieksza od zera!");
		if (rows < 1) throw new RangeError("Ilość wierszy musi być wieksza od zera!");
		_rows = rows;
		_allRows = _rows * 2;
		_columns = columns;
		_tempStartRowIndex = 0;
		_mainStartRowIndex = _allRows - _rows;
		_drawArea = drawArea;
		_brickSize = brickSize;
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
				removeBrick(c,r + startRowIndex);				
				brick = _factory.getBrick(c, r);
				if(brick != null) {
					brick.moveBrickTo(c * _brickSize,(r + startRowIndex) * _brickSize);
					_grid.addBrick(brick, c,r + startRowIndex);
					_drawArea.add(cast(brick, FlxSprite));
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
	
	public function swapBricks(brick1Col:Int, brick1Row:Int, brick2Col:Int, brick2Row:Int) {
		var cell1Exists:Bool = _grid.cellExists(brick1Col, brick1Row /*+ _mainStartRowIndex*/);
		var cell2Exists:Bool = _grid.cellExists(brick2Col, brick2Row /*+ _mainStartRowIndex*/);
		if(cell1Exists && cell2Exists) {
			var cell1Occupied:Bool = _grid.isCellOccupied(brick1Col, brick1Row /*+ _mainStartRowIndex*/);
			var cell2Occupied:Bool = _grid.isCellOccupied(brick2Col, brick2Row /*+ _mainStartRowIndex*/);
			if (cell1Occupied && cell2Occupied) {
				var brick1:IBrick = _grid.pickBrick(brick1Col, brick1Row /*+ _mainStartRowIndex*/);
				var brick2:IBrick = _grid.pickBrick(brick2Col, brick2Row /*+ _mainStartRowIndex*/);
				_grid.addBrick(brick2, brick1Col, brick1Row /*+ _mainStartRowIndex*/);
				_grid.addBrick(brick1, brick2Col, brick2Row /*+ _mainStartRowIndex*/);
				//brick1.moveBrickTo(brick2Col * _brickSize, (brick2Row /*+ _mainStartRowIndex*/) * _brickSize);
				//brick2.moveBrickTo(brick1Col * _brickSize, (brick1Row /*+ _mainStartRowIndex*/) * _brickSize);
				AnimManager.moveAnimation(brick1, brick2Col * _brickSize, (brick2Row /*+ _mainStartRowIndex*/) * _brickSize);
				AnimManager.moveAnimation(brick2, brick1Col * _brickSize, (brick1Row /*+ _mainStartRowIndex*/) * _brickSize);
			}
		}
	}
	
	public function findBrickGroups():Void {
		var groups:Array<BrickGroup> = [];
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
						trace("brick", brick);
						group = tryFindGroupForBrick(brick);
						if (group != null) groups.push(group);
						tempIndex++;
					}
				}
			}
		}
		trace("created groups:", groups.length);
	}
	
	private function tryFindGroupForBrick(brick:IBrick):BrickGroup {
		var tempGroup:Array<IBrick> = [];
		findNextSameTypeNeighbour(brick, tempGroup);
		if (tempGroup.length == 4) return new BrickGroup(tempGroup);
		return null;
	}
	
	private function findNextSameTypeNeighbour(brick:IBrick, output:Array<IBrick>):Void {
		var neighbours:Array<IBrick> = getBrickNeighbours(brick);
		var currentNeighbour:Int = 0;
		var nBrick:IBrick;//reprezentuje kostke sąsiada
		output.push(brick);
		while (currentNeighbour < neighbours.length && output.length < 4) {
			nBrick = neighbours[currentNeighbour];
			if (nBrick.getGroup() == -1	&& brick.getColor() == nBrick.getColor() && nBrick.getTempGroup() == -1) {
				trace(currentNeighbour, nBrick);
				nBrick.setTempGroup(brick.getTempGroup());
				findNextSameTypeNeighbour(nBrick,output);
			}
			++currentNeighbour;
		}
	}
	
	private function getBrickNeighbours(brick:IBrick):Array<IBrick> {
		var output:Array<IBrick> = [];
		var col:Int = brick.getCol();
		var row:Int = brick.getRow();
		if (_grid.cellExists(col, row) && _grid.isCellOccupied(col, row)) {
			//ta linia jest raczej niepotrzebna, bo bdziemy raczej przeszukiwać tylko w dół
			//if (_grid.isCellOccupied(col, row - 1)) output.push(_grid.getBrick(col, row - 1));
			if (_grid.isCellOccupied(col - 1, row)) output.push(_grid.getBrick(col - 1, row));			
			if (_grid.isCellOccupied(col + 1, row)) output.push(_grid.getBrick(col + 1, row));
			if (_grid.isCellOccupied(col, row + 1)) output.push(_grid.getBrick(col, row + 1));
			
		}
		return output;
	}
	

	
}