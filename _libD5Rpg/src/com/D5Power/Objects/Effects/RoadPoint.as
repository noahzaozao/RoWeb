package com.D5Power.Objects.Effects
{
    import com.D5Power.scene.BaseScene;
    
    import flash.geom.Point;
    
    public class RoadPoint extends EffectObject
    {
        /**
         * 跳转到的地图ID
         */ 
        public var toMap:uint = 0;
        /**
         * 跳转到X世界坐标
         */ 
        public var toX:uint = 0;
        /**
         * 跳转到Y世界坐标
         */ 
        public var toY:uint = 0;
        
        protected var checkfps:uint = int(1000/2);
        protected var lastCheck:uint = 0;
        
        protected var lock:Boolean=false;
        
        public function RoadPoint(scene:BaseScene)
        {
            super(scene);
            objectName = 'RoadPoint';
        }
        
        override protected function run():void
        {
            super.run();
            if(!lock && Global.Timer-lastCheck>checkfps && _scene.Player!=null)
            {
                lastCheck = Global.Timer;
                if(Point.distance(_scene.Player._POS,pos)<20)
                {
                    _scene.changeScene(toMap,toX,toY);
                    lock = true;
                }
            }
        }
        
        override protected function build():void
        {
            super.build();
            _renderBuffer.x = -int(graphicsRes.frameWidth/2);
            _renderBuffer.y = -int(graphicsRes.frameHeight/2);
        }
    }
}