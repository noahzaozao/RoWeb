package inoah.lua
{
    import flash.external.ExternalInterface;
    import flash.utils.Dictionary;
    
    import inoah.game.ro.consts.ConstsGame;
    
    import interfaces.ILuaMain;
    
    import pureMVC.interfaces.INotification;
    import pureMVC.patterns.mediator.Mediator;
    
    import starling.core.Starling;
    
    /**
     *  处理AS3和Lua交互的类
     * @author inoah
     */    
    public class LuaEngine extends Mediator
    {
        protected static var _luaMain:ILuaMain;

        public var luaStrList:Vector.<String>;
        public var luastate:int
        protected var panicabort:Boolean = false
        
        public function LuaEngine( luaMain:ILuaMain )
        {
            super( ConstsGame.LUA_ENGINE );
            luaStrList = new Vector.<String>();
            _luaMain = luaMain;
        }
        
        public function init():void
        {
            var err:int = 0;
            luastate = _luaMain.luaL_newstate();
            panicabort = false
            _luaMain.lua_atpanic(luastate, atPanic)
            _luaMain.luaL_openlibs(luastate)
            
            for( var i:int = 0;i<luaStrList.length;i++)
            {
                if( luaL_loadstring( luastate , luaStrList[i] ) )
                {
                    return;
                }
                err = _luaMain.lua_pcallk(luastate, 0, _luaMain.LUA_MULTRET, 0, 0, null)
            }
            
            try 
            {
                _luaMain.__lua_objrefs = new Dictionary();
                _luaMain.lua_getglobal(luastate, "main")
                push_objref(this)
                push_objref(Starling.current.nativeStage.stage3Ds[0].context3D)
                _luaMain.lua_pushinteger(luastate, Starling.current.viewPort.width)
                _luaMain.lua_pushinteger(luastate, Starling.current.viewPort.height)
                _luaMain.lua_callk(luastate, 4, 0, 0, null)
            } 
            catch(e:*) 
            {
                onError("Exception thrown while initializing code:\n" + e + e.getStackTrace() );
            }
        }
       
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            switch( notification.getName() )
            {
                
            }
        }
        
        private function luaL_loadstring(luastate:int, luaStr:String):int
        {
            var err:int =_luaMain.luaL_loadstring(luastate, luaStr)
            if(err) 
            {
                onError("Error " + err + ": " + _luaMain.luaL_checklstring(luastate, 1, 0));
                _luaMain.lua_close(luastate);
            }
            return err;
        }
        
        public function atPanic(e:*): void
        {
            onError("Lua Panic: " + _luaMain.luaL_checklstring(luastate, -1, 0))
            panicabort = true
        }
        
        protected function push_objref(o:*):void
        {
            var udptr:int = _luaMain.push_flashref(luastate)
            _luaMain.__lua_objrefs[udptr] = o
        }
        
        public function onError(e:*):void
        {
            trace(e)
            if(ExternalInterface.available) 
            {
                ExternalInterface.call("reportError", e.toString())
            }
            Starling.current.stop()
        }
        
        public function tick(delta:Number):void
        {
            try 
            {
                _luaMain.lua_getglobal(luastate, "update")
                _luaMain.lua_pushnumber( luastate , delta )
                _luaMain.lua_callk(luastate, 1, 0, 0, null)
            } 
            catch(e:*) 
            {
                if(!panicabort)
                {
                    onError("Exception thrown while calling starlingUpdate:\n" + e + e.getStackTrace());
                }
            }
        }
    }
}