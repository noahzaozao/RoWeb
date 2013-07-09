package com.D5Power.mission
{
    /**
     * 任务需求条件或给与奖励的专用存储数据
     */ 
    internal class MissionBlock
    {
        /**
         * 物品
         */ 
        internal static const ITEM:uint=0;
        /**
         * 任务
         */ 
        internal static const MISSION:uint = 1;
        /**
         * 谈话
         */ 
        internal static const TALK:uint = 2;
        
        internal static const EXP:uint = 3;
        
        /**
         * 类型
         */ 
        internal var type:uint;
        
        /**
         * 值
         */ 
        internal var value:uint;
        
        /**
         * 数量
         */ 
        internal var num:int;
        
        public function MissionBlock()
        {
        }
        
        public function toString():String
        {
            return "类型："+type+"值："+value+"数量："+num;
        }
    }
}