package inoah.game.ro.objects
{
    import inoah.core.utils.GMath;
    import inoah.game.ro.consts.ConstsActions;

    public class MonsterObject extends BattleCharacterObject
    {
        public function MonsterObject()
        {
            super();
            _atkCd = 3;
            _moveCd = 3;
        }
        
        override public function tick(delta:Number):void
        {
            var isMovingX:Boolean;
            var speed:Number = 100;
            if( _endTarget )
            {
                var radian:Number = GMath.getPointAngle( _endTarget.x - posX , _endTarget.y -  posY );
                var angle:int = GMath.R2A(radian)+90;
                if( posX - _endTarget.x > 0 )
                {
                    direction = directions.Left;
                    posX -= speed * delta;
                    if(posX - _endTarget.x <= 0 )
                    {
                        posX = _endTarget.x;
                    }
                    changeDirectionByAngle( angle );
                }
                else if( posX - _endTarget.x < 0 )
                {
                    direction = directions.Right;
                    posX += speed * delta;
                    if(posX - _endTarget.x >= 0 )
                    {
                        posX = _endTarget.x;
                    }
                    changeDirectionByAngle( angle );
                }
                else
                {
                    isMovingX = true;
                }
                if( posY - _endTarget.y > 0 )
                {
                    direction = directions.Up;
                    posY -= speed * delta;
                    if(posY - _endTarget.y <= 0 )
                    {
                        posY = _endTarget.y;
                    }
                    changeDirectionByAngle( angle );
                }
                else if( posY - _endTarget.y < 0 )
                {
                    direction = directions.Down;
                    posY += speed * delta;
                    if(posY - _endTarget.y >= 0 )
                    {
                        posY = _endTarget.y;
                    }
                    changeDirectionByAngle( angle );
                }
                else
                {
                    if( isMovingX )
                    {
                        action = ConstsActions.Wait;
                    }
                }
            }
            super.tick( delta );
        }
        
        //        override public function set info( value:BattleCharacterInfo ):void
        //        {
        //            _info = value;
        //            setName( _info.name , (camp==2 ? 0xff0000 : 0xffff00), 0, -80 );
        //            hp = _info.hpCurrent;
        //            hpMax = _info.hpMax;
        //            hpBar = new HSpbar( this,'hp','hpMax',10 , 0x33ff33 );
        //            sp = _info.spCurrent;
        //            spMax = _info.spMax;
        //            spBar = new HSpbar( this,'sp','spMax',14 , 0x2868FF);
        //        }
    }
}