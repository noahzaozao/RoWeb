package com.D5Power.Objects
{
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.mission.NPCMissionConfig;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filters.ColorMatrixFilter;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    /**
     * 由电脑控制的玩家对象
     */
    
    public class NCharacterObject extends CharacterObject implements IPoolObject
    {
        /**
         * 用户ID，如果为0则为NPC
         */ 
        protected var _uid:uint=0;
        
        protected var _misConf:NPCMissionConfig;
        
        public function get enable():Boolean
        {
            return _enable;
        }
        
        public function set uid(val:uint):void
        {
            canBeAtk=val>0;
            _uid=val;
        }
        
        public function get uid():uint
        {
            return _uid;
        }
        
        public function NCharacterObject(ctrl:BaseControler=null)
        {
            super(ctrl);
            objectName = 'NCharacterObject';
        }
        
        /**
         * 读取任务配置文件
         * 本方法只能由D5Game主动触发
         */ 
        public function loadMissionScript():void
        {
            var urlLoader:URLLoader = new URLLoader();
            urlLoader.addEventListener(Event.COMPLETE,parseNpcMission);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onNpcMissionError);
            urlLoader.load(new URLRequest('asset/mission/'+_uid+'.xml'));
        }
        
        public function get missionConfig():NPCMissionConfig
        {
            return _misConf;    
        }
        
        protected function parseNpcMission(e:Event):void
        {
            var loader:URLLoader = e.target as URLLoader;
            loader.removeEventListener(Event.COMPLETE,parseNpcMission);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onNpcMissionError);
            
            var xml:XML = new XML(loader.data);
            
            _misConf = new NPCMissionConfig();
            _misConf.say = xml.nomission.info;
            _misConf.npcname = xml.npcname;
            if(xml.nomission.event)
            {
                _misConf.setEvent(xml.nomission.event.attribute('type'),xml.nomission.event.attribute('value'));
            }
            
            for each(var data:* in xml.mission)
            {
                _misConf.addMission(data.id,data);
            }
        }
        
        protected function onNpcMissionError(e:IOErrorEvent):void
        {
            var loader:URLLoader = e.target as URLLoader;
            loader.removeEventListener(Event.COMPLETE,parseNpcMission);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,onNpcMissionError);
        }
        
        public function close():void
        {
            _controler.perception.Scene.removeObject(this);
            canBeAtk = false;
            _qTree = null;
            _controler = null;
        }
        
        public function open(_controller:BaseControler):void
        {
            _controler = _controller;
            _controler.perception.Scene.addObject(this);
        }
        
        private var _enable:Boolean;
        public function set enable(flg:Boolean):void
        {
            _enable = flg;
            this.mouseEnabled = this.mouseChildren = flg;
            this.filters = flg?null:[new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
        }
    }
}