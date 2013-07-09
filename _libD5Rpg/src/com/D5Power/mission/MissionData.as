package com.D5Power.mission
{
    /**
     * 单个任务数据
     */ 
    public class MissionData
    {
        internal var _type:uint;
        /**
         * 任务ID
         */ 
        internal var _id:uint;
        /**
         * 任务名
         */ 
        internal var _name:String;
        /**
         * 任务内容
         */ 
        internal var _info:String;
        /**
         * 是否完成
         */ 
        internal var _iscomplate:Boolean=false;
        /**
         * 任务需求
         */ 
        internal var _need:Vector.<MissionBlock>;
        /**
         * 任务奖励
         */ 
        internal var _give:Vector.<MissionBlock>;
        
        /**
         * 领取类任务，直接可以完成，文字显示接受
         */ 
        internal static const GIVE:uint = 0;
        /**
         * 完成类任务，需要满足条件才能完成。
         */ 
        internal static const MISS:uint = 1;
        
        public function MissionData(id:uint)
        {
            _id = id;
        }
        
        /**
         * 任务类型 0-接 1-交
         */ 
        public function get type():uint
        {
            return _type;
        }
        /**
         * 任务名
         */ 
        public function get name():String
        {
            return _name;
        }
        /**
         * 任务ID
         */ 
        public function get id():uint
        {
            return _id;
        }
        /**
         * 任务信息
         */ 
        public function get info():String
        {
            return _info;
        }
        /**
         * 任务条件
         */ 
        public function get need():Vector.<MissionBlock>
        {
            return _need;
        }
        /**
         * 任务奖励
         */ 
        public function get give():Vector.<MissionBlock>
        {
            return _give;
        }
        /**
         * 任务是否完成
         */ 
        public function get isComplate():Boolean
        {
            return _iscomplate;
        }
        
        /**
         * 增加完成条件
         */ 
        internal function addNeed(need:MissionBlock):void
        {
            if(_need == null) _need = new Vector.<MissionBlock>;
            if(need.type==0 && need.value==0) return;
            _need.push(need);
        }
        /**
         * 增加奖励内容
         */ 
        internal function addGive(give:MissionBlock):void
        {
            if(_give == null) _give = new Vector.<MissionBlock>;
            if(give.type==0 && give.value==0) return;
            _give.push(give);
        }
        /**
         * 检查当前任务是否完成
         */ 
        internal function check(checker:IMissionDispatcher):Boolean
        {
            if(!checker.canSee(_id)) return false;
            if(_type==GIVE) return true;
            
            _iscomplate=true;
            if(_need!=null)
            {
                for each(var need:MissionBlock in _need)
                {
                    switch(need.type)
                    {
                        case MissionBlock.ITEM:
                            _iscomplate = _iscomplate && checker.hasItemNum(need.value)>=need.num;
                            break;
                        
                        case MissionBlock.TALK:
                            _iscomplate = _iscomplate && checker.hasTalkedWith(need.value);
                            break;
                        default:
                            break;
                    }
                }
            }
            return _iscomplate;
        }
        
        /**
         * 完成任务
         */ 
        internal function complate(checker:IMissionDispatcher):Boolean
        {
            if(!check(checker)) return false;
            
            if(_give!=null)
            {
                for each(var give:MissionBlock in _give)
                {
                    switch(give.type)
                    {
                        case MissionBlock.ITEM:
                            
                            checker.getItem(give.value,give.num);
                            break;
                        
                        case MissionBlock.EXP:
                            
                            checker.getExp(give.num);
                            break;
                        
                        case MissionBlock.MISSION:
                            give.num > 0 ? checker.getCanSeeMission(give.value) : checker.lostCanSeeMission(give.value);
                            break;
                    }
                }
            }
            return true;
        }
        
        public function toString():String
        {
            return "任务名："+_name+"\n任务编号："+_id+"\n任务类型："+_type+"\n任务说明:"+_info;
        }
    }
}