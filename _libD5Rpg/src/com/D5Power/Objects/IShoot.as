package com.D5Power.Objects
{
    /**
     * 射击接口
     * 
     */ 
    public interface IShoot
    {
        /**
         * 剩余弹药
         */ 
        function set BulletNum(num:uint):void;
        /**
         * 剩余弹药
         */ 
        function get BulletNum():uint;
        /**
         * 剩余弹药
         */ 
        function set BulletMax(num:uint):void;
        /**
         * 剩余弹药
         */ 
        function get BulletMax():uint;
        /**
         * 射击
         * @return Boolean
         */ 
        function Shoot():Boolean;
    }
}