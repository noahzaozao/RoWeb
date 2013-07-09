package com.D5Power.Objects.Effects
{
    import com.D5Power.D5Game;
    import com.D5Power.Objects.GameObject;
    import com.D5Power.display.D5TextField;
    
    import flash.display.BitmapData;
    import flash.geom.Point;
    
    /**
     * 向上飞行的文字
     */ 
    public class UFlyFont extends GameObject
    {
        protected var _target:Point;
        public var flyY:uint = 50;
        
        /**
         * @param	scene		场景
         * @param	skillName	技能名称
         * @param	color		字体颜色
         */ 
        public function UFlyFont(value:String,color:uint=0xff0000)
        {
            _zOrderF = 200;
            buildBuffer(value,color);
        }
        
        protected function buildBuffer(name:String,color:uint):void
        {
            var textFiled:D5TextField = new D5TextField(name,color);
            textFiled.autoGrow();
            textFiled.fontBorder = 0;
            
            var buffer:BitmapData = new BitmapData(textFiled.width,textFiled.height,true,0x00000000);
            buffer.draw(textFiled);
            
            graphics.beginBitmapFill(buffer);
            graphics.drawRect(0,0,buffer.width,buffer.height);
            
            textFiled.clear();
            textFiled=null;
        }
        
        override public function setPos(px:Number,py:Number):void
        {
            super.setPos(px,py);
            
            _target = new Point(px,py-flyY);
            
        }
        
        override protected function renderAction():void
        {
            pos.y += (_target.y-pos.y)/15;
            if(Point.distance(pos,_target)<5)
            {
                D5Game.me.scene.removeObject(this);
                return;
            }
        }
        
        override public function dispose():void
        {
            super.dispose();
            graphics.clear();
        }
    }
}