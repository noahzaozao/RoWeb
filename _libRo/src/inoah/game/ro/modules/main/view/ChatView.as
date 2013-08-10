package inoah.game.ro.modules.main.view
{
    import flash.events.EventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import game.ui.mainViewChildren.chatViewUI;
    
    import inoah.game.ro.modules.main.model.UserModel;
    import inoah.game.ro.modules.main.view.events.GameEvent;
    import inoah.interfaces.IUserInfo;
    
    public class ChatView extends EventDispatcher
    {
        private var _userModel:UserModel;
        
        private var _chatView:chatViewUI;
        
        public function ChatView( chatView:chatViewUI , userModel:UserModel )
        {
            super();
            _userModel = userModel;
            _chatView = chatView;
            this._chatView.labChat.text = "";
            this._chatView.txtChat.text = "";
            this._chatView.txtChat.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDownHandler );
        }
        
        protected function onKeyDownHandler( e:KeyboardEvent ):void
        {
            if( e.keyCode == Keyboard.ENTER )
            {
                if( this._chatView.txtChat.text != "" )
                {
                    var userInfo:IUserInfo = _userModel.info;
                    var msg:String = userInfo.name + ": " + this._chatView.txtChat.text;
                    dispatchEvent( new GameEvent( GameEvent.SEND_CHAT , msg ) );
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