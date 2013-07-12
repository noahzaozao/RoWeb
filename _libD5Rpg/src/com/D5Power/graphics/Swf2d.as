package com.D5Power.graphics
{
    import com.D5Power.net.D5StepLoader;
    
    import flash.display.Bitmap;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.geom.Matrix;
    import flash.utils.getTimer;
    
    public class Swf2d implements ISwfDisplayer
    {
        private var _list:Array;
        private var _xml:XML;
        private var _time:int = 0;
        private var _bmd:Bitmap;
        private var _frame:int = 0;
        private var _shadow:Shape;
        
        public function Swf2d()
        {
            _bmd = new Bitmap();
            _shadow = new Shape();
            super();
        }
        
        public function set direction(v:int):void
        {
            
        }
        
        public function set action(v:int):void
        {
            
        }
        
        public function get monitor():Bitmap
        {
            return _bmd;
        }
        
        public function get shadow():Shape
        {
            return _shadow;
        }
        
        public function changeSWF(file:String,needMirror:Boolean=false):void
        {
            if(_bmd)
            {
                _bmd.bitmapData = null;
                
                _list = null;
                _xml = null;
            }
            
            if(_shadow)
            {
                _shadow.graphics.clear();
            }
            
            _frame = 0;
            D5StepLoader.me.addLoad(file,onComplate,true,D5StepLoader.TYPE_SWF);
        }
        
        public function renderMe():void
        {
            if(_xml==null) return;
            var cost_time:Number = (getTimer() - _time) / int(_xml.@Time);
            if (_frame != cost_time)
            {
                _frame = cost_time;
                _bmd.bitmapData = _list[int(cost_time % _list.length)];
            }
        }
        
        public function set scaleX(v:Number):void
        {
            _bmd.scaleX = v;
            if(!_xml) return;
            if(v<0)
            {
                _bmd.x = int(_xml.@X)-_bmd.width*v;
            }else{
                _bmd.x = int(_xml.@X);
            }
        }
        
        /**
         * 初始化播放器
         */ 
        private function initPlay():void
        {
            if (_list.length == 0) return;
            
            
            
            _time = getTimer();
            
            
            _bmd.bitmapData = _list[0];
            
            
            var px:int=_bmd.scaleX>0 ? 0 : _bmd.width;
            var py:int;
            
            
            _bmd.x = int(_xml.@X) + px;
            _bmd.y = int(_xml.@Y) + py;
            
            
            var matr:Matrix = new Matrix();
            matr.createGradientBox(50, 30,0,-25,-15);
            _shadow.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0],[0,255],matr);
            _shadow.graphics.drawEllipse(-25, -15, 50, 30);
            _shadow.scaleX = Number(_xml.@shadowX) * 0.01;
            _shadow.scaleY = Number(_xml.@shadowY) * 0.01;
            //			
            //			
            //			var hitWidth:uint = int(_xml.@hitWidth);
            //			var hitHeight:uint = int(_xml.@hitHeight);
            //			var hitter:Sprite = new Sprite();
            //			hitter.x = px;
            //			hitter.y = py;
            //			hitter.graphics.lineStyle(1, 26316);
            //			hitter.graphics.drawRect(-hitWidth, -hitHeight, hitWidth * 2, hitHeight * 2);
            
            
            //if(!contains(_shadow))addChild(_shadow);
            //if(!contains(_bmd))addChild(_bmd);
            
            //addChild(hitter);
        }
        
        
        private function onComplate(data:Object):void
        {
            _list = data.list;
            _xml = data.xml;
            initPlay();
        }
        
        public function set isPlayEnd( value:Boolean ):void
        {
        }
        public function get isPlayEnd():Boolean
        {
            return false;
        }
        public function setChooseCircle( bool:Boolean ):void
        {
            
        }
    }
}