package inoah.gameEditor.panels
{
    import flash.display.DisplayObjectContainer;
    
    import inoah.gameEditor.consts.GameConsts;
    
    public class CharacterEditorPanel extends BasePanel
    {
        public function CharacterEditorPanel(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window")
        {
            super(parent, xpos, ypos, title);
        }
        
        override protected function init():void
        {
            super.init();
        }
        
        override public function getMediatorName():String 
        {	
            return GameConsts.CHARACTER_EDITOR;
        }
    }
}