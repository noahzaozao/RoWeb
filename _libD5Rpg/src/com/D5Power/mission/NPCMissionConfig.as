package com.D5Power.mission
{
    /**
     * NPC任务数据
     */
    public class NPCMissionConfig
    {
        private var _say:String;
        private var _npcname:String;
        private var _event:EventData;
        private var _mission:Vector.<MissionData>;
        private var _nowFind:uint = 0;
        private var _nowFindData:MissionData;
        
        public function NPCMissionConfig()
        {
            _mission = new Vector.<MissionData>;
        }
        
        /**
         * 默认对话
         */ 
        public function get say():String
        {
            return _say;
        }
        /**
         * NPC姓名
         */ 
        public function get npcname():String
        {
            return _npcname;
        }
        /**
         * 产生事件
         */ 
        public function get event():EventData
        {
            return _event;
        }
        
        /**
         * 设置NPC事件
         */ 
        public function setEvent(type:String,value:String):void
        {
            _event = new EventData();
            _event._type = type;
            _event._value = value;
        }
        
        public function set say(s:String):void
        {
            _say = s;
        }
        
        public function set npcname(s:String):void
        {
            _npcname = s;
        }
        
        public function addMission(id:uint,data:Object):MissionData
        {
            var mis:MissionData = new MissionData(id);
            mis._type = data.type;
            mis._name = data.name;
            mis._info = data.info;
            
            if(data.need!=null)
            {
                for each(var needdata:* in data.need)
                {
                    if(int(needdata.attribute('value'))==0 && int(needdata.attribute('type'))==0) continue;
                    var need:MissionBlock = new MissionBlock();
                    need.num = int(needdata.attribute('num'));
                    need.type = int(needdata.attribute('type'));
                    need.value = int(needdata.attribute('value'));
                    mis.addNeed(need);
                }
                
            }
            
            if(data.give!=null)
            {
                for each(var givedata:* in data.give)
                {
                    if(int(givedata.attribute('value'))==0 && int(givedata.attribute('type'))==0) continue;
                    var give:MissionBlock = new MissionBlock();
                    give.num = int(givedata.attribute('num'));
                    give.type = int(givedata.attribute('type'));
                    give.value = int(givedata.attribute('value'));
                    mis.addGive(give);
                }
            }
            
            _mission.push(mis);
            return mis;
        }
        
        public function getMission(id:uint):MissionData
        {
            if(_nowFind!=id)
            {
                for each(var m:MissionData in _mission)
                {
                    if(m._id==id)
                    {
                        _nowFindData = m;
                        _nowFind = id;
                        break;
                    }
                }
            }
            
            return _nowFindData;
        }
        
        /**
         * 完成某任务
         */ 
        public function complateMission(id:uint,checker:IMissionDispatcher):void
        {
            for each(var m:MissionData in _mission)
            {
                if(m.id==id)
                {
                    m.complate(checker);
                    break;
                }
            }
        }
        
        public function getList(checker:IMissionDispatcher):Vector.<MissionData>
        {
            var list:Vector.<MissionData> = null;
            
            for each(var m:MissionData in _mission)
            {
                if(list == null) list = new Vector.<MissionData>;
                if(!checker.canSee(m._id)) continue;
                m.check(checker)
                list.push(m);
            }
            
            return list;
        }
    }
}