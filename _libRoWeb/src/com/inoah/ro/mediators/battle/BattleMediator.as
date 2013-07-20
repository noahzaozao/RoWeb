package com.inoah.ro.mediators.battle
{
    import com.inoah.ro.consts.BattleCommands;
    import com.inoah.ro.consts.GameConsts;
    import com.inoah.ro.interfaces.ITickable;
    
    import as3.interfaces.INotification;
    import as3.patterns.mediator.Mediator;
    
    import starling.animation.IAnimatable;
    
    public class BattleMediator extends Mediator implements ITickable
    {
        protected var _animationUnitList:Vector.<IAnimatable>;
        
        public function BattleMediator( viewComponent:Object=null)
        {
            super(GameConsts.BATTLE_MEDIATOR, viewComponent);
            _animationUnitList = new Vector.<IAnimatable>();
        }
        
        override public function listNotificationInterests():Array
        {
            var arr:Array = super.listNotificationInterests();
            arr.push( BattleCommands.ATTACK );
            return arr;
        }
        
        override public function handleNotification(notification:INotification):void
        {
            var arr:Array;
            switch( notification.getName() )
            {
                case BattleCommands.ATTACK:
                {
                    arr = notification.getBody() as Array;
                    //                    onAttack( arr[0], arr[1] );
                    break;
                }
                default:
                {
                    break;
                }
            }
        }
        
        //        private function onAttack( meTarget:PlayerObject, atkTarget:PlayerObject ):void
        //        {
        //            var isCritical:Boolean = (Math.random() * 100 + meTarget.info.critical ) >= 100;
        //            var atkPoint:uint = isCritical?meTarget.info.atk * 2:meTarget.info.atk;
        //            var textField:TextField = new TextField();
        //            var tf:TextFormat = new TextFormat( "宋体" , 28 , 0xffffff );
        //            textField.defaultTextFormat = tf;
        //            textField.text =atkPoint.toString();
        //            textField.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
        //            textField.y = -50;
        //            textField.x = - textField.textWidth >> 1;
        //            atkTarget.addChild( textField );
        //            var tween:Tween = new Tween( textField , 0.6 );
        //            tween.moveTo( - textField.textWidth >> 1, - 150 );
        //            tween.onComplete = onBlooded;
        //            tween.onCompleteArgs = [textField];
        //            appendAnimateUnit( tween );
        //            
        //            atkTarget.hp -= atkPoint; 
        //            
        //            var msg:String;
        //            if( isCritical )
        //            {
        //                msg =  "<font color='#00ff00'>" + meTarget.info.name + "对" + atkTarget.info.name + "造成" + atkPoint + "伤害(爆击)</font>";
        //            }
        //            else
        //            {
        //                msg =  "<font color='#00ff00'>" + meTarget.info.name + "对" + atkTarget.info.name + "造成" + atkPoint + "伤害</font>";
        //            }
        //            facade.sendNotification( GameCommands.RECV_CHAT , [ msg ] );
        //            
        //            if(atkTarget.hp==0)
        //            {
        //                meTarget.info.baseExp += 5;
        //                msg =  "<font color='#ffff00'>" + meTarget.info.name + "获得5点经验，升级总经验" + Math.pow( meTarget.info.baseLv + 1, 3 )+ "</font>";
        //                facade.sendNotification( GameCommands.RECV_CHAT , [ msg ] );
        //                
        //                atkTarget.action = Actions.Die;
        //                tween = new Tween( atkTarget, 5 );
        //                tween.fadeTo( 0 );
        //                tween.onComplete = onRemoveAtkTarget;
        //                tween.onCompleteArgs = [atkTarget];
        //                appendAnimateUnit( tween );
        //            }
        //        }
        //        
        //        private function onBlooded( textField:TextField ):void
        //        {
        //            textField.parent.removeChild( textField );
        //        }
        //        
        //        private function onRemoveAtkTarget( atkTarget:CharacterObject ):void
        //        {
        //            D5Game.me.scene.removeObject(atkTarget);
        //        }
        
        public function appendAnimateUnit(animateUnit:IAnimatable):void
        {
            if(_animationUnitList.indexOf(animateUnit)<0)
            {
                _animationUnitList.push(animateUnit);
            }
        }
        
        public function tick( delta:Number ):void
        {
            var len:int = _animationUnitList.length;
            var animateUnit:IAnimatable;
            
            for(var i:int = 0; i<len; i++)
            {
                animateUnit = _animationUnitList[i];
                animateUnit.advanceTime(delta);
                
                if((animateUnit as Object).hasOwnProperty("isComplete") == true &&
                    animateUnit["isComplete"] == true )
                {
                    _animationUnitList.splice(i,1);
                    len--;
                    i--;
                    continue;
                }
            }
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}