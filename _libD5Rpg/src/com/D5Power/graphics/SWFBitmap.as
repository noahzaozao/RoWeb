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
    
    /**
     * 2D横版角色素材
     */ 
    public class SWFBitmap extends Sprite
    {
        public var TFXML:TextField;
        private var _list:Array;
        private var _xml:XML;
        private var _dir:int;
        private var _time:int = 0;
        private var _bmd:Bitmap;
        private var _frame:int = 0;
        
        public function SWFBitmap()
        {
            _list = [];
            _xml = XML(TFXML.text);
            _dir = 1//int(_xml.@dir);
            delete _xml.@dir;
            delete _xml.@speed;
            TFXML.text = _xml.toXMLString();
            _list = parseBitmapData(new D5BitmapData(), int(_xml.@Frame), int(_xml.@Width), int(_xml.@Height));
            initPlay();
        }
        
        /**
         * 初始化数据
         */ 
        private function parseBitmapData(res:BitmapData, frames:int, frameW:int, frameH:int) : Array
        {
            var temp_bd:BitmapData;
            var res_bd:BitmapData = new BitmapData(frameW, frameH, true, 0);
            var matrix:Matrix = new Matrix(-1, 0, 0, 1, frameW, 0);
            var rect:Rectangle = new Rectangle();
            var p:Point = new Point();
            var list:Array = new Array();
            
            
            rect.width = frameW;
            rect.height = frameH;
            
            
            while (frames-- > 0)
            {
                temp_bd = new BitmapData(rect.width, rect.height, true, 0);
                temp_bd.copyPixels(res, rect, p);
                rect.x = rect.x + rect.width;
                
                if (_dir != 1)
                {
                    res_bd.fillRect(res_bd.rect, 0);
                    res_bd.draw(temp_bd, matrix);
                    temp_bd.dispose();
                    temp_bd = res_bd.clone();
                }
                list.push(temp_bd);
            }
            
            res.dispose();
            
            
            return list;
        }
        
        /**
         * 获取列表
         */ 
        public function get list():Array
        {
            return _list;
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
            
            var px:int;
            var py:int;
            
            _time = getTimer();
            
            _bmd = new Bitmap(_list[0], "auto", true);
            _bmd.x = int(_xml.@X) + px;
            _bmd.y = int(_xml.@Y) + py;
            
            
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
                _bmd.bitmapData = _list[int(cost_time % _list.length)];
            }
        }
        
    }
}