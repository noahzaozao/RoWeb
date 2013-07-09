package com.D5Power.Objects
{
    import com.D5Power.Objects.Effects.Shadow;
    import com.D5Power.scene.BaseScene;
    
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    
    /**
     * 可以实现获取屏幕属性的接口
     */ 
    public interface IRender
    {
        function get Scene():BaseScene;
        function get rendFly():Point;
        function get colorPan():ColorTransform;
        function get shadow():Shadow;
        function get isOver():Boolean;
    }
}