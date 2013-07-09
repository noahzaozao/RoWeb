package com.D5Power.particle
{
    import flash.utils.getTimer;
    
    /**
     * 粒子容器
     */ 
    public class ParticleBox
    {
        /**
         * 渲染间隔
         */ 
        private var _renderTime:uint = 30;
        
        internal static var _me:ParticleBox = new ParticleBox();
        /**
         * 对象池
         */ 
        internal var pool:Array;
        /**
         * 链表头
         */ 
        internal var particleHead:Particle;
        /**
         * 链表尾
         */ 
        internal var particleLast:Particle;
        
        /**
         * 渲染链表指针
         */ 
        internal var particleRender:Particle;
        
        /**
         * 获得一个新的粒子
         */ 
        public static function getParticle():Particle
        {
            if(_me.pool.length>0) return _me.pool.shift();
            
            var par:Particle = new Particle();
            if(_me.particleHead==null)
            {
                _me.particleHead = par;
                _me.particleRender = par;
            }else{
                _me.particleLast.next = par;
                par.prev = _me.particleLast;
            }
            _me.particleLast = par;
            return par;
        }
        
        public static function get me():ParticleBox
        {
            return _me;
        }
        
        public function ParticleBox()
        {
            pool = new Array();
        }
        
        
        
        public function remove(value:Particle):Particle
        {
            var prev:Particle = value.prev;
            var next:Particle = value.next;
            
            if(next!=null) next.prev = prev;
            if(prev!=null) prev.next = next;
            
            if(value==particleHead) particleHead = value.next;
            if(value==particleLast) particleLast = value.prev;
            if(value==particleRender) particleRender = particleHead;
            return value;
        }
        
        public function render():void
        {
            var t:uint = getTimer();
            while(particleRender)
            {
                if(particleRender)particleRender.render();
                if(particleRender)particleRender = particleRender.next;
                if(particleRender==null)
                {
                    particleRender = particleHead;
                    break;
                }
                
                if(getTimer()-t>10) break;
            }
        }
    }
}