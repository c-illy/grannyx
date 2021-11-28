using Godot;
using System;

//  ! STUDENT VERSION !
// don't use for real grannyx : incomplete, out-of-date
// see gdscript version instead
public class Column : Node2D
{
	[Export]
	public PackedScene UnitSprite;
	[Export]
	public PackedScene EdgesColumn;

	[Export]
	public int unitsCount = 1;
	
	private int tmpUnitsCount = 0;

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(float delta)
	{
		//fill column bottom with individual units
		for(int i=0; (i<delta*1000) && (tmpUnitsCount < unitsCount); i++)
		{
			Sprite u = (Sprite)UnitSprite.Instance();
			AddChild(u);
			if(unitsCount == 1)
			{
				Models.d.unitHeight = (int)(u.Scale.y);
			}
//			u.Position.y = - Models.unitHeight * tmpUnitsCount * 3;
			u.MoveLocalY(- Models.d.unitHeight * tmpUnitsCount * 3);
			((GradientTexture)(u.Texture)).Width = Models.d.unitWidth;
			tmpUnitsCount ++;
		}

		//end, add edges and unregister _process() method
		if(tmpUnitsCount == unitsCount)
		{
			int x = GetIndex();
			if((0 < x) && (x < 3))
			{
				EdgesColumn e = (EdgesColumn)EdgesColumn.Instance();
				e.edgesCount = unitsCount;
				e.unitHeight = Models.d.unitHeight;
				AddChild(e);
//				e.Position.x = -Models.unitWidth;
				e.MoveLocalX(-Models.d.unitWidth);
			}
			SetProcess(false);//unsignificant impact but good practice when possible
		}
	}
}
