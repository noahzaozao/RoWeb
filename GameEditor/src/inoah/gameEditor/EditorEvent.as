package inoah.gameEditor
{
    import flash.events.Event;

    public class EditorEvent extends Event
    {
        public static const OPEN_EDITOR:String = "EditorCommands.OPEN_EDITOR";
        
        public var panelName:String;
        
        public function EditorEvent( type:String , panelName:String )
        {
            super( type );
            this.panelName = panelName;
        }
            
    }
}