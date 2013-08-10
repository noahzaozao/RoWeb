package inoah.game.ro.modules.main.view
{
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    
    import inoah.core.Global;
    
    import robotlegs.bender.framework.api.ILogTarget;
    
    public class StatusBarView extends Sprite implements ILogTarget
    {
        protected var _statusTxt:TextField;
        
        public function StatusBarView()
        {
            _statusTxt = new TextField();
            _statusTxt.width = Global.SCREEN_W;
            _statusTxt.height = 24;
            _statusTxt.y = Global.SCREEN_H - 24;
            var tf:TextFormat = new TextFormat( "Arial", 18 , 0xffffff );
            tf.align = TextFormatAlign.RIGHT;
            _statusTxt.defaultTextFormat = tf;
            _statusTxt.filters = [ new GlowFilter( 0x0 , 1 , 2, 2, 5 )];
//            addChild( _statusTxt );
            _statusTxt.mouseEnabled = false;
            this.mouseChildren = false;
            this.mouseEnabled = false;
        }
        
        public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void
        {
            _statusTxt.text = message;
        }
    }
}