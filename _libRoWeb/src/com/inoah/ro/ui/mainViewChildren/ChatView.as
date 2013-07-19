package com.inoah.ro.ui.mainViewChildren
{
    import com.inoah.ro.RoGlobal;
    import com.inoah.ro.consts.GameCommands;
    import com.inoah.ro.infos.UserInfo;
    import com.inoah.ro.utils.UserData;
    
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import as3.patterns.facade.Facade;
    
    import game.ui.mainViewChildren.chatViewUI;
    
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
                    var userInfo:UserInfo = RoGlobal.userInfo;
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