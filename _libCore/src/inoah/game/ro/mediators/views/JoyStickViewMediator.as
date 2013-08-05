package inoah.game.ro.mediators.views
{
    import inoah.game.ro.consts.ConstsGame;
    import inoah.game.ro.ui.mainViewChildren.JoyStickView;
    
    import pureMVC.patterns.mediator.Mediator;
    
    public class JoyStickViewMediator extends Mediator
    {
        public function JoyStickViewMediator( viewComponent:Object=null)
        {
            super(ConstsGame.JOYSTICK_VIEW, viewComponent);
        }
        
        public function get mainView():JoyStickView
        {
            return viewComponent as JoyStickView;
        }
    }
}