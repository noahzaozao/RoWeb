package com.inoah.ro.objects
{
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.Objects.CharacterObject;
    
    public class PlayerObject extends CharacterObject
    {
        public function PlayerObject(ctrl:BaseControler=null)
        {
            super(ctrl);
        }
        
        override public function set action(u:int):void
        {
            _action = u;
            _displayer.action = u;
        }
        
        override public function setDirectionNum(v:int):void
        {
            _direction = v;
            _displayer.direction = v;
        }
    }
}