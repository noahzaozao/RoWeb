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
                _bodyView.loop = true;
                _bodyView.tick( delta );
            }
        }
        
        public function setActionIndex( value:uint ):void
        {
            _currentIndex = value;
            _bodyView.actionIndex = _currentIndex + _dirIndex;
            if( _headView )
            {
                _headView.actionIndex = _currentIndex + _dirIndex;
            }
            if( _weaponView )
            {
                _weaponView.actionIndex = _currentIndex + _dirIndex;
            }
        }
    }
}