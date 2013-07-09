package com.D5Power.Objects.Effects
{
    import com.D5Power.Objects.IRender;
    import com.D5Power.Objects.MovieObject;
    import com.D5Power.scene.BaseScene;
    
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    
    public class EffectObject extends MovieObject implements IRender
    {
        protected var _scene:BaseScene;
        protected var _colorPan:ColorTransform;
        
        /**
         * 缓冲
         */ 
        protected var _buffer:BitmapData;
        /**
         * 透明控制器
         */ 
        protected var _alpha:Number=1;
        /**
         * 保留时间
         */ 
        protected var _stayTime:uint = 20;
        
        public function EffectObject(scene:BaseScene)
        {
            _scene = scene;
            _colorPan = new ColorTransform();
            canBeAtk=false;
            super();
        }
        public function get colorPan():ColorTransform
        {
            return _colorPan;
        }
        
        /**
         * 悬浮坐标
         */ 
        public function get rendFly():Point
        {
            return new Point();	
        }
        
        /**
         * 自动运算
         */ 
        protected function run():void
        {
            
        }
        
        public function get isOver():Boolean
        {
            return false;
        }
        
        /**
         * 引用场景
         */ 
        public function get Scene():BaseScene
        {
            return _scene;
        }
    }
}