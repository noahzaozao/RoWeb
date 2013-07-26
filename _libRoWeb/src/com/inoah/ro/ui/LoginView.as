package com.inoah.ro.ui
{
    import flash.events.MouseEvent;
    
    import game.ui.loginViewUI;
    
    import inoah.game.consts.GameCommands;
    
    import pureMVC.patterns.facade.Facade;
    
    public class LoginView extends loginViewUI
    {
        public function LoginView()
        {
            super();
            this.txtID.text = "";
            this.txtPass.text = "";
            this.btnReg.addEventListener( MouseEvent.CLICK, onRegHandler );
            this.btnLogin.addEventListener( MouseEvent.CLICK, onLoginHandler );
        }
        
        protected function onRegHandler( e:MouseEvent):void
        {
            
        }
        
        protected function onLoginHandler( e:MouseEvent):void
        {
            if( this.txtID.text == "" )
            {
                this.txtID.text = "player" + uint( Math.random() * 1000000 );
            }
            Facade.getInstance().sendNotification( GameCommands.LOGIN , [ this.txtID.text ] );
            this.remove();
        }
    }
}