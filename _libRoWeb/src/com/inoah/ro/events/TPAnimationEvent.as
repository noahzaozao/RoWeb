package com.inoah.ro.events
{
    import com.inoah.ro.displays.starling.structs.TPAnimation;
    
    import flash.events.Event;
    
    public class TPAnimationEvent extends flash.events.Event
    {
        public static const INITIALIZED:String = "tp_initialized";
        protected var _tpAnimation:TPAnimation;
        
        public function TPAnimationEvent(type:String, tpAnimation:TPAnimation , bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            _tpAnimation = tpAnimation;
        }
        
        public function get tpAnimation():TPAnimation
        {
            return _tpAnimation;
        }
    }
}