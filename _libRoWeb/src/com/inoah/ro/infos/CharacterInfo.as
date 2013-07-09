package com.inoah.ro.infos
{
    public class CharacterInfo
    {
        protected var _name:String;
        protected var _headRes:String;
        protected var _bodyRes:String;
        protected var _weaponRes:String;
        
        public function CharacterInfo()
        {
        }
        
        public function init( name:String, headRes:String, bodyRes:String, weaponRes:String = "", maxHp:Number = 100 ):void
        {
            _name = name;
            _headRes = headRes;
            _bodyRes = bodyRes;
            _weaponRes = weaponRes;
        }
        
        public function get name():String
        {
            return _name;
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
        public function setHeadRes( value:String ):void
        {
            _headRes = value;
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