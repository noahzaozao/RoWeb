package com.D5Power.GMath
{
    public class GMath
    {
        public function GMath()
        {
        }
        
        /**
         * 获取某点的夹角
         * 返回为弧度值
         */ 
        public static function getPointAngle(x:Number,y:Number):Number
        {
            return Math.atan2(y,x);
        }
        
        /**
         * 弧度转角度
         */ 
        public static function R2A(r:Number):int
        {
            return int(r*180/Math.PI);
        }
        
        /**
         * 角度转弧度
         */ 
        public static function A2R(a:int):Number
        {
            return a*Math.PI/180;	
        }
    }
}