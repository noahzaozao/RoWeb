package
{
    import flash.utils.ByteArray;
    
    import org.idream.pomelo.interfaces.IMessage;
    
    public class MyMessage implements IMessage
    {
        public function MyMessage()
        {
        }
        
        public function encode(id:uint, route:String, msg:Object):ByteArray
        {
            return null;
        }
        
        public function decode(buffer:ByteArray):Object
        {
            return null;
        }
    }
}