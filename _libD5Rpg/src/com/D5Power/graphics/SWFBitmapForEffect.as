package com.D5Power.graphics
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.Timer;
    
    public class SWFBitmapForEffect extends Sprite
    {
        public var TFXML:TextField;
        public var list:Array;
        public var xml:XML;
        
        private var _bmp:Bitmap
        private var _timer:Timer;
        private var _loopTime:uint ;
        private var _crtPoint:uint;
        private var _totalFrames:uint;
        
        public function SWFBitmapForEffect()
        {
            super();
            
            xml = XML(TFXML.text);
            _loopTime = xml.@time;
            
            list = parse(new D5BitmapData(),xml.@cols,xml.@rows);
            play();
        }
        
        private function parse(targetBMD:BitmapData,cols:uint,rows:uint):Array
        {
            
            var _width:int = int(targetBMD.width/cols);
            var _height:int = int(targetBMD.height/rows);
            var arr:Array = [];
            
            for(var i:int=0;i<rows;++i)
            {
                for(var j:int=0;j<cols;++j)
                {
                    var temp:BitmapData = new BitmapData(_width,_height);
                    temp.copyPixels(targetBMD,new Rectangle(j*_width,i*_height,_width,_height),new Point(0,0));
                    arr.push(temp);
                }
            }
            
            _totalFrames = arr.length;
            
            return arr;
        }
        
        private function play():void
        {
            _bmp = new Bitmap();
            _bmp.x = xml.@x;
            _bmp.y = xml.@y;
            _bmp.blendMode = BlendMode.ADD;
            this.addChild(_bmp);
            _timer = new Timer(_loopTime);
            _timer.addEventListener(TimerEvent.TIMER,onTimerLoop);
            _timer.start();	
        }
        
        private function onTimerLoop(e:TimerEvent):void
        {
            if(_crtPoint == _totalFrames - 1) _crtPoint = 0;
            //			_bmd = _bmdVec[_crtPoint++];
            _bmp.bitmapData = list[_crtPoint++];
        }
        
    }
}