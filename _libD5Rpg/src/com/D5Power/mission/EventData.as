package com.D5Power.mission
{
    /**
     * NPC事件
     */ 
    public class EventData
    {
        /**
         * 事件类型
         */ 
        internal var _type:String;
        /**
         * 事件值
         */ 
        internal var _value:String;
        public function EventData(type:String=null,value:String=null)
        {
            _type=type;
            _value = value;
        }
        
        public function get type():String
        {
            return _type;
        }
        
        public function get value():String
        {
            return _value;
        }
    }
}