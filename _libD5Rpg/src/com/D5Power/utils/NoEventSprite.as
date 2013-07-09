package com.D5Power.utils
{
    import flash.display.Sprite;
    
    /**
     * 不响应鼠标事件的Sprite
     */ 
    public class NoEventSprite extends Sprite
    {
        public function NoEventSprite()
        {
            super();
            mouseChildren = false;
            mouseEnabled = false;
            tabEnabled = false;
            tabChildren = false;
        }
    }
}