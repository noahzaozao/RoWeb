package inoah.core
{
    import inoah.core.consts.ConstsGame;
    import inoah.core.interfaces.ITickable;
    import inoah.core.managers.AssetMgr;
    import inoah.lua.LuaEngine;
    
    import pureMVC.patterns.facade.Facade;
    
    import starling.display.Sprite;
    import starling.events.Event;
    
    public class starlingMain extends Sprite implements ITickable
    {
        protected var _luaEngine:LuaEngine;
        
        public function starlingMain()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
        }
        
        protected function addedToStageHandler( e:Event ):void
        {
            if( Global.ENABLE_LUA )
            {
                _luaEngine = Facade.getInstance().retrieveMediator( ConstsGame.LUA_ENGINE ) as LuaEngine;
                _luaEngine.init();
            }
            else
            {
                
            }
        }
        
        /**
         * 初始加载，不必等待 作为login页面的预缓冲
         * @param assetMgr
         */        
        protected function onInitRes( assetMgr:AssetMgr ):void
        {
            //            var resPathList:Vector.<String> = new Vector.<String>();
            //            assetMgr.getResList( resPathList , function():void{} );
        }
        
        public function tick( delta:Number ):void
        {
            if( _luaEngine )
            {
                _luaEngine.tick( delta );
            }
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}