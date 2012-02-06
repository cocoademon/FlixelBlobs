package  
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	/**
	 * ...
	 * @author Cameron Foale
	 */
	public class WaterGroup extends BlobbyGroup 
	{
		private var _offset:uint = 2;
		private var _offsetPoint:Point;
		private var _highlightMatrix:Matrix;
		
		public function WaterGroup(MaxSize:uint=0, BlobColour:uint=0xFFFF0000, BlobThreshold:uint = 0x20, Offset:uint = 3) 
		{
			super(MaxSize, BlobColour, BlobThreshold);
			
			_offset = Offset;
			_offsetPoint = new Point(_offset, _offset);
			
			_highlightMatrix = new Matrix();
			_highlightMatrix.translate(_offset, _offset);
		}
		
		override protected function _createCameraData(Camera:FlxCamera):Object 
		{
			var obj:Object = super._createCameraData(Camera);
			
			var filterRect:Rectangle = obj.rect;
			
			var highlightBuffer:BitmapData = new BitmapData(Camera.buffer.width, Camera.buffer.height, true, 0x00);
			var blurBuffer:BitmapData = new BitmapData(filterRect.width + _offset, filterRect.height + _offset, true, 0x00);
			
			obj['highlightBuffer'] = highlightBuffer;
			obj['blurBuffer'] = blurBuffer;
			return obj;
		}
		
		override protected function _postProcess(Camera:FlxCamera):void 
		{
			var blob:Object = _blobBuffers[Camera];
			var buffer:BitmapData = blob.buffer;
			
			var blur:BlurFilter = blob.data.filter;
			var highlightBuffer:BitmapData = blob.data.highlightBuffer;			
			var blurBuffer:BitmapData = blob.data.blurBuffer;
			var filterRect:Rectangle = blob.data.rect;
			
			var blurBufferRect:Rectangle = new Rectangle(_offset, _offset, buffer.width, buffer.height);
			
			// create the blurred buffer
			// blurBuffer.fillRect(blurBuffer.rect, 0x00);
			blurBuffer.applyFilter(buffer, buffer.rect, _offsetPoint, blur);
			
			buffer.fillRect(buffer.rect, 0x00);
			buffer.threshold(blurBuffer, blurBufferRect, _zeroPoint, '>', _blobThreshold << 24, _blobColour, 0xFF000000, false);
			
			highlightBuffer.copyPixels(blurBuffer, blurBufferRect, _zeroPoint);
			highlightBuffer.draw(blurBuffer, _highlightMatrix, null, BlendMode.SUBTRACT);
			buffer.threshold(highlightBuffer, highlightBuffer.rect, _zeroPoint, '>', (_blobThreshold ) << 16, 0xFFFFFFFF, 0x00FF0000, false);
			
			// buffer.threshold(buffer, buffer.rect, _zeroPoint, '<', _blobThreshold << 24 , 0x0000000, 0xFF000000, false);
			Camera.buffer.copyPixels(buffer, buffer.rect, _zeroPoint, null, null, true);
		}
		
	}

}