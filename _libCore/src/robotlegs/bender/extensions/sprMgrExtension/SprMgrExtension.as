package robotlegs.bender.extensions.sprMgrExtension
{
    
    import inoah.interfaces.ISprMgr;
    
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.IExtension;
    
    public class SprMgrExtension implements IExtension
    {
        /*============================================================================*/
        /* Private Properties                                                         */
        /*============================================================================*/
        
        private var _context:IContext;
        
        private var _sprMgr:ISprMgr;
        
        /*============================================================================*/
        /* Constructor                                                                */
        /*============================================================================*/
        
        /*============================================================================*/
        /* Public Functions                                                           */
        /*============================================================================*/
        
        /**
         * @inheritDoc
         */
        public function extend(context:IContext):void
        {
            _context = context;
            _context.injector.map(ISprMgr).toSingleton(SprMgr);
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


