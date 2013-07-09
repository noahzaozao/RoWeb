package lib
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	public class SampleStats extends Sprite
	{
		private var _frame:uint = 0;
		private var _lastFrameTime:uint = 0;
		private var _nowFrameTime:uint = 0;
		private var _frameCount:uint = 0;
		
		private var _info:TextField;
		
		public function SampleStats()
		{
			addEventListener(Event.ADDED_TO_STAGE,setup);
		}
		
		private function setup(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,setup);
			
			_info = new TextField();
			_info.selectable=false;
			_info.width = 120;
			_info.height = 20;
			_info.backgroundColor=0xffffff;
			_info.background=true;
			addChild(_info);
			
			
			addEventListener(Event.ENTER_FRAME,update);
		}
		
		private function update(e:Event):void
		{
			_nowFrameTime = getTimer();
			if(_nowFrameTime-_lastFrameTime>=1000)
			{
				_frame = _frameCount;
				_frameCount = 0;
				_lastFrameTime = _nowFrameTime;
				_nowFrameTime = 0;
			}else{
				_frameCount++;
			}
			
			_info.text = "FPS:"+_frame;
			
		}
	}
}