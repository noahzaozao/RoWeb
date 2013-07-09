package com.D5Power.graphics
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.utils.getTimer;
    
    public class SWFBitmap2P5D extends Sprite
    {
        public var TFXML:TextField;
        private var _resource:BitmapData;
        private var _list:Array;
        private var _colorSkinList:Array;
        private var _xml:XML;
        private var _dir:int;
        private var _time:int = 0;
        private var _bmd:Bitmap;
        private var _colorBmp:Bitmap;
        private var _frame:int = 0;
        private var _mirror:Array;
        private var _defaultDir:uint = 0;
        
        public function SWFBitmap2P5D()
        {
            _xml = XML(TFXML.text);
            _mirror = String(_xml.@MirrorDir).split(',');
            
            delete _xml.@MirrorDir;
            delete _xml.@speed;
            TFXML.text = _xml.toXMLString();
            _list = parseBitmapData(new D5BitmapData(), int(_xml.@Frame),int(_xml.@Direction),int(_xml.@FrameWidth),int(_xml.@FrameHeight));
            //_colorSkinList = parseBitmapData(new SkinBitmapData(), int(_xml.@Frame),int(_xml.@Direction),int(_xml.@FrameWidth),int(_xml.@FrameHeight));
            initPlay();
        }
        
        public function get colorSkinList():Array
        {
            return _colorSkinList;
        }
        
        /**
         * 初始化数据
         */ 
        private function parseBitmapData(res:BitmapData, per:uint,dir:uint,frameW:uint,frameH:uint) : Array
        {
            
            var temp_bd:BitmapData;
            var mirror_bd:BitmapData = new BitmapData(frameW, frameH, true, 0);
            var matrix:Matrix = new Matrix(-1, 0, 0, 1, frameW, 0);
            var rect:Rectangle = new Rectangle();
            var p:Point = new Point();
            var list:Array = new Array();
            var listMirror:Array = new Array();
            
            _resource = res;
            
            
            rect.width = frameW;
            rect.height = frameH;
            
            var lineArr:Vector.<BitmapData>;
            var mirrorArr:Vector.<BitmapData>;
            
            var count:uint = 0;
            for(var py:uint = 0;py<dir;py++)
            {
                lineArr = new Vector.<BitmapData>;
                mirrorArr = new Vector.<BitmapData>;
                
                for(var px:uint = 0;px<per;px++)
                {
                    rect.x = px*frameW;
                    rect.y = py*frameH;
                    
                    temp_bd = new BitmapData(rect.width, rect.height, true, 0);
                    temp_bd.copyPixels(res, rect, p);
                    
                    if (_mirror.indexOf(py.toString())!=-1)
                    {
                        mirror_bd = new BitmapData(rect.width, rect.height, true, 0);
                        mirror_bd.draw(temp_bd, matrix);
                        mirrorArr.push(mirror_bd);
                    }
                    lineArr.push(temp_bd);
                }
                
                if(mirrorArr.length>0) listMirror.push(mirrorArr);
                list.push(lineArr);
            }
            
            while(listMirror.length)
            {
                list.push(listMirror.shift());
            }
            
            return list;
        }
        
        /**
         * 获取列表，本方法供CPU渲染使用
         */ 
        public function get list():Array
        {
            _resource.dispose();
            return _list;
        }
        
        /**
         * 本方法供GPU渲染使用
         */
        public function get resource():BitmapData
        {
            _list = null;
            return _resource;
        }
        
        /**
         * 获取XML配置
         */ 
        public function get xml():XML
        {
            removeEventListener(Event.ENTER_FRAME, enterFrame);
            while (numChildren)
            {
                
                removeChildAt(0);
            }
            return _xml;
        }
        
        /**
         * 初始化播放器
         */ 
        private function initPlay():void
        {
            if (_list.length == 0) return;
            if (_colorSkinList!=null && _colorSkinList.length == 0) return;
            
            var px:int;
            var py:int;
            
            _time = getTimer();
            
            _bmd = new Bitmap(_list[_defaultDir][0], "auto", true);
            _bmd.x = int(_xml.@X) + px;
            _bmd.y = int(_xml.@Y) + py;
            
            //_colorBmp = new Bitmap(_list[_defaultDir][0], "auto", true);
            //_colorBmp.x = int(_xml.@X) + px;
            //_colorBmp.y = int(_xml.@Y) + py;
            
            
            var namebox:Sprite = new Sprite();
            namebox.graphics.beginFill(0xff0000, 1);
            namebox.graphics.drawRect(-30, -10, 60, 20);
            namebox.x = int(_xml.@NameX) + px;
            namebox.y = int(_xml.@NameY) + py;
            
            
            var shadow:Sprite = new Sprite();
            shadow.graphics.beginFill(16711680, 1);
            shadow.graphics.drawEllipse(-25, -15, 50, 30);
            shadow.x = px;
            shadow.y = py;
            shadow.scaleX = Number(_xml.@shadowX) * 0.01;
            shadow.scaleY = Number(_xml.@shadowY) * 0.01;
            
            
            var hitWidth:uint = int(_xml.@hitWidth);
            var hitHeight:uint = int(_xml.@hitHeight);
            var hitter:Sprite = new Sprite();
            hitter.x = px;
            hitter.y = py;
            hitter.graphics.lineStyle(1, 26316);
            hitter.graphics.drawRect(-hitWidth, -hitHeight, hitWidth * 2, hitHeight * 2);
            
            
            addChild(namebox);
            addChild(shadow);
            addChild(_bmd);
            //addChild(_colorBmp);
            addChild(hitter);
            
            
            addEventListener(Event.ENTER_FRAME, enterFrame);
        }
        
        /**
         * 渲染动画
         */ 
        private function enterFrame(param1:Event):void
        {
            var cost_time:Number = (getTimer() - _time) / int(_xml.@Time);
            if (_frame != cost_time)
            {
                _frame = cost_time;
                _bmd.bitmapData = _list[_defaultDir][int(cost_time % _list[_defaultDir].length)];
                if(_colorSkinList) _colorBmp.bitmapData = _colorSkinList[_defaultDir][int(cost_time % _colorSkinList[_defaultDir].length)];
            }
        }
    }
}