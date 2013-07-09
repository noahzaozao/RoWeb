package panels
{
    import flash.events.Event;
    
    public class DisplayEvent extends Event
    {
        public static const SHOW:String = "show";
        
        private var _data:String;
        private var _switchType:uint;
        
        public function DisplayEvent(type:String, data:String, switchType:uint )
        {
            super(type);
            _data = data;
            _switchType = switchType;
        }
        
        public function get data():String
        {
            return _data;
        }
        
        public function get switchType():uint
        {
            return _switchType;
        }
    }
}