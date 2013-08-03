/*
** ADOBE SYSTEMS INCORPORATED
** Copyright 2012 Adobe Systems Incorporated
** All Rights Reserved.
**
** NOTICE:  Adobe permits you to use, modify, and distribute this file in accordance with the
** terms of the Adobe license agreement accompanying it.  If you have received this file from a
** source other than Adobe, then your use, modification, or distribution of it requires the prior
** written permission of Adobe.
*/
package com.inoah.ro
{
    import com.inoah.ro.starlingMain;
    
    import flash.geom.Rectangle;
    
    import starling.core.RenderSupport;
    import starling.display.DisplayObject;
    
    public class LuaDisplayObject extends DisplayObject
    {
        private var currentGame:starlingMain
        private var renderFunc:String
        
        public function LuaDisplayObject(currentGame:starlingMain, renderFunc:String)
        {
            trace("LuaDisplayObject ctor");
            super()
            touchable = false
            this.currentGame = currentGame
            this.renderFunc = renderFunc
        }
        
        public override function getBounds(targetSpace:DisplayObject, resultRect:Rectangle=null):Rectangle 
        {
            return null;
        }
        
        private function push_objref(o:*):void
        {
            var udptr:int = starlingMain.luaMain.push_flashref(currentGame.luastate)
            starlingMain.luaMain.__lua_objrefs[udptr] = o
        }
        
        public override function render(support:RenderSupport, alpha:Number):void {
            try 
            {
                starlingMain.luaMain.lua_getglobal(currentGame.luastate, renderFunc)
                push_objref(support)
                starlingMain.luaMain.lua_callk(currentGame.luastate, 1, 0, 0, null)
            }
            catch(e:*) 
            {
                currentGame.onError("Error during LuaDisplayObjectGame.render (luastate: "+currentGame.luastate+", func: "+renderFunc+"): " + e.toString())
            }
        }
    }
}
