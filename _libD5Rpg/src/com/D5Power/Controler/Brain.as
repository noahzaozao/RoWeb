package com.D5Power.Controler
{
    /**
     * 大脑。NPC控制器的行动控制中心
     */ 
    public class Brain
    {
        protected var _ctrl:BaseControler;
        /**
         * 上一次的思考时间
         */ 
        private var _lastThink:uint;
        /**
         * 思考速度
         */ 
        private var _thinkSpeed:uint;
        
        public function Brain()
        {
            
        }
        
        /**
         * 
         */ 
        internal function set ctrl(ctrl:BaseControler):void
        {
            _ctrl = ctrl;
        }
        
        public function think():void
        {
            if(Global.Timer-_lastThink>_thinkSpeed)
            {
                _lastThink = Global.Timer;
                run();
            }
        }
        
        protected function run():void
        {
            
        }
        
    }
}