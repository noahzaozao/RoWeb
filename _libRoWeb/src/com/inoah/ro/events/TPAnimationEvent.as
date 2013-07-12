package com.inoah.ro.events
{
    import flash.events.Event;
    
    public class TPAnimationEvent extends flash.events.Event
    {
        public static const INITIALIZED:String = "tp_initialized";
        
        public function TPAnimationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}