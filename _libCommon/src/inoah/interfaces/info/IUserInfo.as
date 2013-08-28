package inoah.interfaces.info
{
    import flash.events.IEventDispatcher;

    public interface IUserInfo extends IEventDispatcher
    {
        function set name( value:String ):void
        function get name():String;
        function get zeny():uint;
        function set zeny( value:uint ):void;
    }
}