package texturePackage.sequenceManager
{
    import com.bit101.components.Component;
    import com.bit101.components.ListItem;
    import com.bit101.components.PushButton;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObjectContainer;
    import flash.display.Loader;
    import flash.display.Shape;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    
    import format.Sequence;

    public class SequenceListItem extends ListItem
    {
        public static const SEQUENCE_REMOVE:String = "sequenceRemove";
        
        private var _pngLoader:Loader;
        
        private var _currentFile:File;
        
        private var _bitmap:Bitmap;
        
        private var _bitmapUnder:Shape;
        
        protected var _removeBtn:PushButton;
        
        public function SequenceListItem(parent:DisplayObjectContainer=null, xPos:Number=0, yPos:Number=0, data:Object=null)
        {
            super(parent, xPos, yPos, data);
            
            _label.x = 50;
            _label.y = 15;
            _label.mouseEnabled = false;
            
            //mouseChildren = false;
            if(data== null)
            {
                mouseEnabled = false;
            }
            
            _bitmap = new Bitmap(null,"auto",true);
            _bitmapUnder = new Shape();
            _bitmapUnder.graphics.beginFill(0x7396CC,.5);
            _bitmapUnder.graphics.lineStyle(.5,0x003366,.5);
            _bitmapUnder.graphics.drawRect(0,0,39,39);
            _bitmapUnder.graphics.endFill();
            
            _removeBtn = new PushButton();
            _removeBtn.label = "移除帧";
            _removeBtn.setSize(70,20);
            _removeBtn.addEventListener(MouseEvent.CLICK, onRemoveItem);
        }
        
        protected function onRemoveItem(event:MouseEvent):void
        {
            dispatchEvent(new Event(SEQUENCE_REMOVE, true));
        }
        
        override public function set selected(value:Boolean):void
        {
            super.selected = false;
        }
        
        override public function draw():void
        {
            dispatchEvent(new Event(Component.DRAW));
            
            graphics.clear();
            
            if(_selected)
            {
                graphics.beginFill(_selectedColor,.5);
            }
            else if(_mouseOver)
            {
                graphics.beginFill(_rolloverColor,.5);
            }
            else
            {
                graphics.beginFill(_defaultColor, .5);
            }
            graphics.drawRect(0, 0, width, 50);
            graphics.endFill();
            
            _removeBtn.x = width-85;
            _removeBtn.y = 15;
            
        }
        
        override public function set data(value:Object):void
        {
            if(_data == value)
            {
                return;
            }
            
            if(_data != value && value is Sequence)
            {
                _data = value;
                var nextBitmapData:BitmapData = sequence.bitmapData;
                var ratio:Number = Math.min(40/nextBitmapData.width, 40/nextBitmapData.height);
                _bitmap.bitmapData = nextBitmapData;
                _bitmap.scaleX = ratio;
                _bitmap.scaleY = ratio;
                
                _bitmap.x = 5 + (40-_bitmap.width) * .5;
                _bitmap.y = 5 + (40-_bitmap.height) * .5;
                _bitmapUnder.x = 5;
                _bitmapUnder.y = 5;
                
                _label.text = sequence.sequenceName;
                addChild(_removeBtn);
                addChild(_bitmapUnder);
                addChild(_bitmap);
                mouseEnabled = true;
                
            }
            else
            {
                if(_bitmap.parent != null)
                {
                    removeChild(_bitmap);
                }
                if(_removeBtn.parent != null)
                {
                    removeChild(_removeBtn);
                }
                if(_bitmapUnder.parent != null)
                {
                    removeChild(_bitmapUnder);
                }
                mouseEnabled = false;
                _label.text = "";
                _mouseOver = false;
                
            }
            
                
                
        }
        
        public function get sequence():Sequence
        {
            return _data as Sequence;
        }
        
    }
}