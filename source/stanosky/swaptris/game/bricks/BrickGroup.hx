package stanosky.swaptris.game.bricks;

/**
 * ...
 * @author ...
 */
class BrickGroup
{
	private static var UNIQUE_COUNTER:Int = 0;
	private var _members:Array<IBrick>;
	private var _id:Int;
	

	public function new(members:Array<IBrick>) {
		_members = members;
		_id = UNIQUE_COUNTER++;
		init();
	}
	
	function init() {
		var brick:IBrick;
		for (i in 0..._members.length) {
			brick = _members[i];
			brick.setGroup(_id);
		}
	}
	
	public function destroy():Void {
		var brick:IBrick;
		for (i in 0..._members.length) {
			brick = _members[i];
			brick.setGroup(-1);
		}
		brick = null;
		_members = null;
	}
}