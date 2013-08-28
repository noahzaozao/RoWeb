package inoah.core.infos
{
    import flash.events.EventDispatcher;
    
    import inoah.interfaces.info.ICharacterInfo;

    /**
     * 角色形象数据 
     * @author inoah
     */    
    public class CharacterInfo extends EventDispatcher implements ICharacterInfo
    {
        protected var _headRes:String;
        protected var _bodyRes:String;
        protected var _weaponRes:String;
        protected var _weaponShadowRes:String;
        protected var _isPlayer:Boolean;
        
        public function CharacterInfo()
        {
        }
        
        public function init( headRes:String, bodyRes:String, isPlayer:Boolean = false ):void
        {
            _headRes = headRes;
            _bodyRes = bodyRes;
            _isPlayer = isPlayer;
        }
        
        public function get isPlayer():Boolean
        {
            return _isPlayer;
        }
        public function get headRes():String
        {
            return _headRes;
        }
        public function get bodyRes():String
        {
            return _bodyRes;
        }
        public function get weaponRes():String
        {
            return _weaponRes;
        }
        public function get weaponShadowRes():String
        {
            return _weaponShadowRes;
        }
        public function setHeadRes( value:String ):void
        {
            _headRes = value;
        }
        public function setWeaponShadowRes( value:String ):void
        {
            _weaponShadowRes = value;
        }
        public function setWeaponRes( value:String ):void
        {
            _weaponRes = value;
        }
        public function setBodyRes( value:String ):void
        {
            _bodyRes = value;
        }
        
        public function get isReady():Boolean
        {
            return (_headRes!="")&&(_headRes!=null)&&(_bodyRes!="")&&(_bodyRes!=null);
        }
    }
}