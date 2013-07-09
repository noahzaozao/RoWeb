package com.D5Power.core
{
    public class D5ScriptCommand
    {
        /**
         * 普通命令
         */ 
        public static const COMMAND:uint = 0;
        /**
         * 条件判断
         */ 
        public static const IF:uint = 1;
        /**
         * 分支语句
         */ 
        public static const SWITCH:uint = 2;
        /**
         * 循环语句
         */ 
        public static const FOR:uint = 3;
        /**
         * 等待条件达成
         */ 
        public static const WAITFOR:uint = 4;
        
        private var _type:uint;
        
        private var _command:String;
        
        private var _params:Array;
        
        private var _commandList:Vector.<D5ScriptCommand>;
        
        public function D5ScriptCommand(type:uint=0)
        {
            _type=type;
        }
        
        
        public function get type():uint
        {
            return _type;
        }
        
        public function addCommand(data:D5ScriptCommand):void
        {
            if(_commandList==null) _commandList = new Vector.<D5ScriptCommand>;
            _commandList.push(data);
        }
        
        public function set command(s:String):void
        {
            _command = s;
        }
        
        public function get command():String
        {
            return _command;
        }
        
        public function get commandList():Vector.<D5ScriptCommand>
        {
            return _commandList;
        }
        
        public function set params(arr:Array):void
        {
            _params = arr;
        }
        
        public function get params():Array
        {
            return _params;
        }
        
        public function toString():String
        {
            var result:String = "[D5ScriptCommand] type:"+_type+",command:"+_command+',params:['+_params+'],sonCommand:';
            if(_commandList!=null)
            {
                for each(var obj:D5ScriptCommand in _commandList) result += "\n >> type:"+obj.type+",command:"+obj.command+',params:['+obj.params+']';
            }
            return result;
        }
    }
}