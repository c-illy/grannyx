using Godot;
using System;

//  ! STUDENT VERSION !
// don't use for real grannyx : incomplete, out-of-date
// see gdscript version instead
public class CameraGrannyx : Camera2D
{
	public override void _Ready()
	{
		Godot.Collections.Array empty = new Godot.Collections.Array();
		uint deferred = (uint)Godot.Object.ConnectFlags.Deferred;
		Models.d.Connect("zoom_x_changed", this, nameof(_on_zoom_x_changed), empty, deferred);
		Models.d.Connect("zoom_y_changed", this, nameof(_on_zoom_y_changed), empty, deferred);
		GetTree().Root.Connect("size_changed", this, nameof(_on_zoom_y_changed), empty, deferred);
		_on_zoom_x_changed();
		_on_zoom_y_changed();
	}

	public void _on_zoom_x_changed()
	{
//		Zoom.x = Models.d.zoomX;
		Zoom = new Vector2(Models.d.zoomX, Zoom.y);
	}
	
	public void _on_zoom_y_changed()
	{
//		Zoom.y = Models.d.zoomY;
		Zoom = new Vector2(Zoom.x, Models.d.zoomY);
//		Transform.Origin.y = - (OS.WindowSize.y - 10) * zoom.y;
		float oldY = Transform.origin.y;
		float newY = - (OS.WindowSize.y - 10) * Zoom.y;
		MoveLocalY(newY - oldY);
	}
}
