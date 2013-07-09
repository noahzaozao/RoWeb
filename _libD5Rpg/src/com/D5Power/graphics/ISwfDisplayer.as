package com.D5Power.graphics
{
    import flash.display.Bitmap;
    import flash.display.Shape;
    
    public interface ISwfDisplayer 
    {
        /**
         * 渲染接口
         */ 
        function render():void;
        /**
         * 更换SWF接口
         */ 
        function changeSWF(f:String,needMirror:Boolean=false):void;
        
        /**
         * 更换动作接口
         */ 
        function set action(v:int):void;
        
        /**
         * 更换方向接口
         */ 
        function set direction(v:int):void;
        
        
        function get monitor():Bitmap;
        
        function get shadow():Shape;
    }
}