package com.D5Power.utils
{
    import com.D5Power.mission.IMissionDispatcher;
    
    public class CharacterData extends RandData implements IMissionDispatcher
    {
        /**
         * 可见任务列表
         */ 
        public var canSeeMission:Vector.<uint>=null;
        /**
         * 玩家阵营
         */ 
        public var camp:uint = 0;
        
        /**
         * 玩家用户ID
         */ 
        public var uid:uint = 0;
        
        /**
         *	@param		ispc	是否玩家 
         */
        public function CharacterData(ispc:Boolean=true)
        {
            if(ispc)canSeeMission = new Vector.<uint>;
        }
        
        public function canSee(missionid:uint):Boolean
        {
            return canSeeMission.indexOf(missionid)!=-1;
        }
        
        public function hasItemNum(itemid:uint):uint
        {
            return 0;
        }
        
        public function hasTalkedWith(npcid:uint):uint
        {
            return 0;
        }
        
        public function killMonseterNum(monsterid:uint):uint
        {
            return 0;
        }
        
        public function getItem(itemid:uint, num:uint):Boolean
        {
            return true;
        }
        
        public function getExp(num:uint):void
        {
        }
        
        public function getCanSeeMission(id:uint):void
        {
            
            if(canSeeMission.indexOf(id)==-1) canSeeMission.push(id);
            //trace("[CharacterData]",canSeeMission);
        }
        
        public function lostCanSeeMission(id:uint):void
        {
            var fid:int = canSeeMission.indexOf(id);
            if(fid!=-1) canSeeMission.splice(fid,1);
        }
    }
}