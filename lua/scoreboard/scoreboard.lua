AddCSLuaFile()
local lply
local drawn=false
local scrbrd={
	avatar={},
	name={},
	flag={},
	clock={},
	profile={},
}
local drm={
	scoreboard={},
	extrainfo={
		function(i)
			draw.Text({
				text="Edicts: "..Entity(0):GetNWInt("edicts", "N/A"),
				font="fornames",
				pos={ScrW()-100,ScrH()-200+(i-1)*20},
				xalign=TEXT_ALIGN_LEFT,
				yalign=TEXT_ALIGN_CENTER,
				color=HSVToColor(20,Entity(0):GetNWInt("edicts")*0.00012207031,1)
			})
		end,
		function(i)
			draw.Text({
				text="TPS: "..math.Round(1/engine.ServerFrameTime()),
				font="fornames",
				pos={ScrW()-100,ScrH()-200+(i-1)*20},
				xalign=TEXT_ALIGN_LEFT,
				yalign=TEXT_ALIGN_CENTER,
				color=HSVToColor(20,1-(math.Clamp(1/engine.ServerFrameTime(),0,66)*0.01515151515),1)
			})
		end,
		function(i)
			draw.Text({
				text="Entities: "..#ents.GetAll(),
				font="fornames",
				pos={ScrW()-100,ScrH()-200+(i-1)*20},
				xalign=TEXT_ALIGN_LEFT,
				yalign=TEXT_ALIGN_CENTER,
				color=Color(255,255,255,255)
			})
		end
	}
}
surface.CreateFont("title",{font="DermaLarge",size=30,antialias=false,outline=true,weight=1000})
surface.CreateFont("fornames",{font="HudHintTextLarge",size=16,antialias = true})



