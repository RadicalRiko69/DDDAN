--[[
This is where you put in your text.
Commands are applied at the beginning of the text because I can't write a scripting langauge for shit
Supported commands:
/c[color] - Sets color of the text
/mc[name,arg] - play a message command. Ex: /mc[LeftSide,4] will broadcast "LeftSide" with a parameter of 4
/dim[command] - Broadcasts VNDim with an argument of command. Mostly used for dimming the portraits.

]]
local texttable2 = {
	"It’s a beautiful day outside, birds are singing, flowers are blooming. On days like these, I just want to listen to some good music with my best friend Sayori.",
	"/mc[Appear]/mc[LeftSide]/mc[Name,Sayori]Hah...hah...I MADE IT!! I MADE IT!! ARE YOU PROUD OF ME?!",
	"/mc[Name,You]Don't yell so loud, I can hear you just fine!",
	"/mc[Name,Sayori]/mc[LeftSide,emi_basic_confused]WHAT?!"
	--[["/mc[LeftSide,4]/mc[SE,Arc_S0AA001]Although, cherry blossoms during the summer is too much. Wouldn't you agree, Mister?",
	"/mc[RightSide,0]/mc[SE,Arc_S0AA002]/mc[Appear]/dim[0]Yes...... monsters and cherry blossoms.\nBut tell me, who is the real monster here?",
	"/mc[SE,Arc_S0AA003]You, or I? The devil in the form of a beautiful woman,\nor the human with the looks of an unrelenting monster?",
	"/mc[SE,Arc_S0AA004]Then again, to everyone else, well―――\nI suppose one could call me a demon after all.",
	"/mc[LeftSide,8]/mc[SE,Arc_S0AA005]/dim[1]We're not so different on the inside, so what does it matter? Though―――you look more like the shadow of a monster.",
	"/mc[SE,Arc_S0AA006]/dim[0]As I thought.\nEverything's hazy, as if I were dreaming.",
	"/mc[SE,Arc_S0AA007]Meeting you must be the work of fate. Could you help me feel alive again?",
	"/mc[LeftSide,4]/mc[SE,Arc_S0AA008]/dim[1]Sure thing. But since you inturrupted my flower viewing, don't expect me to go easy on you.",
	"/mc[SE,Arc_S0AA009]/dim[0]I'd like nothing less. If my body can't awaken from this battle, it'd be best if I disappeared entirely from this world.",
	"/mc[SE,Arc_S0AA010]Against a foe like you, I may experience not the feeling of life, but of death."]]
}

local pos = 1;

local vntext = LoadVNText2();
local f;

local function VN_input_handler(event)
	--Check if player clicked screen, then skip to next screen if they did.
	local pn= event.PlayerNumber
	local button = event.button
	-- If the PlayerNumber isn't set, the button isn't mapped.  Ignore it.
	-- ...Unless it's the mouse.
	if not pn and event.DeviceInput.is_mouse == false then return end
	if event.DeviceInput.is_mouse then
		button = ToEnumShortString(event.DeviceInput.button)
	end
	-- If it's a release, ignore it.
	if event.type == "InputEventType_Release" then return end
	
	if button == "left mouse button" or button == "Start" then
		if not vntext:is_finished() then
			vntext:skip();
			--sleep(1);
		else
			if vntext:no_more_text() then
				--SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
			else
				pos = pos + 1;
				vntext:advance()
			end;
		end;
	elseif button == "Back" or button == "right mouse button" then
		SCREENMAN:AddNewScreenToTop("ScreenStoryOptions");
		MESSAGEMAN:Broadcast("OptionsScreenOn");
	elseif button == "Select" then
		pos = pos + 1;
		--vntext:skip();
		vntext:advance();
	else
		--tostring(vntext:no_more_text())
		SCREENMAN:SystemMessage(button);
	end;
end;


