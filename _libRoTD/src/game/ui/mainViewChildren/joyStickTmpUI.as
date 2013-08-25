/**Created by Morn,Do not modify.*/
package game.ui.mainViewChildren {
	import morn.core.components.*;
	public class joyStickTmpUI extends Dialog {
		public var btnAttack:Button;
		public var btnUpLeft:Button;
		public var btnUpRight:Button;
		public var btnDownLeft:Button;
		public var btnDownRight:Button;
		public var btnUp:Button;
		public var btnDown:Button;
		public var btnRight:Button;
		public var btnLeft:Button;
		protected var uiXML:XML =
			<Dialog>
			  <Button skin="png.comp.button" x="695" y="560" width="80" height="80" alpha="0.5"/>
			  <Button skin="png.comp.button" x="816" y="496" width="144" height="144" var="btnAttack" name="btnAttack" alpha="0.5"/>
			  <Button skin="png.comp.button" x="880" y="400" width="80" height="80" alpha="0.5"/>
			  <Button skin="png.comp.button" x="780" y="400" width="80" height="80" alpha="0.5"/>
			  <Button skin="png.comp.button" x="17" y="395" width="80" height="80" var="btnUpLeft" name="btnUpLeft" alpha="0.5"/>
			  <Button skin="png.comp.button" x="177" y="395" width="80" height="80" var="btnUpRight" name="btnUpRight" alpha="0.5"/>
			  <Button skin="png.comp.button" x="17" y="555" width="80" height="80" var="btnDownLeft" name="btnDownLeft" alpha="0.5"/>
			  <Button skin="png.comp.button" x="177" y="555" width="80" height="80" var="btnDownRight" name="btnDownRight" alpha="0.5"/>
			  <Button skin="png.comp.button" x="97" y="395" width="80" height="80" var="btnUp" name="btnUp" alpha="0.5"/>
			  <Button skin="png.comp.button" x="97" y="555" width="80" height="80" var="btnDown" name="btnDown" alpha="0.5"/>
			  <Button skin="png.comp.button" x="177" y="475" width="80" height="80" var="btnRight" name="btnRight" alpha="0.5"/>
			  <Button skin="png.comp.button" x="17" y="475" width="80" height="80" var="btnLeft" name="btnLeft" alpha="0.5"/>
			  <Button label="l" skin="png.comp.button" x="695" y="461" width="80" height="80" alpha="0.5"/>
			  <Button label="l" skin="png.comp.button" x="595" y="560" width="80" height="80" alpha="0.5"/>
			  <Button label="l" skin="png.comp.button" x="495" y="560" width="80" height="80" alpha="0.5"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}