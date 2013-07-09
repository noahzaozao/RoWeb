/**
 * D5Power Studio FPower 2D MMORPG Engine
 * 第五动力FPower 2D 多人在线角色扮演类网页游戏引擎
 * 
 * copyright [c] 2010 by D5Power.com Allrights Reserved.
 */ 
package com.D5Power.Objects
{
    import com.D5Power.Controler.BaseControler;
    
    /**
     * 可用于对象池的游戏对象接口标准
     */ 
    public interface IPoolObject
    {
        function close():void;						// 终止对象的使用
        function open(c:BaseControler):void;		// 重新启用对象
    }
}