package inoah.modules.core.view.events
{
    import flash.events.Event;
    
    public class GetSomeTextEvent extends Event 
    {
        
        public static const GET_SOME_TEXT:String = "getSomeText";
        
        public var objectOrStringOrAnyTypeToPassAlong:String;
        
        public function GetSomeTextEvent(type:String, objectOrStringOrAnyTypeToPassAlong:String, bubbles:Boolean = false, cancelable:Boolean = false) 
        {
            super(type, bubbles, cancelable);
            this.objectOrStringOrAnyTypeToPassAlong = objectOrStringOrAnyTypeToPassAlong;
        }
        
        override public function clone():Event 
        {
            return new GetSomeTextEvent(type, objectOrStringOrAnyTypeToPassAlong, bubbles, cancelable);
        }
    }
}