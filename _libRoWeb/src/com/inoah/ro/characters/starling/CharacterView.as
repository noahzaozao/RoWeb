package com.inoah.ro.characters.starling
{
    import com.D5Power.graphics.ISwfDisplayer;
    
    import flash.display.Bitmap;
    import flash.display.Shape;
    
    import starling.display.Sprite;
    
    public class CharacterView extends Sprite implements ISwfDisplayer
    {
        protected var _isPlayEnd:Boolean;
        
        public function CharacterView()
        {
        }
        
        /**
         * 渲染接口
         */ 
        public function renderMe():void
        {
            
        }
        
        /**
         * 更换SWF接口
         */ 
        public function changeSWF(f:String,needMirror:Boolean=false):void
        {
            
        }
        
        /**
         * 更换动作接口
         */ 
        public function set action(v:int):void
        {
            
        }
        
        /**
         * 更换方向接口
         */ 
        public function set direction(v:int):void
        {
            
        }
        
        public function get monitor():Bitmap
        {
            return null;
        }
        
        public function get shadow():Shape
        {
            return null;
        }
        
        public function set isPlayEnd( value:Boolean ):void
        {
            
        }
        
        public function get isPlayEnd():Boolean
        {
            return _isPlayEnd;
        }
        
        public function setChooseCircle( bool:Boolean ):void
        {
            
        }
    }
}