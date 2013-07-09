package com.D5Power.core
{
    
    import com.D5Power.scene.BaseScene;
    
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    
    /**
     * D5Power 游戏脚本解析器
     */ 
    public class D5ScriptParser
    {
        protected static var _my:D5ScriptParser;
        
        private var _stage:Stage;
        
        /**
         * 变量集合
         */ 
        private var _vars:Dictionary;
        
        /**
         * 默认运行时间间隔
         */ 
        private var _runSpeed:uint = 500;
        
        /**
         * 上一次的运行时间
         */ 
        private var _lastRunTime:uint = 0;
        
        private var _loader:URLLoader;
        
        private var _request:URLRequest;
        
        private var _nowUrl:String;
        
        /**
         * 脚本终止运行标签
         */ 
        private var _break:Boolean=false;
        
        /**
         * 命令集
         */ 
        private var _command:D5ScriptCommand;
        /**
         * 解析前的脚本序列
         */ 
        private var _scriptArr:Array;
        /**
         * 解析行号
         */ 
        private var _lineno:uint;
        
        /**
         * 是否进入运行状态
         */ 
        private var _running:Boolean=false;
        
        /**
         * 运行行号
         */ 
        private var _runLine:int;
        
        /**
         * 对主场景的引用
         */ 
        protected var _scene:BaseScene;
        
        public static function get my():D5ScriptParser
        {
            if(_my==null) _my = new D5ScriptParser();
            return _my;
        }
        
        public function D5ScriptParser()
        {
            if(_my!=null) error();
            _loader = new URLLoader();
            _request = new URLRequest();
            _vars = new Dictionary();
            _my = this;
        }
        
        public function number(name:String,value:*=0):void
        {
            _vars[name] = value;
        }
        
        public function string(name:String,value:String):void
        {
            _vars[name] = value;
        }
        
        public function add(name:String):void
        {
            if(_vars.hasOwnProperty(name))
            {
                _vars[name]++;
            }else{
                trace("[D5ScriptParser] Please define "+name+" first.");
            }
        }
        
        public function print(...params):void
        {
            for(var k:String in params)
            {
                var value:String = params[k];
                if(_vars.hasOwnProperty(value)) params[k] = _vars[value];
            }
            trace(params);
        }
        
        /**
         * 等待
         */ 
        public function wait(sec:uint):void
        {
            _lastRunTime=getTimer()+sec;
            trace("[Wait]");
        }
        
        /**
         * 跳转到指定行
         */ 
        public function gotoFunc(line:uint):void
        {
            if(line>=_command.commandList.length)
            {
                throw new Error("[D5ScriptParser] can not jump to a not exist line,line no. is "+line+",total line is "+_command.commandList.length);
            }
            
            _runLine = line-1; // 由于运行完一行后，行号会自动+1，因此跳转时必须减1
        }
        
        /**
         * 从当前行开始跳转指定行
         */ 
        public function jump(number:int):void
        {
            var line:int = _runLine+number;
            if(line>=_command.commandList.length || line<0)
            {
                throw new Error("[D5ScriptParser] can not jump to a not exist line,line no. is "+line+",total line is "+_command.commandList.length);
            }
            
            _runLine = line-1;
        }
        
        /**
         * 对D5RPG场景的引用
         */ 
        public function set Scene(scene:BaseScene):void
        {
            _scene = scene;
        }
        
        /**
         * 对STAGE的引用
         */ 
        public function set stage(stg:Stage):void
        {
            _stage = stg;
        }
        
        /**
         * 更新状态
         */ 
        public function update(url:String=''):void
        {
            
            // 只有第0个任务可以纳入新手引导
            if(_nowUrl != url && url!='')
            {
                _command = null
                _nowUrl = url;
                
                _request.url = _nowUrl;
                _loader.addEventListener(Event.COMPLETE,onComplate);
                _loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
                _loader.load(_request);
                return;
            }
            
            if(_command!=null)
            {
                _break = false;
                
                if(_stage==null) throw new Error("[D5ScriptParser] can not run without stage setted.please set stage first.");
                
                start();
            }else{
                _runLine = 0;
                _lineno=0;
                _command = new D5ScriptCommand();
                Parse(_command);
                update();
            }
        }
        
        /**
         * 通过文本进行配置
         */ 
        public function configTxt(str:String):void
        {
            var reg:RegExp;
            reg = /\t/g;
            str = str.replace(reg,'');
            
            reg = /\r/g;
            str = str.replace(reg,"\n");
            
            reg = /\r\n/g;
            str = str.replace(reg,"\n");
            
            reg = /\n/g;
            
            // 初始化脚本数据
            var temp:Array = str.split(reg);
            
            _scriptArr = new Array();
            for each(var s:String in temp)
            {
                // 剔除注释
                if(s.substr(0,1)=='#' || s=='' || s=='\r' || s=='\n' || s=='\r\n') continue;
                _scriptArr.push(s);
            }
            
            
            update();
        }
        
        public function clear():void
        {
            _command = null;
        }
        
        public function stop():void
        {
            _command = null;
            pause();
        }
        
        public function pause():void
        {
            if(!_running) return;
            if(_stage) _stage.removeEventListener(Event.ENTER_FRAME,running);
            _running = false;
        }
        
        public function start():void
        {
            if(_running) return;
            if(_stage) _stage.addEventListener(Event.ENTER_FRAME,running);
            _running = true;
        }
        
        /**
         * 执行程序
         */ 
        private function running(e:Event):void
        {
            if(!_break && getTimer()-_lastRunTime>_runSpeed)
            {
                if(_runLine>=_command.commandList.length)
                {
                    pause();
                    return;
                }
                var comm:D5ScriptCommand = _command.commandList[_runLine];
                exec(comm);
                _runLine++;
            }
        }
        
        private function exec(command:D5ScriptCommand):void
        {
            var needLoop:Boolean = false;
            if(_break) return;
            switch(command.type)
            {
                case D5ScriptCommand.IF:
                    // IF语句 逻辑处理
                    if(command.params.length>1)
                    {
                        throw new Error("No Supported IF mode.There are only support ONE chance.");
                    }
                    var p:String = command.params[0];
                    // 首先取出所有的命令、函数
                    var reg:RegExp = /^[a-zA-Z_]*\([0-9a-zA-Z,]*\)|^[a-zA-Z_]*/g;
                    
                    // 第一次匹配
                    var runner:Array = p.match(reg);
                    
                    // 不包含任何符合条件的函数或参数则报错
                    if(runner==null || runner.length==0)
                    {
                        throw new Error("[D5ScriptParser] Can not found any command.");
                    }
                    
                    // 按参数/函数进行切割，剩余部分为右侧（包含运算符和判断值）
                    var params:Array = p.split(runner[0]);
                    
                    // 条件判断运算符左边的内容
                    var left:String = runner[0];
                    // 条件判断运算符
                    var doer:String;
                    // 条件判断运算符右边的内容
                    var right:String;
                    
                    // 进行二次切割，判断是否存在运算符
                    var reg2:RegExp = />|<|!=|==|>=|<=/g;
                    var runner2:Array = params[1].toString().match(reg2);
                    
                    if(runner2.length==0)
                    {
                        // 唯一命令
                        right = params[1];
                        doer = runner[0];
                    }else if(runner.length==1){
                        // 条件判断命令
                        var rightArr:Array = params[1].toString().split(runner2[0]);
                        right = rightArr[1]
                        doer = runner2[0];
                    }else{
                        // 超出支持范畴
                        throw new Error("[D5ScriptParser] There are only support ONE runner.");
                    }
                    
                    //trace(left,doer,'RIGHT:',right);
                    
                    // 处理函数
                    
                    var funreg:RegExp = /\([0-9a-zA-Z,]*\)/g;
                    var funRunner:Array = left.match(funreg);
                    // 函数参数的纯净名（不带参数的）
                    var funName:String = left.replace(funreg,'');
                    
                    if(funRunner.length>1) throw new Error("[D5ScriptParser] Function format error.");
                    
                    
                    var funParam:String;
                    
                    if(funRunner==null || funRunner.length==0)
                    {
                        funParam = '';
                    }else{
                        var funStr:String = funRunner[0];
                        funParam = funStr.substr(1,funStr.length-2);
                    }
                    
                    // 如果没有参数
                    if(funParam=='')
                    {
                        if(this.hasOwnProperty(funName))
                        {
                            left = this[funName] is Function ? this[funName]() : this[funName];
                        }else if(_vars.hasOwnProperty(funName)){
                            left = _vars[funName];
                        }else{
                            left = '0';
                        }
                    }else{
                        // 如果有参数	
                        if(this.hasOwnProperty(funName) && this[funName] is Function)
                        {
                            left = this[funName].apply(this,funParam.split(','));
                        }else{
                            left = '0';
                        }
                    }
                    
                    needLoop = true;
                    switch(doer)
                    {
                        case '>':
                            
                            trace('[D5ScriptParser] Check '+left+' > '+right);
                            if(int(left)<=int(right)) needLoop=false;
                            break;
                        case '<':
                            
                            trace('[D5ScriptParser] Check '+left+'<'+right);
                            if(int(left)>=int(right)) needLoop=false;
                            break;
                        
                        case '==':
                            
                            trace('[D5ScriptParser] Check '+left+'=='+right);
                            if(left!=right) needLoop=false;
                            break;
                        
                        case '!=':
                            
                            trace('[D5ScriptParser] Check '+left+'!='+right);
                            if(left==right) needLoop=false;
                            break;
                        
                        case '>=':
                            
                            trace('[D5ScriptParser] Check '+left+'>='+right);
                            if(int(left)<int(right)) needLoop=false;
                            break;
                        case '<=':
                            trace('[D5ScriptParser] Check '+left+'<='+right);
                            if(int(left)>int(right)) needLoop=false;
                            break;
                        default:
                            throw new Error("Can not understand your runner ",runner);
                            break;
                        
                    }
                    
                    break;
                case D5ScriptCommand.SWITCH:
                    
                    // SWITCH处理
                    var checker:* = this[command.params[0].toString()];
                    
                    for each(var son:D5ScriptCommand in command.commandList)
                {
                    
                }
                    break;
                case D5ScriptCommand.FOR:
                    // IF语句 逻辑处理
                    if(command.params.length!=2)
                    {
                        throw new Error("No Supported FOR mode.There are only support TWO params.");
                    }
                    var start:uint = command.params[0];
                    var end:uint = command.params[1];
                    
                    var list:Vector.<D5ScriptCommand> = command.commandList; 
                    if(list!=null && list.length>0)
                    {
                        for(var i:uint = start;i<end;i++)
                        {
                            for each(var obj:D5ScriptCommand in list) exec(obj);
                        }
                    }
                    
                    break;
                default:
                    
                    if(this.hasOwnProperty(command.command) && this[command.command] is Function)
                    {
                        try
                        {
                            (this[command.command] as Function).apply(this,command.params);
                        }catch(e:Error){
                            trace("[D5ScriptParser] can not run function "+command.command+",Error code:"+e.message);
                        }
                    }else{
                        trace("[D5ScriptParser] can not found the function "+command.command);
                    }
                    break;
            }
            
            if(needLoop)
            {
                var list2:Vector.<D5ScriptCommand> = command.commandList; 
                if(list2!=null && list2.length>0)
                {
                    for each(var obj2:D5ScriptCommand in list2) exec(obj2);
                }
            }
        }
        
        /**
         * 脚本词法解析
         */ 
        private function Parse(block:D5ScriptCommand=null):void
        {
            var s:String;
            var temp:Array;
            
            var breakStatus:Boolean = true;
            while(breakStatus)
            {
                s = D5ScriptAt(_scriptArr);
                if(s==null) break;
                temp = s.split(' ');
                
                
                var sblock:D5ScriptCommand=null;
                
                switch(temp[0])
                {
                    case 'if':
                        sblock = new D5ScriptCommand(D5ScriptCommand.IF);
                        Parse(sblock);
                        break;
                    case 'endif':
                        breakStatus = false;
                        break;
                    
                    
                    case 'switch':
                        sblock = new D5ScriptCommand(D5ScriptCommand.SWITCH);
                        Parse(sblock);
                        break;
                    case 'endswitch':
                        breakStatus = false;
                        break;
                    
                    case 'for':
                        sblock = new D5ScriptCommand(D5ScriptCommand.FOR);
                        Parse(sblock);
                        break;
                    case 'endfor':
                        breakStatus = false;
                        break;
                    
                    default:
                        sblock = new D5ScriptCommand();
                        break;
                }
                
                if(sblock!=null)
                {
                    sblock.command = temp.shift();
                    if(temp.length>1) throw new Error("[D5ScriptParser] Too many params.There have "+temp.length+' params.content is:'+temp);
                    sblock.params = temp[0]==null ? null : temp[0].toString().split(',');
                    block.addCommand(sblock);
                }
            }
        }
        
        private function onComplate(e:Event):void
        {
            _loader.removeEventListener(Event.COMPLETE,onComplate);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
            
            var str:String = _loader.data;
            
            configTxt(str);
            
            _loader.close();
        }
        private function onError(e:IOErrorEvent):void
        {
            trace("[D5ScriptParser] Can not found the script file.File path is "+_request.url);
            _loader.removeEventListener(Event.COMPLETE,onComplate);
            _loader.removeEventListener(IOErrorEvent.IO_ERROR,onError);
        }
        
        /**
         * 脚本词法提取
         */ 
        private function D5ScriptAt(arr:Array):String
        {
            var s:String = arr[_lineno];
            _lineno++;
            return s;
        }
        
        
        
        private function error():void
        {
            throw new Error('D5ScriptParser is a single class.can not instance again.');
        }
        
    }
}