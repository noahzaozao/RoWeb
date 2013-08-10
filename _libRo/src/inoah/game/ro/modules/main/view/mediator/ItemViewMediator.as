package inoah.game.ro.modules.main.view.mediator
{
    import inoah.game.ro.modules.main.view.ItemView;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    import robotlegs.bender.framework.api.IContext;
    
    public class ItemViewMediator extends Mediator
    {
        [Inject]
        public var view:ItemView;
        
        [Inject]
        public var viewManager:IViewManager;
        
        [Inject]
        public var context:IContext;
        
        public function ItemViewMediator()
        {
        }
        
        override public function initialize():void
        {
            addViewListener( GameEvent.CLOSE_ITEM , onCloseItem , null );
        }
        
        private function onCloseItem( e:GameEvent ):void
        {
            view.parent.removeChild( view );
        }
    }
}