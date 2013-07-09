package
{
    import com.inoah.ro.characters.CharacterView;
    import com.inoah.ro.infos.CharacterInfo;
    
    public class ECharacterView extends CharacterView
    {
        public function ECharacterView(charInfo:CharacterInfo=null)
        {
            super(charInfo);
        }
        
        override public function tick(delta:Number):void
        {
            if( _bodyView )
            {
                _bodyView.tick( delta );
            }
        }
    }
}