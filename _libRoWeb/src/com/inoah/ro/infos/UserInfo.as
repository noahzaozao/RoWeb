package com.inoah.ro.infos
{
    

    /**
     * 玩家基本信息 
     * @author inoah
     * 
     */    
    public class UserInfo extends BattleCharacterInfo
    {
        protected var _strength:uint;
        protected var _agile:uint;
        protected var _vit:uint;
        protected var _intelligence:uint;
        protected var _dexterous:uint;
        protected var _lucky:uint;
        protected var _statusPoint:uint;
        
        protected var _zeny:uint;
        
        public function UserInfo()
        {
            
        }
        //battle
        override public function set atk( value:uint ):void
        {
            _atk = value;
        }
        override public function set matk( value:uint ):void
        {
            _matk = value;
        }
        override public function set hit( value:uint ):void
        {
            _hit = value;
        }
        override public function set critical( value:uint ):void
        {
            _critical = value;
        }
        override public function set def( value:uint ):void
        {
            _def = value;
        }
        override public function set mdef( value:uint ):void
        {
            _mdef = value;
        }
        override public function set flee( value:uint ):void
        {
            _flee = value;
        }
        override public function set aspd( value:uint ):void
        {
            _aspd = value;
        }
        
        override public function set name( value:String ):void
        {
            _name = value;
        }
        override public function set job( value:String ):void
        {
            _job = value;
        }
        
        override public function set baseLv( value:uint ):void
        {
            _baseLv = value;
        }
        override public function set jobLv( value:uint ):void
        {
            _jobLv = value;
        }
        
        override public function set baseExp( value:uint ):void
        {
            _baseExp = value;
        }
        override public function set jobExp( value:uint ):void
        {
            _jobExp = value;
        }
        
        override public function set hpCurrent( value:uint ):void
        {
            _hpCurrent = value;
        }
        override public function set hpMax( value:uint ):void
        {
        }
        override public function set spCurrent( value:uint ):void
        {
            _spCurrent = value;
        }
        override public function set spMax( value:uint ):void
        {
        }
        
        override public function set weightCurrent( value:uint ):void
        {
            _weightCurrent = value;
        }
        override public function set weightMax( value:uint ):void
        {
            _weightMax = value;
        }
        
        override public function get atk():uint
        {
            _atk = _strength * 10 + _dexterous * 5;
            return _atk;
        }
        override public function get matk():uint
        {
            _matk = _intelligence * 10 + _lucky * 5;
            return _matk;
        }
        override public function get hit():uint
        {
            _hit = _agile * 10 + _dexterous * 5;
            return _hit;
        }
        override public function get critical():uint
        {
            _critical = _lucky * 10 + _strength * 5;
            return _critical;
        }
        override public function get def():uint
        {
            _def = _vit * 10 + _dexterous * 5;
            return _def;
        }
        override public function get mdef():uint
        {
            _mdef = _intelligence * 10 + _lucky * 5;
            return _mdef;
        }
        override public function get flee():uint
        {
            _flee = _agile * 10 + _dexterous * 5;
            return _flee;
        }
        override public function get aspd():uint
        {
            _aspd = _agile * 10 + _dexterous * 5;
            return _aspd;
        }
        
        override public function get name():String
        {
            return _name;
        }
        override public function get job():String
        {
            return _job;
        }
        
        override public function get baseLv():uint
        {
            return _baseLv;
        }
        override public function get jobLv():uint
        {
            return _jobLv;
        }
        
        override public function get baseExp():uint
        {
            return _baseExp;
        }
        override public function get jobExp():uint
        {
            return _jobExp;
        }
        
        override public function get hpCurrent():uint
        {
            return _hpCurrent;
        }
        override public function get hpMax():uint
        {
            _hpMax = _baseLv * 40 + _vit * 10 + _strength * 5;
            return _hpMax;
        }
        override public function get spCurrent():uint
        {
            return _spCurrent;
        }
        override public function get spMax():uint
        {
            _spMax = _baseLv * 10 + _intelligence * 10 + _lucky * 5;
            return _spMax;
        }
        
        override public function get weightCurrent():uint
        {
            return _weightCurrent;
        }
        override public function get weightMax():uint
        {
            return _weightMax;
        }
        
        override public function get hpPer():Number
        {
            return _hpCurrent / _hpMax;
        }
        
        override public function get spPer():Number
        {
            return _spCurrent / _spMax;
        }
        //base
        public function set strength( value:uint ):void
        {
            _strength = value;
        }
        public function set agile( value:uint ):void
        {
            _agile = value;
        }
        public function set vit( value:uint ):void
        {
            _vit = value;
        }
        public function set intelligence( value:uint ):void
        {
            _intelligence = value;
        }
        public function set dexterous( value:uint ):void
        {
            _dexterous = value;
        }
        public function set lucky( value:uint ):void
        {
            _lucky = value;
        }
        public function set statusPoint( value:uint ):void
        {
            _statusPoint = value;
        }
        public function set zeny( value:uint ):void
        {
            _zeny = value;
        }
        public function get strength():uint
        {
            return _strength;
        }
        public function get agile():uint
        {
            return _agile;
        }
        public function get vit():uint
        {
            return _vit;
        }
        public function get intelligence():uint
        {
            return _intelligence;
        }
        public function get dexterous():uint
        {
            return _dexterous;
        }
        public function get lucky():uint
        {
            return _lucky;
        }
        public function get statusPoint():uint
        {
            return _statusPoint;
        }
        public function get zeny():uint
        {
            return _zeny;
        }
    }
}