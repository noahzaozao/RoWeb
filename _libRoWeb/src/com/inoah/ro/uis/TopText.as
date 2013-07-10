package com.inoah.ro.uis
{
    import com.inoah.ro.utils.Counter;
    
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    
    public class TopText
    {
        private static var _tipTxt:TextField;
        private static var _topTxt:TextField;
        private static var _clearLineCounter:Counter;
        private static var _contentStr:String;
        
        public static function init():void
        {
            _clearLineCounter = new Counter();
            _clearLineCounter.initialize();
            _clearLineCounter.reset( 10 );
            _tipTxt = new TextField();
            _tipTxt.width = 960;
            var tf:TextFormat = new TextFormat( "宋体", 16, 0xffff00 );
            _tipTxt.defaultTextFormat = tf;
            _tipTxt.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            _tipTxt.text = "操作说明 鼠标左键[移动,攻击] 键盘施放技能";
            _tipTxt.mouseEnabled = false;
            
            _topTxt = new TextField();
            _topTxt.y = 30;
            _topTxt.width = 960;
            _topTxt.height = 500;
             tf = new TextFormat( "宋体", 14, 0x00ff00 );
            _topTxt.defaultTextFormat = tf;
            _topTxt.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            _topTxt.mouseEnabled = false;
            _topTxt.alpha = 0.6;
            _contentStr = "";
        }
        
        public static function get tipTextField():TextField
        {
            return _tipTxt;
        }
        public static function get textField():TextField
        {
            return _topTxt;
        }
        
        public static function show( str:String ):void
        {
            _contentStr += str + "\n";
        }
        
        public static function tick( delta:Number ):void
        {
            _clearLineCounter.tick( delta );
            if( _clearLineCounter.expired )
            {
                var index:int = _contentStr.indexOf( "\n" );
                _contentStr = _contentStr.slice( index + 1 );
                _clearLineCounter.reset( 10 );
            }
            if( _topTxt.text != _contentStr )
            {
                _topTxt.text =  _contentStr;
                while( _contentStr.split( "\n" ).length > 15 )
                {
                    index= _contentStr.indexOf( "\n" );
                    _contentStr = _contentStr.slice( index + 1 );
                }
            }
        }
    }
}