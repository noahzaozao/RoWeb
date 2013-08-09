package inoah.modules.core.view.events
{
    import flash.events.Event;
    
    public class OpenPopupEvent extends Event 
    {
        public static const OPEN:String = "open";
        
        public function OpenPopupEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
        }
        
        override public function clone():Event {
            return new OpenPopupEvent(type, bubbles, cancelable);
        }
    }
}