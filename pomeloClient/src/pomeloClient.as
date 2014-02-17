package
{
    import com.bit101.components.PushButton;
    import com.bit101.components.Style;
    import com.bit101.components.TextArea;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    import org.idream.pomelo.Pomelo;
    import org.idream.pomelo.PomeloEvent;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#000000")]
    public class pomeloClient extends Sprite
    {
        private var pomelo:Pomelo;
        private var infoTxt:TextArea;
        private var loginBtn:PushButton;
        private var notifyBtn:PushButton;
        
        public function pomeloClient()
        {
            Style.embedFonts = false;
            Style.fontSize =  14;
            Style.setStyle( Style.DARK );
            
            pomelo = Pomelo.getIns();
            
            loginBtn = new PushButton( this, 10 , 40 , "登录" , onLogin );
            notifyBtn = new PushButton( this , 10 , 70 , "通知" , onNotify );
            infoTxt = new TextArea( this , 120 , 10 , "" );
            infoTxt.setSize( 500 , 600 );
            
            
            pomelo.addEventListener( "handshake", 
                function(event:Event):void 
                {
                    infoTxt.textField.appendText( "握手成功..." );
                    pomelo.on("onServerPush", onServerPush );
                }
            );
        }
        
        private function onServerPush(e:PomeloEvent):void 
        {
            trace(e.message);
        }
        
        private function onNotify( e:MouseEvent):void
        {
            infoTxt.textField.appendText( "notify\n" );
            pomelo.notify("connector.loginHandler.notify", {});
        }        
        
        
        private function onLogin( e:MouseEvent):void
        {
            infoTxt.textField.appendText( "连接中..." );
            pomelo.init("10.0.1.128",3010,null,
                function(response:Object):void
                {
                    if( response.code == 200 )
                    {
                        infoTxt.textField.appendText( "连接成功..." );
                        infoTxt.textField.appendText( "登录中..." );
                        pomelo.request("connector.loginHandler.login", { "msg":"hello pomelo"}, 
                            function(response:Object):void 
                            {
                                if( response.code == 200 )
                                {
                                    infoTxt.textField.appendText( "登录成功\n" );
                                }
                                else
                                {
                                    infoTxt.textField.appendText( "登录失败\n" );
                                }
                            }
                        );
                    }
                    else
                    {
                        infoTxt.textField.appendText( "连接失败\n" );
                    }
                }
            );
        }
    }
}