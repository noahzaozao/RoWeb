package com.quadTrees
{
    import flash.utils.Dictionary;
    
    import __AS3__.vec.Vector;
    
    public class Hash {
        
        private var hash:Dictionary;
        private var _length:int;
        
        public function Hash(){
            super();
            this.hash = new Dictionary();
        }
        public function get length():int{
            return (this._length);
        }
        public function put(value:Object, key:String):void{
            if (!(this.has(key))){
                this.hash[key] = value;
                this._length++;
            };
        }
        public function has(key:String):Boolean{
            if (key == null){
                return (false);
            };
            if (this.hash[key] != null){
                return (true);
            };
            return (false);
        }
        public function remove(key:String):Object{
            var obj:Object;
            if (this.has(key)){
                obj = this.hash[key];
                delete this.hash[key];
                this._length--;
                return (obj);
            };
            return (null);
        }
        public function unload():void{
            this.hash = null;
            this._length = 0;
        }
        public function take(key:String):Object{
            return (this.hash[key]);
        }
        public function init():void{
            this.hash = new Dictionary();
            this._length = 0;
        }
        public function get hashMap():Dictionary{
            return (this.hash);
        }
        public function set hashMap(value:Dictionary):void{
            this.hash = value;
        }
        public function get values():Vector.<Object>{
            var i:String;
            var array:Vector.<Object> = new Vector.<Object>();
            for (i in this.hash) {
                array.push(this.hash[i]);
            };
            return (array);
        }
        
    }
}