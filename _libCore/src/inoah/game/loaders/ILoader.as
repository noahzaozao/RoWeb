package inoah.game.loaders
{
    import flash.events.IEventDispatcher;

    public interface ILoader extends IEventDispatcher
    {
        function load():void;
        function get url():String;
    }
}