package com.inoah.ro.infos
{
    public class CharacterInfo
    {
        protected var _name:String;
        protected var _headRes:String;
        protected var _bodyRes:String;
        protected var _weaponRes:String;
        
        protected var _curHp:Number;
        protected var _maxHp:Number;
        protected var _curSp:Number;
        protected var _maxSp:Number;
        protected var _atk:Number;
        protected var _isDead:Boolean;
        protected var _isCritical:Boolean;
        
        public function CharacterInfo()
        {
        }
        
        public function init( name:String, headRes:String, bodyRes:String, weaponRes:String = "", maxHp:Number = 100 ):void
        {
            _name = name;
            _headRes = headRes;
            _bodyRes = bodyRes;
            _weaponRes = weaponRes;
            _maxHp = maxHp;
            _maxSp = 100;
            _atk = 20;
            _curHp = _maxHp;
            _curSp = _maxSp;
        }
        
        public function set isDead( value:Boolean ):void
        {
            _isDead = value;
        }
            
        public function get isDead():Boolean
        {
            return _isDead;
        }
        
        public function get atk():Number
        {
            _isCritical = Math.random() * 3 < 1
            //上下浮动20%
            var atk:Number = uint(_atk + Math.random() * _atk * 0.2 *( int(Math.random() * 2)>0?1:-1 ) ); 
            //暴击率 10%
            if( _isCritical )
            {
                atk = 2 * atk
            }
            return atk;
        }
        
        public function get isCritical():Boolean
        {
            return _isCritical;
        }
        
        public function get maxHp():Number
        {
            return _maxHp;
        }
        public function get maxSp():Number
        {
            return _maxSp;
        }
        public function get curHp():Number
        {
            return _curHp;
        }
        
        public function set curHp( value:Number ):void
        {
            _curHp = value;
        }
        
        public function get curSp():Number
        {
            return _curSp;
        }

        public function set curSp( value:Number ):void
        {
            _curSp = value;
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