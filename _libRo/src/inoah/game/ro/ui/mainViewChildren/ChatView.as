package inoah.game.ro.ui.mainViewChildren
{
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import game.ui.mainViewChildren.chatViewUI;
    
    import inoah.core.Global;
    import inoah.core.consts.commands.GameCommands;
    import inoah.core.infos.UserInfo;
    
    import pureMVC.patterns.facade.Facade;
    
    public class ChatView
    {
        private var _chatView:chatViewUI;
        
        public function ChatView( chatView:chatViewUI)
        {
            super();
            _chatView = chatView;
            this._chatView.labChat.text = "";
            this._chatView.txtChat.text = "";
            this._chatView.txtChat.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDownHandler );
        }
        
        protected function onKeyDownHandler( e:KeyboardEvent):void
        {
            if( e.keyCode == Keyboard.ENTER )
            {
                if( this._chatView.txtChat.text != "" )
                {
                    var userInfo:UserInfo = Global.userInfo;
                    var msg:String = userInfo.name + ": " + this._chatView.txtChat.text;
                    Facade.getInstance().sendNotification( GameCommands.SEND_CHAT, [msg] );
                    this._chatView.txtChat.text = "";
                }
            }
        }
        
        public function addChat( value:String ):void
        {
            if( _chatView.labChat.textField.numLines > 100 )
            {
                //超过行数清理一下
            }
            _chatView.labChat.appendText( value + "\n" );
            _chatView.labChat.textField.scrollV = _chatView.labChat.textField.numLines;
        }
    }
}