package com.D5Power.particle
{
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.Objects.GameObject;
    
    import flash.display.BitmapData;
    
    public class ParticleContainer extends GameObject
    {
        private var _autoMakeTime:uint;
        private var _lastMake:uint;
        private var _face:BitmapData;
        
        public function ParticleContainer(ctrl:BaseControler=null)
        {
            super(ctrl);
        }
        
        public function set face(value:BitmapData):void
        {
            _face = value;
        }
        
        public function autoMake(time:uint):void
        {
            _autoMakeTime = time;
        }
        
        override protected function renderAction():void
        {
            if(_autoMakeTime>0 && Global.Timer-_lastMake>_autoMakeTime)
            {
                _lastMake = Global.Timer;
                var p:Particle = ParticleBox.getParticle();
                configParticle(p);
                if(_face) p.bitmapFace = _face;
                p.start();
                addChild(p);
            }
        }
        
        protected function configParticle(value:Particle):void
        {
            
        }
    }
}