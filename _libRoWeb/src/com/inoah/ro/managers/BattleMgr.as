package com.inoah.ro.managers
{
    import com.inoah.ro.characters.CharacterView;
    import com.inoah.ro.interfaces.IMgr;
    import com.inoah.ro.uis.TopText;
    
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.geom.Point;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getTimer;
    
    import starling.animation.IAnimatable;
    import starling.animation.Tween;
    
    public class BattleMgr implements IMgr
    {
        private var _root:Sprite;
        private var _animationUnitList:Vector.<IAnimatable>;
        
        public function BattleMgr( root:Sprite )
        {
            _root = root;
            _animationUnitList = new Vector.<IAnimatable>();
        }
        
        /**
         * 进行一次攻击判定 
         * @param atkView
         * @param hitView
         */        
        public function attack( atkView:CharacterView, hitView:CharacterView ):void
        {
            TopText.show(  + getTimer()  + "[attack] " +atkView.charInfo.name + " 对 " + hitView.charInfo.name + " 造成 " + atkView.charInfo.atk + "点伤害 " ); 
            hitView.charInfo.curHp -= atkView.charInfo.atk;
            getText( atkView.charInfo.atk , hitView, atkView.charInfo.isCritical );
            if( hitView.charInfo.curHp <= 0 )
            {
                hitView.charInfo.curHp = 0;
                hitView.charInfo.isDead = true;
            }
        }
        
        private function getText( atk:Number , hitView:CharacterView, isCritical:Boolean ):void
        {
            var textField:TextField = new TextField();
            var tf:TextFormat;
            if( !isCritical )
            {
                tf = new TextFormat( "宋体" , 24 , 0xffffff );
                textField.filters = [new GlowFilter( 0, 1, 2, 2, 5, 1)];
            }
            else
            {
                tf = new TextFormat( "宋体" , 36 , 0xffff00 );
                textField.filters = [new GlowFilter( 0, 1, 3, 3, 5, 1)];
            }
            textField.mouseEnabled = false;
            textField.defaultTextFormat = tf;
            textField.text = atk.toString();
            var startPos:Point = new Point( hitView.x - textField.textWidth / 2, hitView.y + hitView.headTopContainer.y );
            textField.x = startPos.x;
            textField.y = startPos.y;
            _root.addChild( textField );
            
            var tween:Tween = new Tween( textField , 1 );
            tween.moveTo( startPos.x , startPos.y - 100 );
            tween.fadeTo( 0.5 );
            tween.onComplete = onTxtTweenComplete;
            tween.onCompleteArgs = [textField];
            appendAnimateUnit( tween );
        }
        
        private function onTxtTweenComplete( textField:TextField ):void
        {
            textField.parent.removeChild( textField );
        }
        
        protected function killTweensOf(target:Object):void
        {
            var tween:Tween;
            var len:int = _animationUnitList.length;
            for(var i:int = 0; i<len; i++)
            {
                tween = _animationUnitList[i] as Tween;
                if(tween!=null && tween.target == target)
                {
                    _animationUnitList.splice(i,1);
                    return;
                }
            }
        }
        
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
            
            for( var i:int = 0; i<len; i++)
            {
                animateUnit = _animationUnitList[i];
                animateUnit.advanceTime( delta );
                
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
        
        public function dispose():void
        {
        }
        
        public function get isDisposed():Boolean
        {
            return false;
        }
    }
}