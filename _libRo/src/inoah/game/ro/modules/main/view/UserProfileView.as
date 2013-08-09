package inoah.game.ro.modules.main.view
{
    import flash.display.DisplayObjectContainer;
    
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.extensions.viewManager.api.IViewManager;
    
    public class UserProfileView extends ContextView
    {
        [Inject]
        public var viewManager:IViewManager;
        
        public function UserProfileView(view:DisplayObjectContainer)
        {
            super(view);
            viewManager;
        }
    }
}