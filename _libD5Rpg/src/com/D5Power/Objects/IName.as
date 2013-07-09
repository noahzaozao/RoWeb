package com.D5Power.Objects
{
    import com.D5Power.utils.XYArray;
    
    import flash.display.BitmapData;
    
    /**
     * 显示用户名的游戏对象的接口
     */ 
    internal interface IName
    {
        /**
         * 获取用户名缓冲
         */ 
        function get nameBuffer():BitmapData;
        /**
         * 用户名显示定位
         */ 
        function get namePos():XYArray;
        /**
         * 设置用户名
         */ 
        function setName(_name:String,color:int=-1,bordercolor:int=0):void;
    }
}