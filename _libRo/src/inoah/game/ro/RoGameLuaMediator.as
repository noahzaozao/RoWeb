package inoah.game.ro
{
    import inoah.core.Global;
    import inoah.core.loaders.LuaLoader;
    import inoah.interfaces.base.ILoader;
    import inoah.interfaces.lua.ILuaMainMediator;
    
    import starling.display.DisplayObject;
    
    public class RoGameLuaMediator extends RoGameMediator
    {
        [Inject]
        public var luaEngine:ILuaMainMediator;
        
        public function RoGameLuaMediator()
        {
            
        }
        /**
         * 
         */        
        override protected function onStarlingInited():void
        {
            displayMgr.initStarling( _starlingMain as DisplayObject );
            
            if( Global.ENABLE_LUA )
            {
                var resList:Vector.<String> = new Vector.<String>();
                resList.push( "libCore.lua" );
                resList.push( "main.lua" );
                assetMgr.getResList( resList , onLuaLoaded );
            }
            else
            {
                initLogin();
            }
        }
        
        protected function onLuaLoaded( loader:ILoader ):void
        {
            luaEngine.luaStrList.push( (assetMgr.getRes( "libCore.lua" , null ) as LuaLoader).content );
            luaEngine.luaStrList.push( (assetMgr.getRes( "main.lua" , null ) as LuaLoader).content );
            luaEngine.initialize();
            
            initLogin();
        }
    }
}