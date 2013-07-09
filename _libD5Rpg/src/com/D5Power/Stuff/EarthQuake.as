package com.D5Power.Stuff
{
    import flash.display.DisplayObject;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    public class EarthQuake {
        
        private static const FRAME_RATE:int = 25;
        
        private static var timer:Timer;
        /**
         * 震动对象
         */ 
        private static var image:DisplayObject;
        /**
         * 原始位置X
         */ 
        private static var originalX:int;
        /**
         * 原始位置Y
         */
        private static var originalY:int;
        /**
         * 震动幅度
         */ 
        private static var intensity:int;
        /**
         * 震动偏移
         */
        private static var intensityOffset:int;
        
        /**
         * 是否主场景震动，若设置为true，则震动完成红坐标自动为0,0
         */ 
        public static var rootQuake:Boolean = false;
        
        public function EarthQuake(){
            super();
        }
        
        /**
         * 开始震动
         * @param	_image		震动目标
         * @param	_intensity	震动幅度
         * @param	_seconds	震动持续时间
         */ 
        public static function go(_image:DisplayObject, _intensity:Number=10, _seconds:Number=1):void{
            if (timer) cleanup();
            
            image = _image;
            originalX = image.x;
            originalY = image.y;
            
            intensity = _intensity;
            intensityOffset = (intensity / 2);
            var msPerUpdate:int = int((800 / FRAME_RATE));
            var totalUpdates:int = int(((_seconds * 1000) / msPerUpdate));
            timer = new Timer(msPerUpdate, totalUpdates);
            timer.addEventListener(TimerEvent.TIMER, quake);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE, resetImage);
            timer.start();
        }
        
        public static function temp():void{
        }
        
        /**
         * 震动
         */ 
        private static function quake(event:TimerEvent):void{
            var newX:int = ((originalX + (Math.random() * intensity)) - intensityOffset);
            var newY:int = ((originalY + (Math.random() * intensity)) - intensityOffset);
            image.y = newY;
        }
        
        /**
         * 震动完成，重置位置
         */ 
        private static function resetImage(event:TimerEvent=null):void{
            if (rootQuake){
                image.x = 0;
                image.y = 0;
            } else {
                image.x = originalX;
                image.y = originalY;
            };
            cleanup();
        }
        
        /**
         * 清理
         */ 
        private static function cleanup():void
        {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,quake);
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE,resetImage);
            timer = null;
            image = null;
            rootQuake = false;
        }
    }
}