local TEXTBOX_HEIGHT = 150;
local t = Def.ActorFrame{

	--[[VNQuitMessageCommand=function(self)
		SCREENMAN:SetNewScreen("ScreenInit");
		SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen");
	end;]]

	InitCommand=function(self)
		--Set the enemy character for the next song.
		--MBSTATE:SetEnemyCharacter("KishimaKouma");
		--Set random encounters for the rest of arcade mode.
		--MBSTATE:SetRandomEncounterList({"Satsuki","Len","Hisui","Kohaku","Aozaki","AkihaVermillion"});
	end;

	OnCommand=function(self)
		--Add input handler
		SCREENMAN:GetTopScreen():AddInputCallback(VN_input_handler);
		--Make this ActorFrame accessible throughout the file
		f = self;
	end;

	Def.Sprite{
		Name="Background";
		Texture=GetPathVN("Backgrounds/suburb_roadcenter.jpg");
		InitCommand=cmd(Cover;diffusealpha,1);
	};
	
	Def.Sound{
		Name="Audio";
		File=GetPathVN("Music/1.mp3");
		SupportPan=false;
		IsAction=false;
		OnCommand=cmd(play);
		
	};
	
	Def.Sprite{
		Name="LeftSide";
		InitCommand=cmd(vertalign,bottom;xy,SCREEN_CENTER_X/2,SCREEN_BOTTOM;zoom,1);
		LeftSideMessageCommand=function(self,param)
			if param then
				self:Load(GetPathVN("Portrait/"..param[1]..".png"));
			else
				self:Load(GetPathVN("Portrait/emi_basic_closedsweat.png"));
			end;
		end;
		VNDimMessageCommand=function(self,param)
			if param[1] == '0' then
				self:VN_Dim()
			else
				self:VN_Undim()
			end
		end;
	};
	
	Def.Sprite{
		Name="RightSide";
		InitCommand=cmd(rotationy,180;vertalign,bottom;xy,SCREEN_WIDTH*.75,SCREEN_BOTTOM;zoom,1.5);
		RightSideMessageCommand=function(self,param)
			--SCREENMAN:SystemMessage(GetPathVN("notexture (doublres).png"));
			self:Load(GetPathVN("notexture (doubleres).png"));
		end;
		VNDimMessageCommand=function(self,param)
			if param[1] == '1' then
				self:VN_Dim()
			else
				self:VN_Undim()
			end
		end;
		
	};
	--[[Def.Quad{
		InitCommand=cmd(setsize,400,3;fadeleft,.5;faderight,.5;xy,SCREEN_CENTER_X/2+50,SCREEN_HEIGHT*.95+5;diffuse,Color("White"));
	};
	Def.Quad{
		InitCommand=cmd(zoomx,0;setsize,400,3;fadeleft,.5;faderight,.5;xy,SCREEN_WIDTH*.75-50,SCREEN_HEIGHT*.95+5;diffuse,Color("White"));
		AppearMessageCommand=cmd(decelerate,.6;zoomx,1);
	};]]

};

t[#t+1] = Def.ActorFrame{

	--[[genTextBackground(130)..{
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-95;vertalign,top;)
	};]]
	
	Def.Sprite{
		Texture=THEME:GetPathG("","TextBox/Name");
		InitCommand=cmd(xy,SCREEN_CENTER_X-200,SCREEN_BOTTOM-180;diffuse,color("#ff9ef2aa");zoom,.9);
	};
	
	Def.Sprite{
		Texture=THEME:GetPathG("","TextBox/Front");
		InitCommand=cmd(xy,SCREEN_CENTER_X-200,SCREEN_BOTTOM-180;zoom,.9);
	};
	LoadFont("_aller 20px")..{
		Name="Name";
		--Text="You";
		InitCommand=cmd(xy,SCREEN_CENTER_X/2-30,SCREEN_BOTTOM-100-150/2;addx,100;halign,0;vertalign,bottom;diffusebottomedge,color("#ff9ef2ff");diffusealpha,0);
		OnCommand=cmd(decelerate,.6;addx,-120;diffusealpha,1);
		NameMessageCommand=function(self,param)
			self:settext(param[1]);
		end;
	};
	
	Def.Sprite{
		Texture=THEME:GetPathG("","TextBox/Background");
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-100;diffuse,color("#ff9ef2ff");zoom,.9);
	};
	Def.Sprite{
		Texture=THEME:GetPathG("","TextBox/Frame");
		InitCommand=cmd(xy,SCREEN_CENTER_X,SCREEN_BOTTOM-100;zoom,.9);
	};
	Def.BitmapText{
		Font="_aller thin";
		Text=THEME:GetString("ScreenStory","HelpText");
		InitCommand=cmd(diffuse,color("#63445fff");xy,SCREEN_CENTER_X,SCREEN_BOTTOM-42;zoom,.75);
	};
	--Make vntext here
	--function(font, text, maxwidth, spd, clr)
	vntext:make_actor("_aller 20px", texttable2, 640*.85, 50, Color("White"))..{
		InitCommand=cmd(xy,SCREEN_CENTER_X-(640*.85)/2,SCREEN_BOTTOM-140);
	};
	
	--[[LoadActor(THEME:GetPathS("","73 (loop)"))..{
		OnCommand=cmd(play);
	};]]
	
	Def.Sound{
		Name="Voice";
		SEMessageCommand=function(self,param)
			--If we use THEME:GetPathS() StepMania will complain that the sound is missing. We want it to work even without any sound effects.
			local snd = "/"..THEME:GetCurrentThemeDirectory().."/Sounds/story_se/"..param[1]..".ogg";
			if FILEMAN:DoesFileExist(snd) then
				self:load(snd);
				self:play();
			end;
		end;
	};
};

return t;
