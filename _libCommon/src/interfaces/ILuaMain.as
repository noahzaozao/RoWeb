package interfaces
{
    import flash.utils.Dictionary;

    public interface ILuaMain
    {
        function get LUA_MULTRET():int;
        function runScript( luaStr:String ):void;
        function output(s:String):void;
        function luaL_newstate():int;
        function lua_atpanic( L:int , panicf:Function ):void;
        function luaL_openlibs( L:int ):void;
        function luaL_loadstring( L:int , s:String ):int;
        function push_flashref( L:int ):int;
        function get __lua_objrefs():Dictionary;
        function set __lua_objrefs( value:Dictionary ):void;
        function luaL_checklstring( L:int , numArg:int, l:int ):String;
        function lua_close( L:int ):void;
        function lua_pcallk( L:int , nargs:int , nresults:int , errfunc:int ,ctx:int , k:Function ):int;
        function lua_getglobal(  L:int, varname:String ):void;
        function lua_pushinteger( L:int , n:* ):void;
        function lua_callk( L:int , nargs:int , nresults:int , ctx:int , k:Function ):void;
        
    }
}