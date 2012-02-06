package  
{
	import com.greensock.data.BlurFilterVars;
	import flash.display.BitmapData;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Cameron Foale
	 */
	public class BlobbyGroup extends FlxGroup 
	{
		protected var _blobBuffers:Dictionary;
		protected var _zeroPoint:Point;
		
		protected var _blobColour:uint;
		protected var _blobThreshold:uint;
		
		public function BlobbyGroup(MaxSize:uint=0, BlobColour:uint = 0xFFFF0000, BlobThreshold:uint = 0x20) 
		{
			super(MaxSize);
			
			_blobColour = BlobColour;
			_blobThreshold = BlobThreshold;
			
			_zeroPoint = new Point(0, 0);
			_blobBuffers = new Dictionary(true);
		}
		
		private function _clearCameraBuffers():void
		{
			for each(var camera:FlxCamera in cameras)
			{
				camera.buffer.fillRect(camera.buffer.rect, 0x00);
			}
		}
		
		protected function _createCameraData(Camera:FlxCamera):Object
		{
			var data:Object = { };
			var filter:BlurFilter = new BlurFilter(10, 10, 3);
			var filterRect:Rectangle = Camera.buffer.generateFilterRect(Camera.buffer.rect, filter);
			data['filter'] = filter;
			data['rect'] = filterRect;
			return data;
			
			
		}
		
		private function _swapCameraBuffers():void
		{
			for each(var camera:FlxCamera in cameras)
			{
				if (! (camera in _blobBuffers))
				{
					_blobBuffers[camera] = {
						'buffer': new BitmapData(camera.buffer.width, camera.buffer.height, true, 0x00),
						'data': _createCameraData(camera)
					}
				}
				
				var tmpBuffer:BitmapData = camera.buffer;
				camera.buffer = _blobBuffers[camera].buffer;
				_blobBuffers[camera].buffer = tmpBuffer;
			}
		}
		
		protected function _postProcess(Camera:FlxCamera):void
		{
			var blob:Object = _blobBuffers[Camera];
			var blur:BlurFilter = blob.data.filter;
			var buffer:BitmapData = blob.buffer;
			buffer.applyFilter(buffer, buffer.rect, _zeroPoint, blur);
			buffer.threshold(buffer, buffer.rect, _zeroPoint, '>', _blobThreshold << 24, _blobColour, 0xFF000000, false);
			buffer.threshold(buffer, buffer.rect, _zeroPoint, '<', _blobThreshold << 24 , 0x0000000, 0xFF000000, false);
			Camera.buffer.copyPixels(buffer, buffer.rect, _zeroPoint, null, null, true);
		}
		
		/**
		 * Create a mashup of the FlxGroup drawing and the 
		 */
		override public function draw():void 
		{
			// Set up which cameras to use if none are set
			if (cameras == null)
				cameras = FlxG.cameras;
				
			// Now, go through all of those cameras and switch them to a different screen buffer
			_swapCameraBuffers();
			
			// then empty them
			_clearCameraBuffers();
			
			// then render using the parent code
			super.draw();
			
			// then restore all the camera buffers
			_swapCameraBuffers();
			
			// and draw the new ones over the top
			for each(var camera:FlxCamera in cameras)
			{
				_postProcess(camera);
			}
		}
		
	}

}