package inoah.interfaces.lua
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface ILuaMainMediator extends IMediator
    {
        function set luaStrList( value:Vector.<String> ):void;
        function get luaStrList():Vector.<String>;
    }
}