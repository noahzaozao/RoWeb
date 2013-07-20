package 
{
    import flash.display.Sprite;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
	
	
	
    public class VersionSprite extends Sprite
    {
        protected const VERSION:String = "ver0.0.5 ";
		
        private var _modifyDate:String;
        private var _swfBytes:ByteArray;
        private var _myContextMenu:ContextMenu;
		
		private namespace xmp = "http://ns.adobe.com/xap/1.0/";
		private namespace dc = "http://purl.org/dc/elements/1.1";
		
        public function VersionSprite()
        {
            super();
            addVersionMenu();
        }
        
        private function addVersionMenu():void
        {
            _swfBytes = this.loaderInfo.bytes;
            _swfBytes.endian = Endian.LITTLE_ENDIAN;
            _swfBytes.position = 0;
            if (_swfBytes.readUnsignedByte() == 0x43)
            {
                _swfBytes.position = 8;
                var temp:ByteArray = new ByteArray();
                _swfBytes.readBytes(temp);
                _swfBytes = temp;
                _swfBytes.endian = Endian.LITTLE_ENDIAN;
                _swfBytes.position = 0;
                temp = null;
                _swfBytes.uncompress();
            }
            _swfBytes.position = 21;
            try
            {
                while (readTag()) { }
            }
            catch (error:Error)
            {
            }
            _myContextMenu = new ContextMenu();
            var contextMenuItem:ContextMenuItem = new ContextMenuItem( VERSION + _modifyDate);
            _myContextMenu.hideBuiltInItems();
            _myContextMenu.customItems.push(contextMenuItem);
            this.contextMenu = _myContextMenu;
        }
        
        public function get myContextMenu():ContextMenu
        {
            return _myContextMenu;
        }
        
        private function readTag():Boolean
        {
            var tagHeader:int = _swfBytes.readUnsignedShort();
            var currentTag:int = tagHeader >> 6;
            var tagLength:uint = tagHeader & 0x3F;
            if (tagLength == 0x3F)
            {
                tagLength = _swfBytes.readUnsignedInt();
            }
            var nextTagPosition:uint = _swfBytes.position + tagLength;
            if (currentTag == 77)
            {
                var i:uint = _swfBytes.position;
                try
                {
                    while (_swfBytes[i] != 0)
                    {
                        i++;
                    }
                }
                catch (error:Error)
                {
                }
                var metadata:XML = new XML(_swfBytes.readUTFBytes(i - _swfBytes.position));
                _modifyDate=(metadata..xmp::ModifyDate);
                if(_modifyDate=="")_modifyDate=metadata..dc::date;
            }
            if(currentTag==0)
            {
                return false;
            }
                
            _swfBytes.position = nextTagPosition;
            return true;
        }
    }
}