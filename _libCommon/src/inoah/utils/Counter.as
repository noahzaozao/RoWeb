package  inoah.utils
{
    /**
     * 计数器
     */ 
    public class Counter
    {
        
        /**
         * 当前值 
         */        
        private var _current : Number = 0;
        
        /**
         * 目标值 
         */        
        private var _target : Number = 0;
        
        /**
         * 是否超出目标值 
         * @return 超出目标值
         */		
        public function get expired() : Boolean
        {
            return (_current >= _target);
        }
        
        /**
         * 初始化 
         */		
        public function initialize():void
        {
            _current = 0;
            _target = 0;
        }
        
        /**
         * 重置目标值
         * @param target    目标值
         */        
        public function reset(target:Number) : void
        {
            _target = target;
            
            if(expired == true)
            {
                _current-=_target;
            }
            
        }
        
        /**
         * 计数 
         * @param delta     增加值
         */		
        public function tick(delta:Number) : void
        {
            _current += delta;
        }
        
        public function toString():String
        {
            return _current.toString();
        }
            
    }
}