/**Created by Morn,Do not modify.*/
package game.ui.mainViewChildren {
	import morn.core.components.*;
	public class joystickUI extends Dialog {
		public var btnAttack:Button;
		public var btnUpLeft:Button;
		public var btnUpRight:Button;
		public var btnDownLeft:Button;
		public var btnDownRight:Button;
		public var btnUp:Button;
		public var btnDown:Button;
		public var btnRight:Button;
		public var btnLeft:Button;
		private var uiXML:XML =
			<Dialog>
			  <Button skin="png.comp.button" x="694" y="177" width="80" height="80" alpha="0.5"/>
			  <Button skin="png.comp.button" x="815" y="113" width="144" height="144" var="btnAttack" name="btnAttack" alpha="0.5"/>
			  <Button skin="png.comp.button" x="879" y="17" width="80" height="80" alpha="0.5"/>
			  <Button skin="png.comp.button" x="779" y="17" width="80" height="80" alpha="0.5"/>
			  <Button skin="png.comp.button" x="16" y="12" width="80" height="80" var="btnUpLeft" name="btnUpLeft" alpha="0.5"/>
			  <Button skin="png.comp.button" x="176" y="12" width="80" height="80" var="btnUpRight" name="btnUpRight" alpha="0.5"/>
			  <Button skin="png.comp.button" x="16" y="172" width="80" height="80" var="btnDownLeft" name="btnDownLeft" alpha="0.5"/>
			  <Button skin="png.comp.button" x="176" y="172" width="80" height="80" var="btnDownRight" name="btnDownRight" alpha="0.5"/>
			  <Button skin="png.comp.button" x="96" y="12" width="80" height="80" var="btnUp" name="btnUp" alpha="0.5"/>
			  <Button skin="png.comp.button" x="96" y="172" width="80" height="80" var="btnDown" name="btnDown" alpha="0.5"/>
			  <Button skin="png.comp.button" x="176" y="92" width="80" height="80" var="btnRight" name="btnRight" alpha="0.5"/>
			  <Button skin="png.comp.button" x="16" y="92" width="80" height="80" var="btnLeft" name="btnLeft" alpha="0.5"/>
			  <Button label="l" skin="png.comp.button" x="694" y="78" width="80" height="80" alpha="0.5"/>
			  <Button label="l" skin="png.comp.button" x="594" y="177" width="80" height="80" alpha="0.5"/>
			  <Button label="l" skin="png.comp.button" x="494" y="177" width="80" height="80" alpha="0.5"/>
			</Dialog>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}