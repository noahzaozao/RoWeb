package com.inoah.ro.objects
{
    import com.inoah.ro.infos.BattleCharacterInfo;
    
    public class BattleCharacterObject extends CharacterObject
    {
        protected var _info:BattleCharacterInfo;
        
        public function BattleCharacterObject()
        {
            super();
        }
        
        //        override public function set hp(val:int):void
        //        {
        //            _info.hpCurrent = val>0 ? val : 0;
        //            _hp = _info.hpCurrent;
        //            hpMax = _info.hpMax;
        //            if(_hpBar!=null)
        //            {
        //                _hpBar.update();
        //            }
        //        }
        //        
        //        override public function get hp():int
        //        {
        //            return _info.hpCurrent;
        //        }
        //        
        //        override public function set sp(val:int):void
        //        {
        //            _info.spCurrent = val>0 ? val : 0;
        //            _sp = _info.spCurrent;
        //            spMax = _info.spMax;
        //            if(_spBar!=null)
        //            {
        //                _spBar.update();
        //            }
        //        }
        //        
        //        override public function get sp():int
        //        {
        //            return _info.spCurrent;
        //        }
        //        
        //        public function set info( value:BattleCharacterInfo ):void
        //        {
        //            _info = value;
        //            setName( _info.name ,-1,0,-110);
        //            hp = _info.hpCurrent;
        //            hpMax = _info.hpMax;
        //            hpBar = new HSpbar( this,'hp','hpMax',10 , 0x33ff33 );
        //            sp = _info.spCurrent;
        //            spMax = _info.spMax;
        //            spBar = new HSpbar( this,'sp','spMax',14 , 0x2868FF);
        //        }
        
        public function get info():BattleCharacterInfo
        {
            return _info;
        }
    }
}