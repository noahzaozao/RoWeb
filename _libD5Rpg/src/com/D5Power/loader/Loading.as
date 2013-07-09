/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.D5Power.loader
{
    import com.D5Power.basic.D5Sprite;
    
    /**
     * 进度条
     */ 
    public class Loading extends D5Sprite
    {
        /**
         * 当前加载进度
         */ 
        private var per:uint = 0;
        /**
         * 进度条宽度
         */ 
        private var box_width:uint = 0;
        /**
         * 进度条高度
         */ 
        private var box_height:uint = 0;
        
        /**
         * 进度显示条
         */ 
        private var shower:D5Sprite;
        
        /**
         * 显示条与背景间的间距
         */ 
        private var padding:uint = 2;
        
        /**
         * 背景颜色
         */ 
        public var bgColor:uint = 0x111111;
        
        /**
         * 背景线框颜色
         */ 
        public var borderColor:uint = 0x000000;
        
        /**
         * 显示框颜色
         */ 
        public var showerColor:uint = 0x666666;
        
        
        /**
         * 构造函数
         * @param	w	进度条宽度
         * @param	h	进度条高度
         */ 
        public function Loading(w:uint=200,h:uint=8)
        {
            box_width = w;
            box_height = h;
        }
        
        override public function get width():Number
        {
            return box_width;
        }
        
        override public function get height():Number
        {
            return box_height;
        }
        
        /**
         * 初始化
         */ 
        public function start():void
        {
            
        }
        
        /**
         * 更改进度
         */ 
        public function set Per(val:uint):void
        {
            per = val;
            update();
        }
        
        /**
         * 更新显示
         */ 
        private function update():void
        {
            if(shower==null)
            {
                shower = new D5Sprite();
                shower.x = padding;
                shower.y = padding;
                addChild(shower);
            }
            
            shower.graphics.clear();
            shower.graphics.beginFill(bgColor);
            shower.graphics.lineStyle(1,borderColor);
            shower.graphics.drawRect(0,0,box_width,box_height);
            shower.graphics.endFill();
            shower.graphics.beginFill(showerColor);
            shower.graphics.drawRect(padding,padding,int((box_width-padding*2)*per/100),int(box_height-padding*2));
            shower.graphics.endFill();
            
        }
        
        override public function clear():void
        {
            shower.clear();
            super.clear();
        }
        
        
    }
}