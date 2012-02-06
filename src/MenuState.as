package

{

	import org.flixel.*;



	public class MenuState extends FlxState

	{

		override public function create():void
		{
			FlxG.bgColor = 0xFF334422;

			var t:FlxText;

			t = new FlxText(0,FlxG.height/2-10,FlxG.width,"Here are some blobs");

			t.size = 16;

			t.alignment = "center";

			add(t);

			FlxG.mouse.show();
		}

		override public function update():void
		{
			super.update();
		}

	}

}

