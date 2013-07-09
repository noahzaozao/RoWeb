package com.D5Power.Objects
{
    import com.D5Power.Controler.Actions;
    import com.D5Power.Controler.BaseControler;
    import com.D5Power.Objects.Effects.FeetStep;
    import com.D5Power.ns.ControllerAndTarget;
    
    import flash.display.DisplayObject;
    
    
    use namespace ControllerAndTarget;
    /**
     * 可控制的（具备控制器的）动画对象
     * 特性：死亡后播放死亡动画，并在制定时间内自动消失，删除
     */ 
    public class ControlActionObject extends ActionObject
    {
        /**
         * 在渲染的过程中，Y轴的调整。使用见渲染器。
         */ 
        public var renderY:int=0;
        
        /**
         * 附加物件
         */ 
        protected var _StuffList:Array;
        
        /**
         * 目标
         */ 
        public var target:ActionObject
        
        /**
         * 跟随方向
         */ 
        public var targetDirection:uint;
        
        /**
         * Lua脚本文件名
         */ 
        public var lua_filename:String='';
        
        /**
         * 脚印文件
         */ 
        public var feetFile:String='';
        
        /**
         * 脚印时间
         */ 
        protected var _feetTime:uint=0;
        
        /**
         * 脚印花费时间
         */ 
        protected var _feetSpend:uint=0;
        
        /**
         * 脚印左右脚标记
         */ 
        protected var _feetLOR:Boolean=false;		
        
        
        protected var _dieDate:uint=0;
        
        public function ControlActionObject(ctrl:BaseControler=null)
        {
            super(ctrl);
            objectName = 'ControlActionObject';
        }
        
        /**
         * 增加HP/SP显示条
         */ 
        public function addStuff(stuff:DisplayObject):void
        {
            if(_StuffList==null) _StuffList=new Array();
            if(_StuffList.indexOf(stuff)!=-1) return;
            _StuffList.push(stuff);
            addChild(stuff);
        }
        
        /**
         * 
         */ 
        public function removeStuff(id:int = -1):void
        {
            if(id==-1)
            {
                while(_StuffList.length)
                {
                    _StuffList[0].clear();
                    _StuffList.splice(0,1);
                    removeChild(_StuffList[0]);
                }
            }else{
                if(_StuffList[id]==null) return;
                _StuffList[id].clear();
                _StuffList.splice(id,1);
                removeChild(_StuffList[id]);
            }
            
        }
        
        /**
         * 获取显示条列表
         */ 
        public function get StuffList():Array
        {
            return _StuffList;
        }
        
        /**
         * 有控制器的一般是动态对象。
         * 覆盖其位置设置方法，如果位置移出了范围，且启动了四叉树检索，则重新构建节点
         */ 
        override public function setPos(px:Number,py:Number):void
        {
            super.setPos(px,py);
            if(_qTree==null) return;
            _qTree = _qTree.reinsert(this,px,py);
        }
        
        /**
         * 当非循环动作播放一次后，自动释放
         */ 
        protected function autoChangeAction():void
        {
            if(Global.DieSaveTime>0 && _dieDate==0)
            {
                _dieDate = Global.Timer+Global.DieSaveTime;
            }
        }
        
        /**
         * 脚印出现的时间间隔
         */ 
        public function set FeetTime(u:Number):void
        {
            _feetTime = int(u*Global.TPF);
        }
        
        public function makeFeetStep():void
        {
            if(feetFile=='' || _feetTime==0) return;
            
            _feetSpend++;
            if(_feetSpend>_feetTime)
            {
                _feetSpend=0;
                _feetLOR=!_feetLOR;
                var feet:FeetStep = new FeetStep(controler.perception.Scene,feetFile,this,_feetLOR);
                controler.perception.Scene.createEffect(feet);
            }
        }
        
        override public function dispose():void
        {
            _qTree = null;
            super.dispose();
        }
        
        override protected function renderAction():void
        {
            super.renderAction();
            
            if(action==Actions.Die && loopPlayEnd)
            {
                if(_dieDate>0 && Global.Timer>_dieDate)
                {
                    alpha-=0.01;
                    if(alpha<=0)
                    {
                        _controler.perception.Scene.removeObject(this);
                    }
                }
            }
            
            if(_action!=Actions.Stop && _currentFrame >= _FrameTotal-1 && !_loop) autoChangeAction();
        }
    }
}