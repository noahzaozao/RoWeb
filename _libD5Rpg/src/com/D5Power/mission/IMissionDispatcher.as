package com.D5Power.mission
{
    public interface IMissionDispatcher
    {
        /**
         * 是否对某任务可见
         */ 
        function canSee(missionid:uint):Boolean
        /**
         * 检查某物品数量
         */ 
        function hasItemNum(itemid:uint):uint;
        /**
         * 是否和某NPC对话过
         */ 
        function hasTalkedWith(npcid:uint):uint;
        /**
         * 杀死怪物数量
         */ 
        function killMonseterNum(monsterid:uint):uint;
        
        /**
         * 得到某物品
         */ 
        function getItem(itemid:uint,num:uint):Boolean;
        
        /**
         * 获得经验
         */ 
        function getExp(num:uint):void;
        
        /**
         * 可见某任务
         */ 
        function getCanSeeMission(id:uint):void;
        /**
         * 不可见某任务
         */ 
        function lostCanSeeMission(id:uint):void; 
    }
}