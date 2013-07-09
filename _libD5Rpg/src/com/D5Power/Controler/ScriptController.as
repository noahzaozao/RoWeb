package com.D5Power.Controler
{
    import com.D5Power.scene.BaseScene;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    /**
     * 剧情脚本控制器
     */ 
    public class ScriptController
    {
        /**
         * 处理后的脚本逐行数组
         */ 
        protected var _script:Array;
        /**
         * 场景引用
         */ 
        protected var _scene:BaseScene;
        /**
         * 执行步骤
         */ 
        protected var _step:uint;
        /**
         * 当前一轮脚本的等待时间
         */ 
        protected var _waitTime:uint;
        /**
         * 当前一轮脚本的开始时间
         */ 
        protected var _lastTime:uint;
        
        /**
         * 当前时间
         */ 
        protected var _nowTime:uint;
        
        /**
         * 控制脚本运行的时间器
         */ 
        protected var timer:Timer;
        
        /**
         * Action的标志位
         */ 
        protected const ACTION:uint = 0;
        /**
         * Time的标志位
         */ 
        protected const TIME:uint = 1;
        /**
         * 其他参数的标志位
         */ 
        protected const PARAM_START:uint = 2;
        
        
        public var callBack:Function;
        
        /**
         * 
         * 标准脚本格式
         * "Action,Time,Params..."
         * Action		是要执行的脚本动作
         * Time			是脚本停留的时间
         * Params		所带的参数
         */ 
        
        public function ScriptController(script:String,scene:BaseScene)
        {
            _script = script.split("\n");
            
            _scene = scene;
            _step = 0;
        }
        
        public function start():void
        {
            timer = new Timer(30);
            timer.addEventListener(TimerEvent.TIMER,render);
            timer.start();
            render();
        }
        /**
         * 暂停
         */ 
        public function pause():void
        {
            if(timer.running)
            {
                timer.stop();
            }else{
                timer.start();
            }
        }
        
        /**
         * 停止
         */ 
        protected function stop():void
        {
            timer.removeEventListener(TimerEvent.TIMER,render)
            timer.stop();
            if(callBack!=null) callBack();
        }
        
        /**
         * 等待
         */ 
        protected function wait():void{}
        
        protected function render(e:TimerEvent=null):void
        {
            _nowTime = getTimer();
            if(_lastTime>0 && _nowTime-_lastTime<_waitTime) return;
            
            _lastTime = getTimer();
            
            
            var _nowCommand:Array;
            if(_script[_step]==null)
            {
                stop();
                return;
            }else{
                _nowCommand = _script[_step].split(",");
                _waitTime = _nowCommand[TIME];
            }
            
            var fun:Function = this[_nowCommand[ACTION]];
            
            if(fun==null)
            {
                stop();
                return;
            }
            
            
            if(_nowCommand.length>PARAM_START)
            {
                var _nowParams:Array = new Array();
                for(var i:uint = PARAM_START,j:int=_nowCommand.length;i<j;i++) 
                    _nowParams.push(_nowCommand[i]);
                fun(_nowParams);
            }else{
                fun();
            }
            
            
            _step++;
        }
    }
}