package inoah.game.ro.modules.main.view.mediator
{
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.main.view.StatusView;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    public class StatusViewMediator extends Mediator
    {
        [Inject]
        public var view:StatusView;
        
        [Inject]
        public var userModel:UserModel;
        
        public function StatusViewMediator( viewComponent:Object=null)
        {
        }
        
        override public function initialize():void
        {
            view.updateInfo( userModel );
            
            addViewListener( GameEvent.CLOSE_STATUS , onCloseStatus , null );
            addViewListener( GameEvent.UPDATE_LV , onUpdateStatusPoint , null );
            addViewListener( GameEvent.UPDATE_STATUS_POINT , onUpdateStatusPoint , null );
        }
        
        private function onUpdateStatusPoint( e:GameEvent ):void
        {
            view.updateInfo( userModel );
        }
        
        private function onCloseStatus( e:GameEvent ):void
        {
            view.parent.removeChild( view );
        }
    }
}