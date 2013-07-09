package
{
    import com.D5Power.Objects.NCharacterObject;
    import com.D5Power.mission.EventData;
    import com.D5Power.utils.CharacterData;
    
    import flash.display.Sprite;
    
    [SWF(width="960",height="560",frameRate="60",backgroundColor="#000000")]
    public class ClientD5RoDemo extends Sprite
    {
        private static var _me:ClientD5RoDemo;
        
        private var _game:RoGame;
        //        private var npcDialogBox:NPCDialog;
        
        public static function get me():ClientD5RoDemo
        {
            return _me;
        }
        
        public function ClientD5RoDemo()
        {
            Global.userdata = new CharacterData();
            Global.userdata.getCanSeeMission(1);
            _me = this;
            _game = new RoGame('map1',stage);
            addChild(_game);
        }
        
        public function npcWindow(say:String,event:EventData,npc:NCharacterObject,misid:uint,type:uint=0,complate:Boolean=false):void
        {
            //            if(npcDialogBox==null)
            //            {
            //                npcDialogBox = new NPCDialog();
            //            }
            //            
            //            npcDialogBox.config(say,npc,misid,type,complate);
            //            if(!contains(npcDialogBox)) addChild(npcDialogBox);
        }
    }
}