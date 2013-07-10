package com.D5Power.graphics
{
    import com.D5Power.net.D5StepLoader;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.Shape;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.getTimer;
    
    public class Swf2p5 implements ISwfDisplayer
    {
        private var _lib:Array;
        private var _colorLib:Array;
        private var _list:Vector.<BitmapData>;
        private var _xml:XML;
        private var _time:int = 0;
        private var _bmd:Bitmap;
        private var _frame:int = 0;
        private var _shadow:Shape;
        private var _direction:uint;
        private var _playFrame:uint;
        private var _loop:Boolean=true;
        private var _totalFrame:uint;
        private var _colorArr:Array = [96,20,255];
        
        public function Swf2p5()
        {
            _bmd = new Bitmap();
            _shadow = new Shape();
            super();
        }
        
        public function dispose():void
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
        
        public function set direction(v:int):void
        {
            if(v<0) v = 4-v; // 在SWF2P5素材中，镜像数据是保存在数组末尾的。因此通过4-V刚好获得各方向的反向数据。相关处理请参考SWFBitmap2P5D.as
            
            if(_lib==null)
            {
                _direction = v;
                return;
            }
            if(_direction==v) return;
            
            
            _direction = v;
            _list = _lib[_direction];
        }
        
        public function set loop(b:Boolean):void
        {
            _loop = b;
        }
        
        public function set action(v:int):void
        {
            
        }
        
        public function get playFrame():uint
        {
            return _playFrame;
        }
        
        public function get totalFrame():uint
        {
            return _totalFrame;
        }
        
        public function changeSWF(file:String,needMirror:Boolean=false):void
        {
            if(_bmd)
            {
                _bmd.bitmapData = null;
                
                _lib = null;
                _list = null;
                _xml = null;
            }
            
            if(_shadow)
            {
                _shadow.graphics.clear();
                _shadow = null;
            }
            
            _frame = 0;
            D5StepLoader.me.addLoad(file,onComplate,true,D5StepLoader.TYPE_SWF);
        }
        
        public function render():void
        {
            if(_xml==null || (!_loop && _playFrame==int(_xml.@Frame)-1)) return;
            
            var cost_time:Number = (getTimer() - _time) / int(_xml.@Time);
            
            if (_frame != cost_time)
            {
                _playFrame = int(cost_time % _list.length);
                _frame = cost_time;
                _bmd.bitmapData = _list[_playFrame];
            }
        }
        
        /**
         * 初始化播放器
         */ 
        private function initPlay():void
        {
            if (_list.length == 0) return;
            
            var px:int;
            var py:int;
            
            _time = getTimer();
            
            if(_bmd==null) _bmd = new Bitmap(null, "auto", true);
            
            
            _bmd.bitmapData = _list[0];
            _bmd.x = int(_xml.@X) + px;
            _bmd.y = int(_xml.@Y) + py;
            
            
            if(_shadow==null) _shadow = new Shape();
            var matr:Matrix = new Matrix();
            matr.createGradientBox(50, 30,0,-25,-15);
            _shadow.graphics.beginGradientFill(GradientType.RADIAL,[0,0],[1,0],[0,255],matr);
            _shadow.graphics.drawEllipse(-25, -15, 50, 30);
            _shadow.x = px;
            _shadow.y = py;
            _shadow.scaleX = Number(_xml.@shadowX) * 0.03;
            _shadow.scaleY = Number(_xml.@shadowY) * 0.03;
            
            
            
            //if(!contains(_shadow))addChild(_shadow);
            //if(!contains(_bmd))addChild(_bmd);
            
            //addChild(hitter);
        }
        
        private function createColorfulSkin(list:Vector.<BitmapData>):Vector.<BitmapData>
        {
            var nlist:Vector.<BitmapData> = new Vector.<BitmapData>;
            var bmd:BitmapData;
            for(var i:uint=0,len:uint=list.length;i<len;++i)
            {
                bmd = list[i].clone();
                bmd.colorTransform(new Rectangle(0,0,bmd.width,bmd.height), new ColorTransform(1,1,1,1,_colorArr[0],_colorArr[1],_colorArr[2]));
                nlist[i] = bmd;
            }
            return nlist;
        }
        
        private function onComplate(data:Object):void
        {
            _lib = data.list;
            _colorLib = data.colorSkinList;
            _list = _lib[_direction];
            //			_colorList = _colorLib[_direction];
            //_colorListCopy = createColorfulSkin(_colorLib[_direction]);
            _xml = data.xml;
            _totalFrame = int(_xml.@Frame)-1;
            initPlay();
        }
    }
}