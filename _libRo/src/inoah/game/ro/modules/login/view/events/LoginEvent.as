package inoah.game.ro.modules.login.view.events
{
    import flash.events.Event;
    
    public class LoginEvent extends Event
    {
        public static const LOGIN:String = "LOGIN";
        
        public var username:String;
        public var password:String;
        
        public function LoginEvent(type:String, id:String, pass:String )
        {
            super(type, bubbles, cancelable);
            username = id;
            password = pass;
        }
        
        override public function clone():Event
        {
            return new LoginEvent( LOGIN , username , password );
        }
    }
}