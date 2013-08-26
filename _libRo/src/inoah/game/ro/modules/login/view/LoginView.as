package inoah.game.ro.modules.login.view
{
    import flash.events.MouseEvent;
    
    import game.ui.loginViewUI;
    
    import inoah.game.ro.modules.login.view.events.LoginEvent;
    
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
            dispatchEvent( new LoginEvent( LoginEvent.LOGIN , this.txtID.text , this.txtPass.text ) );
            this.remove();
            e.stopImmediatePropagation();
        }
    }
}