function drm.op(bool)
	if bool then
		::back::
		if not IsValid(drm.scoreboard) then
			drm.scoreboard = vgui.Create("DFrame")
			drm.scoreboard:SetDraggable(false)
			drm.scoreboard:ShowCloseButton(false)
			drm.scoreboard:SetTitle("")
			goto back
		end
		drm.scoreboard:SetVisible(true)
		drm.scoreboard.Think=function()
			drm.mmath=26+(23*(#player.GetAll()-1))
			drm.scoreboard:SetPos(ScrW()/4,ScrH()/2-drm.mmath/2)
			drm.scoreboard:SetSize(ScrW()/2,drm.mmath)
			drm.scoreboard.Paint=function(self,w,h)
				draw.RoundedBox(0,0,0,ScrW()/2,drm.mmath,Color(30,30,30,200))
				for i,v in pairs(player.GetAll()) do
					draw.RoundedBox(0,3,3+23*(i-1),w-6,20,v:GetNWBool("timeout",false) and Color(255, 200, 200,255) or  Color(255, 255, 255,255))
					draw.Text({
						pos={w-10,12+23*(i-1)},
						font="fornames",
						color=Color(80,0,0,255),
						xalign=TEXT_ALIGN_RIGHT,
						yalign=TEXT_ALIGN_CENTER,
						text=v:Ping()!=0 and v:Ping() or "BOT"
					})
					if not v:IsBot() then
						local playtime = v:GetNWInt("Playtime") + (CurTime() - v:GetNWInt("Joined"))
						local format = "h"
						if playtime < 3600 then
							playtime = math.floor(playtime / 60)
							format = "m"
						elseif playtime < 36000 then
							playtime = math.Round(playtime / 3600, 1)
						else
							playtime = math.floor(playtime / 3600)
						end
						draw.Text({
							pos={w-85,12+23*(i-1)},
							font="fornames",
							color=Color(0,0,0,255),
							xalign=TEXT_ALIGN_RIGHT,
							yalign=TEXT_ALIGN_CENTER,
							text= playtime .. format
						})
					end
					if !IsValid(scrbrd.avatar[i]) then
						scrbrd.avatar[i]=vgui.Create("AvatarImage",drm.scoreboard)
						scrbrd.avatar[i]:SetSize(20,20)
						scrbrd.avatar[i]:SetPlayer(v,64)
						scrbrd.avatar[i]:SetPos(3,3+23*(i-1))

						scrbrd.profile[i]=vgui.Create("DImageButton",drm.scoreboard)
						scrbrd.profile[i]:SetSize(20,20)
						scrbrd.profile[i]:SetMouseInputEnabled(true)
						scrbrd.profile[i]:SetPos(3,3+23*(i-1))
						scrbrd.profile[i].DoClick=function()
							v:ShowProfile()
						end

						scrbrd.name[i]=vgui.Create("DLabel",drm.scoreboard)
						scrbrd.name[i]:SetSize(200,16)
						scrbrd.name[i]:SetFont("fornames")
						scrbrd.name[i]:SetColor(Color(0,0,0,255))
						scrbrd.name[i]:SetText(v:Name())
						scrbrd.name[i]:SetMouseInputEnabled(true)
						scrbrd.name[i]:SetPos(28,5+23*(i-1))
						scrbrd.name[i].DoDoubleClick = function()
							LocalPlayer():ConCommand("ctrl goto "..tostring(v:Name()))
						end

						scrbrd.flag[i]=vgui.Create("DImage",drm.scoreboard)
						scrbrd.flag[i]:SetSize(16,11)
						scrbrd.flag[i]:SetImage(v:GetNWString("country_code","vgui/avatar_default"))
						scrbrd.flag[i]:SetPos(w-60,8+23*(i-1))
						scrbrd.flag[i]:SetTooltip(v:GetNWString("country","Unknown"))

						scrbrd.clock[i]=vgui.Create("DImage",drm.scoreboard)
						scrbrd.clock[i]:SetSize(16,16)
						scrbrd.clock[i]:SetImage("icon16/time.png")
						scrbrd.clock[i]:SetPos(w-80,5+23*(i-1))
						lply=#player.GetAll()
						return
					end
					if lply~=#player.GetAll() then
						for k,v in pairs(scrbrd) do
							for kk,vv in pairs(v) do
								vv:Remove()
							end
						end
					end
				end
			end
		end
	else
		pcall(function()
			drm.scoreboard:SetMouseInputEnabled(false)
			drm.scoreboard:SetVisible(false)
			for k,v in pairs(scrbrd) do
				for kk,vv in pairs(v) do
					vv:Remove()
				end
			end
		end)
	end
end

hook.Add("ScoreboardShow","scrbrd",function()
	drm.op(true)
	drawn=true
	return true
end)

hook.Add("ScoreboardHide","scrbrd",function()
	drm.op(false)
	drawn=false
	gui.EnableScreenClicker(false)
end)


hook.Add("HUDPaint","scoreboardextra",function()
	if drawn then
		if input.IsMouseDown(MOUSE_RIGHT) then
			drm.scoreboard:MakePopup()
			gui.EnableScreenClicker(true)
		end
		draw.Text({
			text=GetHostName(),
			font="title",
			pos={ScrW()/2,ScrH()/2-drm.mmath/2-20},
			xalign=TEXT_ALIGN_CENTER,
			yalign=TEXT_ALIGN_CENTER,
			color=Color(255,255,255,255)
		})
		draw.RoundedBox(0,ScrW()-105,ScrH()-210,105,#drm.extrainfo*20,Color(30,30,30,200))
		for k,v in pairs(drm.extrainfo) do
			v(k)
		end

		local str="Players: "..#player.GetAll().." / Map: "..game.GetMap()
		surface.SetFont("fornames")
		surface.SetTextColor( 255, 255, 255 )
		local width,height = surface.GetTextSize(str)
		surface.SetTextPos(ScrW()/4+5,ScrH()/2+drm.mmath/2+2)
		draw.RoundedBox(0,ScrW()/4,ScrH()/2+drm.mmath/2,10+width,20,Color(30,30,30,200))
		surface.DrawText(str)
		local str2="Double click to teleport to player"
		surface.SetFont("fornames")
		surface.SetTextColor(255,255,255)
		surface.SetTextPos(ScrW()*0.75-190,ScrH()/2+drm.mmath/2+2)
		draw.RoundedBox(0,ScrW()*0.75-195,ScrH()/2+drm.mmath/2,195,20,Color(30,30,30,200))
		surface.DrawText(str2)
	end
end)