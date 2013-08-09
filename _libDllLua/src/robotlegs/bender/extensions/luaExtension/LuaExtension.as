package robotlegs.bender.extensions.luaExtension
{
    import com.inoah.lua.LuaMain;
    
    import interfaces.ILuaMain;
    
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IExtension;

    public class LuaExtension implements IExtension
    {
        /*============================================================================*/
        /* Private Properties                                                         */
        /*============================================================================*/
        
        private var _context:IContext;
        
        private var _luaMain:ILuaMain;
        
        /*============================================================================*/
        /* Constructor                                                                */
        /*============================================================================*/
        
        public function LuaExtension( luaMain:ILuaMain = null)
        {
            _luaMain = luaMain || new LuaMain();
        }
        
        /*============================================================================*/
        /* Public Functions                                                           */
        /*============================================================================*/
        
        /**
         * @inheritDoc
         */
        public function extend(context:IContext):void
        {
            _context = context;
            _context.injector.map(ILuaMain).toValue(_luaMain);
            _context.beforeInitializing(configureLifecycleEventRelay);
            _context.afterDestroying(destroyLifecycleEventRelay);
        }
        
        /*============================================================================*/
        /* Private Functions                                                          */
        /*============================================================================*/
        
        private function configureLifecycleEventRelay():void
        {
            
        }
        
        private function destroyLifecycleEventRelay():void
        {
            
        }
    }
}