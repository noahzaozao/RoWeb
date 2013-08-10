package inoah.game.ro.modules.main.view.mediator
{
    import inoah.game.ro.modules.main.view.StatusBarView;
    import inoah.interfaces.IDisplayMgr;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import robotlegs.bender.framework.api.IContext;
    
    public class StatusBarViewMediator extends Mediator
    {
        [Inject]
        public var displayMgr:IDisplayMgr;
        
        [Inject]
        public var view:StatusBarView;
        
        [Inject]
        public var viewManager:IViewManager;
        
        [Inject]
        public var context:IContext;
        
        public function StatusBarViewMediator()
        {
            super();
        }
        
        override public function initialize():void 
        {
            
        }
    }
}