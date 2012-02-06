package
{

	import org.flixel.*;

	public class MenuState extends FlxState
	{
		
		/**
		 * The emitter is going to generate a spray of particles
		 */
		private var _emitter:FlxEmitter;
		
		/**
		 * A group the applies the blobby effect to its members
		 */
		private var _blobs:FlxGroup;
		
		/**
		 * How many particles to set up
		 */
		private const _NUM_PARTICLES:uint = 60;

		override public function create():void
		{
			FlxG.bgColor = 0xFF334422;

			var t:FlxText;

			t = new FlxText(0,FlxG.height/3-10,FlxG.width,"Text behind blobs");
			t.size = 16;
			t.alignment = "center";
			add(t);
			
			_blobs = new BlobbyGroup();
			
			_emitter = new FlxEmitter(FlxG.width / 2, FlxG.height / 2, 0);
			for (var i:int = 0; i < _NUM_PARTICLES; ++i)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(5, 5, 0xFFFF3000);
				particle.exists = false;
				_emitter.add(particle);
			}
			
			// turn off emitter rotations
			_emitter.setRotation(0, 0);
			
			_emitter.start(false, 1, 1.0 / 60.0);
			
			_blobs.add(_emitter);
			
			add(_blobs);
			
			t = new FlxText(0,FlxG.height* 2/3-10,FlxG.width,"Text in front of blobs");
			t.size = 16;
			t.alignment = "center";
			add(t);
			
			FlxG.mouse.show();
		}

		override public function update():void
		{
			super.update();
			
			_emitter.x = FlxG.mouse.x - _emitter.width / 2;
			_emitter.y = FlxG.mouse.y - _emitter.height / 2;
		}

	}

}

