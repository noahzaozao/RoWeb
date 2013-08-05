package inoah.core.interfaces
{
    import flash.events.IEventDispatcher;

    public interface ILoader extends IEventDispatcher
    {
        function load():void;
        function get url():String;
    }
}