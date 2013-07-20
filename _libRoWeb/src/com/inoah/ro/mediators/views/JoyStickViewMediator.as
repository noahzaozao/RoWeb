package com.inoah.ro.mediators.views
{
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.ui.mainViewChildren.JoyStickView;
    
    import as3.patterns.mediator.Mediator;
    
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