package com.D5Power.Controler
{
    import flash.utils.Dictionary;
    
    /**
     * 控制器调度中心
     * 游戏主控D5Game将可以通过本调度中心中的控制器控制全游戏中的角色及各种事件
     */ 
    public class ControllerCenter
    {
        /**
         * 玩家
         */ 
        protected var _player_controller:CharacterControler;
        protected var _npc_controller:Dictionary;
        
        public function ControllerCenter()
        {
            _npc_controller = new Dictionary();
        }
        
        /**
         * 设置玩家控制器。本赋值只运行一次，第二赋值不会运行
         */ 
        public function set PlayerController(ctrl:CharacterControler):void
        {
            if(_player_controller!=null) return;
            _player_controller = ctrl;
        }
        
        public function get PlayerController():CharacterControler
        {
            return _player_controller;
        }
        
        /**
         * 向NPC控制器中增加一个新的控制器
         * @param	ctrl	NPC控制器
         * @param	key		用户标识
         */ 
        public function addNController(ctrl:NCharacterControler,key:*):void
        {
            if(_npc_controller[key]!=null) return;
            _npc_controller[key] = ctrl;
        }
        
        /**
         * 从NPC控制器中删除一个控制器
         * @param	ctrl	NPC控制器
         */ 
        public function removeNController(ctrl:BaseControler):void
        {
            for(var id:* in _npc_controller)
            {
                if(_npc_controller[id]==ctrl)
                {
                    delete _npc_controller[id];
                    return;
                }
            }
            //_npc_controller.splice(id,1);
        }
        
        /**
         * 获取指定用户的控制器
         * @param	key	想获取的用户标识
         */ 
        public function getNController(key:*):NCharacterControler
        {
            return _npc_controller[key];
        }
    }
}