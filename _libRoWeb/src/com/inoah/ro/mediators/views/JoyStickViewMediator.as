package com.inoah.ro.mediators.views
{
    import inoah.game.consts.GameConsts;
    import com.inoah.ro.ui.mainViewChildren.JoyStickView;
    
    import pureMVC.patterns.mediator.Mediator;
    
    public class JoyStickViewMediator extends Mediator
    {
        public function JoyStickViewMediator( viewComponent:Object=null)
        {
            super(GameConsts.JOYSTICK_VIEW, viewComponent);
        }
        
        public function get mainView():JoyStickView
        {
            return viewComponent as JoyStickView;
        }
    }
}