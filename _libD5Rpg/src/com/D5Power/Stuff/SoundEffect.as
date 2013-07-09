package com.D5Power.Stuff
{
    import flash.events.Event;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    
    /**
     * 声音效果控制器
     */ 
    public class SoundEffect
    {
        private var channle:SoundChannel;
        public function SoundEffect()
        {
            
        }
        
        public function play(id:uint):void
        {
            var clas:Class = this['_'+id];
            var sound:Sound = new clas() as Sound;
            if(channle)
            {
                channle.removeEventListener(Event.SOUND_COMPLETE,onComplate);
            }
            channle = sound.play();
            channle.addEventListener(Event.SOUND_COMPLETE,onComplate);
        }
        
        protected function onComplate(e:Event):void
        {
            
        }
    }
}