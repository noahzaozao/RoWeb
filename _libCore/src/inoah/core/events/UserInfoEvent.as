package inoah.core.events
{
    import flash.events.Event;
    
    public class UserInfoEvent extends Event
    {
        public static const USER_INFO_CHANGE:String  = "UserInfoEvent.USER_INFO_CHANGE";
        
        public function UserInfoEvent(type:String)
        {
            super(type);
        }
    }
}