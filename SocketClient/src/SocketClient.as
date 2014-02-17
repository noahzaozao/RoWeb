package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    
    public class SocketClient extends Sprite
    {
        private var _socket:Socket;
        
        public function SocketClient()
        {
            _socket = new Socket();
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, onData );
            _socket.addEventListener(Event.CONNECT , onConnect );
            _socket.connect(  "192.168.3.108" , 20000 );
            
            stage.addEventListener( MouseEvent.CLICK , onClick);
        }
        
        protected function onClick(e:MouseEvent):void
        {
            _socket.writeUTF( "test" );
            _socket.flush();
        }
        
        protected function onConnect(e:Event):void
        {
            trace( "connected" );
        }
        
        protected function onData(e:ProgressEvent):void
        {
            trace( "Socket received " + _socket.bytesAvailable + " byte(s) of data:" );
        }
    }
}