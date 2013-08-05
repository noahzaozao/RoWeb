package inoah.game.ro.infos
{
    /**
     * 角色战斗数据 
     * @author inoah
     */    
    public class BattleCharacterInfo extends CharacterInfo
    {
        protected var _name:String;
        protected var _job:String;
        protected var _jobIndex:uint;
        
        protected var _baseLv:uint;
        protected var _baseExp:uint;
        protected var _jobLv:uint;
        protected var _jobExp:uint;
        
        protected var _hpCurrent:uint;
        protected var _hpMax:uint;
        protected var _spCurrent:uint;
        protected var _spMax:uint;
        protected var _weightCurrent:uint;
        protected var _weightMax:uint;
        
        protected var _atk:uint;
        protected var _matk:uint;
        protected var _hit:uint;
        protected var _critical:uint;
        protected var _def:uint;
        protected var _mdef:uint;
        protected var _flee:uint;
        protected var _aspd:uint;
        
        public function BattleCharacterInfo()
        {
        }
        
        public function set atk( value:uint ):void
        {
            _atk = value;
        }
        public function set matk( value:uint ):void
        {
            _matk = value;
        }
        public function set hit( value:uint ):void
        {
            _hit = value;
        }
        public function set critical( value:uint ):void
        {
            _critical = value;
        }
        public function set def( value:uint ):void
        {
            _def = value;
        }
        public function set mdef( value:uint ):void
        {
            _mdef = value;
        }
        public function set flee( value:uint ):void
        {
            _flee = value;
        }
        public function set aspd( value:uint ):void
        {
            _aspd = value;
        }
        
        public function set name( value:String ):void
        {
            _name = value;
        }
        public function set job( value:String ):void
        {
            _job = value;
        }
        
        public function set baseLv( value:uint ):void
        {
            _baseLv = value;
        }
        public function set jobLv( value:uint ):void
        {
            _jobLv = value;
        }
        
        public function set baseExp( value:uint ):void
        {
            _baseExp = value;
        }
        public function set jobExp( value:uint ):void
        {
            _jobExp = value;
        }
        
        public function set hpCurrent( value:uint ):void
        {
            if( _hpCurrent != value )
            {
                if( value <= _hpMax )
                {
                    _hpCurrent = value;
                }
                else
                {
                    _hpCurrent = _hpMax;
                }
            }
        }
        public function set hpMax( value:uint ):void
        {
            if( _hpMax != value )
            {
                _hpMax = value;
            }
        }
        public function set spCurrent( value:uint ):void
        {
            if( _spCurrent != value )
            {
                if( value <= _spMax )
                {
                    _spCurrent = value;
                }
                else
                {
                    _spCurrent = _spMax;
                }
            }
        }
        public function set spMax( value:uint ):void
        {
            if( _spMax != value )
            {
                _spMax = value;
            }
        }
        
        public function set weightCurrent( value:uint ):void
        {
            _weightCurrent = value;
        }
        public function set weightMax( value:uint ):void
        {
            _weightMax = value;
        }
        
        public function get atk():uint
        {
            return _atk;
        }
        public function get matk():uint
        {
            return _matk;
        }
        public function get hit():uint
        {
            return _hit;
        }
        public function get critical():uint
        {
            return _critical;
        }
        public function get def():uint
        {
            return _def;
        }
        public function get mdef():uint
        {
            return _mdef;
        }
        public function get flee():uint
        {
            return _flee;
        }
        public function get aspd():uint
        {
            return _aspd;
        }
        
        public function get name():String
        {
            return _name;
        }
        public function get job():String
        {
            return _job;
        }
        
        public function get baseLv():uint
        {
            return _baseLv;
        }
        public function get jobLv():uint
        {
            return _jobLv;
        }
        
        public function get baseExp():uint
        {
            return _baseExp;
        }
        public function get jobExp():uint
        {
            return _jobExp;
        }
        
        public function get hpCurrent():uint
        {
            return _hpCurrent;
        }
        public function get hpMax():uint
        {
            return _hpMax;
        }
        public function get spCurrent():uint
        {
            return _spCurrent;
        }
        public function get spMax():uint
        {
            return _spMax;
        }
        
        public function get weightCurrent():uint
        {
            return _weightCurrent;
        }
        public function get weightMax():uint
        {
            return _weightMax;
        }
        
        public function get hpPer():Number
        {
            return _hpCurrent / _hpMax;
        }
        
        public function get spPer():Number
        {
            return _spCurrent / _spMax;
        }
    }
}