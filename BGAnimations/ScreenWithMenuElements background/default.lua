local t = Def.ActorFrame {};

t[#t+1] = Def.ActorFrame {
  FOV=90;
  InitCommand=cmd(Center);
	Def.Quad {
		InitCommand=cmd(scaletoclipped,SCREEN_WIDTH,SCREEN_HEIGHT);
		OnCommand=cmd(diffuse,color("#FFFFFF"));
	};
	Def.ActorFrame {
		LoadActor("_checkerboard") .. {
			InitCommand=cmd(rotationy,-0;rotationz,-25;rotationx,0;zoomto,SCREEN_WIDTH*2,SCREEN_HEIGHT*2;customtexturerect,0,0,SCREEN_WIDTH*4/256,SCREEN_HEIGHT*4/256);
			OnCommand=cmd(texcoordvelocity,0,0.5;diffuse,color("#febce0");fadetop,0);
		};
	};	
};

return t;