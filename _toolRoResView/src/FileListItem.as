package
{
    import com.bit101.components.ListItem;
    
    import flash.display.DisplayObjectContainer;
    
    public class FileListItem extends ListItem
    {
        public function FileListItem(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object=null)
        {
            super(parent, xpos, ypos, data);
        }
        
        protected override function init() : void
        {
            super.init();
        }
        
        public override function draw() : void
        {
            super.draw();
        }
        
        public override function set data(value:Object):void
        {
            _data = value;
            invalidate();
        }
        
        public override function get data():Object
        {
            return _data;
        }
    }
}