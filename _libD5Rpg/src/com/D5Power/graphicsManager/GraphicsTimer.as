package com.D5Power.graphicsManager
{
    import flash.utils.Timer;
    
    /**
     * 可携带加载资源名的时间控制器
     */ 
    public class GraphicsTimer extends Timer
    {
        public var resname:String;
        public function GraphicsTimer(delay:Number, repeatCount:int=0)
        {
            super(delay, repeatCount);
        }
    }
}