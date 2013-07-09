/**
 * FlexGame 网页游戏引擎
 * XY数据存储器,用来存储坐标,尺寸等信息
 * Author:D5Power
 * Ver: 1.0
 */ 

package com.D5Power.utils
{
    public class XYArray
    {
        /**
         *	x属性
         */ 
        private var _x:Number=0;
        
        /**
         *	x属性
         */ 
        private var _y:Number=0;
        
        /**
         *
         * @param	x	X属性,可用于保存X坐标或对象的宽度	
         * @param y	Y属性,可用于保存Y坐标或对象的高度
         */  
        public function XYArray(x:Number=0,y:Number=0)
        {
            _x=x;
            _y=y;
        }
        
        /**
         * 获得X属性
         */ 
        public function get x():Number
        {
            return _x;
        }
        
        /**
         *	获得Y属性
         */ 
        public function get y():Number
        {
            return _y;
        }
        
        /**
         * 设置X属性
         */ 
        public function set x(val:Number):void
        {
            _x = val;
        }
        
        /**
         * 设置Y属性
         */ 
        public function set y(val:Number):void
        {
            _y = val;
        }
        
        public function toString():String
        {
            return "x:"+_x+" y:"+_y;
        }
    }
}