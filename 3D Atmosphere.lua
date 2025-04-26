--[[
	HOW TO SET UP: Just put this script under ReplicatedFirst OR StarterPlayerScripts and that's it!

	This is a script which produces a three-dimensional atmosphere in your game. As
	you go up, the sky becomes darker just like in real life! In addition, it also gives you 
	the illusion of an infinite draw distance and it shows an increasing curvature of the 
	Earth as you go higher in altitude! However, ROBLOX is unplayable even before this altitude
	and the quality starts to really deteriorate after the Moon's max altitude.
	
	This is TOTALLY different in comparison to the Atmosphere object, which is simply a haze.
	
	As seen on Space Sailors!

	Feel free to use it in your game and customize it!


	IMPORTANT: 
		• MAKE SURE YOU DON'T HAVE ANY ROBLOX 'ATMOSPHERES' PRESENT IN YOUR GAME BECAUSE THEY 
		DO NOT MIX. IT WILL NOT WORK! REMOVE ANY ROBLOX 'ATMOSPHERES' BEFORE USING!

		• IF YOU CHECKED EnableApparentSunMovement UNDER EnableApparentPlanetRotation SETTING
		AND YOU WANT TO ADD A DAY/NIGHT CYCLE:

			Insert a NumberValue to the workspace and NAME IT: "ServerClockTime". That's your 
			new clock setting from then on. Redirect your day/night scripts to that value!
			If you want to know why is this the case, read the "How to Customize & Presets!" 
			doc under this script.
			

	TIP: It's recommended to have a large water mesh at sea level!

	Made by Pulsarnova (A.k.a. BangoutBoy)

	Version 64
]]


-- Yes, It is a messy script but as long as it works perfectly, that's what matters!
wait()
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Ensures that the player to script connection doesn't glitch!
Player.CharacterAdded:Connect(function(Char)
	Character = Char
	Humanoid = Char:WaitForChild("Humanoid")
	HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")
end)

-- Removes any ROBLOX provided 'atmospheres' since they disable legacy fog which in turn makes the script malfunction.
for i,v in pairs(game.Lighting:GetDescendants())do
	if v.ClassName == "Atmosphere" then
		v:Destroy()
	end
end

-- Spawns the materials and conditions needed to produce the atmosphere.
local Run = game:GetService("RunService")
local Camera = game.Workspace.CurrentCamera
local AtmosphereModel = Instance.new("Model",workspace)
AtmosphereModel.Name = "Atmosphere"
local Atmosphere = Instance.new("Part",AtmosphereModel)
Atmosphere.CanCollide = false
Atmosphere.Anchored = true
Atmosphere.Name = "Atmosphere"
Atmosphere.Size = Vector3.new(1,1,1)
Atmosphere.Color = Color3.new(0,0,0)
Atmosphere.Position = Camera.CFrame.Position
Atmosphere.Orientation = Vector3.new(0, -90, 0)
Atmosphere.CastShadow = false
Atmosphere.Material = "Fabric"
Atmosphere.Transparency = 0
local DistantSurface = Instance.new("Part",AtmosphereModel)
DistantSurface.Size = Vector3.new(1,1,1)
DistantSurface.Color = Color3.new(33/255, 84/255, 185/255)
DistantSurface.Name = "DistantSurface"
DistantSurface.CanCollide = false
DistantSurface.Orientation = Vector3.new(0, -90, 0)
DistantSurface.CastShadow = false
DistantSurface.Anchored = true
DistantSurface.Material = "SmoothPlastic"
local SurfaceMesh = Instance.new("FileMesh",DistantSurface)
SurfaceMesh.MeshId = "rbxassetid://452341386"
SurfaceMesh.Scale = Vector3.new(700, 1000, 700)
local Mesh = Instance.new("FileMesh",Atmosphere)
Mesh.MeshId = "rbxassetid://5077225120"
Mesh.Scale = Vector3.new(7600, 3000, 7600)
Mesh.TextureId = "http://www.roblox.com/asset/?ID=2013298"
local AtmosphereApparentHeight = 5.5
local Sky = Instance.new("Sky",game.Lighting)
Sky.SkyboxBk = "http://www.roblox.com/asset/?ID=2013298"
Sky.SkyboxDn = "http://www.roblox.com/asset/?ID=2013298"
Sky.SkyboxFt = "http://www.roblox.com/asset/?ID=2013298"
Sky.SkyboxLf = "http://www.roblox.com/asset/?ID=2013298"
Sky.SkyboxRt = "http://www.roblox.com/asset/?ID=2013298"
Sky.SkyboxUp = "http://www.roblox.com/asset/?ID=2013298"
Sky.MoonAngularSize = 0.57
Sky.SunAngularSize = 1.44
game.Lighting.FogColor = Color3.new(115/255, 152/255, 255/255)
game.Lighting.FogEnd = 100000
game.Lighting.FogStart = 0
local FogEndRatio = 1
local Earth = Instance.new("Part",AtmosphereModel)
Earth.Anchored = true
Earth.Name = "EarthSurface"
Earth.CanCollide = false
Earth.Size = Vector3.new(1,1,1)
Earth.Color = Color3.new(33/255, 84/255, 185/255)
Earth.Orientation = script.Customize.EnableApparentPlanetRotation.InitialPlanetOrientation.Value
Earth.CastShadow = false
Earth.Material = "ForceField"
Earth.Transparency = 0
local EarthPositionEquation = 1
local EarthMesh = Instance.new("FileMesh",Earth)
EarthMesh.MeshId = "rbxassetid://5276376752"
EarthMesh.TextureId = "rbxassetid://2013298"
EarthMesh.VertexColor = Vector3.new((115/255)*2, (152/255)*2, 2)
local EarthTexture = Instance.new("Decal",Earth)
EarthTexture.Texture = script.Customize.PlanetTexture.Value
local EarthMeshEquation = 100000
local EarthTransparency = script.Customize.PlanetTransparency.Value
local EarthTerminator = Instance.new("Part",AtmosphereModel)
EarthTerminator.Anchored = true
EarthTerminator.Name = "EarthTerminator"
EarthTerminator.CanCollide = false
EarthTerminator.Size = Vector3.new(1,1,1)
EarthTerminator.Color = Color3.new(33/255, 84/255, 185/255)
EarthTerminator.Transparency = 1
EarthTerminator.CastShadow = false
local EarthTerminator2 = Instance.new("Part",AtmosphereModel)
EarthTerminator2.Anchored = true
EarthTerminator2.Name = "EarthTerminator2"
EarthTerminator2.CanCollide = false
EarthTerminator2.Size = Vector3.new(1,1,1)
EarthTerminator2.Color = Color3.new(33/255, 84/255, 185/255)
EarthTerminator2.Transparency = 1
EarthTerminator2.CastShadow = false
local EarthTerminatorMesh = Instance.new("FileMesh",EarthTerminator)
EarthTerminatorMesh.MeshId = "rbxassetid://5276376752"
local EarthTerminatorTexture = Instance.new("Decal",EarthTerminator)
EarthTerminatorTexture.Texture = "rbxassetid://5410829227"
local EarthTerminatorMesh2 = Instance.new("FileMesh",EarthTerminator2)
EarthTerminatorMesh2.MeshId = "rbxassetid://5276376752"
local EarthTerminatorTexture2 = Instance.new("Decal",EarthTerminator2)
EarthTerminatorTexture2.Texture = "rbxassetid://5410829627"
local ShowTerminator = 1
local FindServerClockTime = game.Workspace:FindFirstChild("ServerClockTime")
local ClockTimeExists = false
local HorizonElevationSunsetDifference10 = 10
local SunR = 255
local SunG = 255
local SunB = 255
local SunOffsetX = 0
local SunOffsetZ = 0
local InitialTime = game.Lighting.ClockTime
local InitialGL = game.Lighting.GeographicLatitude
local Extinction = script.Customize.AtmosphericExtinctionColor.AtmosphericExtinction:Clone()
Extinction.Parent = AtmosphereModel
local ExtinctionSunset = script.Customize.AtmosphericExtinctionColor.AtmosphericExtinctionSunset:Clone()
ExtinctionSunset.Parent = AtmosphereModel
local ExtinctionTransparencyMultiplier = 1
local LightEmissionEquation = 1
local ExtinctionTransparencyEquation = 0
local ExtinctionColorEquation = 255
local ExtinctionWidthEquation = 40000
local ExtinctionOrientationEquation = 81
local OutdoorAmbientBrightnessEquation = 128
local SunBrightness = 5
local AirglowLayer = Instance.new("Part",AtmosphereModel)
AirglowLayer.Anchored = true
AirglowLayer.Name = "Airglow"
AirglowLayer.CanCollide = false
AirglowLayer.Size = Vector3.new(1,1,1)
AirglowLayer.Color = Color3.new(58/255, 125/255, 21/255)
AirglowLayer.Orientation = Vector3.new(0,0,0)
AirglowLayer.CastShadow = false
AirglowLayer.Material = "ForceField"
AirglowLayer.Transparency = script.Customize.EnableAirglow.AirglowTransparency.Value
local AirglowMesh = Instance.new("FileMesh",AirglowLayer)
AirglowMesh.MeshId = "rbxassetid://1886703108"
AirglowMesh.TextureId = "rbxassetid://2013298"
AirglowMesh.VertexColor = Vector3.new(0,1,0)
AirglowTransparency = 0
local BottomAtmosphere = Instance.new("Part",AtmosphereModel)
BottomAtmosphere.Anchored = true
BottomAtmosphere.Name = "BottomAtmosphere"
BottomAtmosphere.CanCollide = false
BottomAtmosphere.Size = Vector3.new(1,1,1)
BottomAtmosphere.Color = Color3.new(33/255, 84/255, 185/255)
BottomAtmosphere.Orientation = Vector3.new(0,90,-90)
BottomAtmosphere.CastShadow = false
BottomAtmosphere.Material = "ForceField"
BottomAtmosphere.Transparency = 0.6
local BottomAtmosphereMesh = Instance.new("FileMesh",BottomAtmosphere)
BottomAtmosphereMesh.MeshId = "rbxassetid://5276376752"
BottomAtmosphereMesh.TextureId = "rbxassetid://2013298"
BottomAtmosphereMesh.VertexColor = Vector3.new((115/255)*2,(152/255)*2,2)
BottomAtmosphereMesh.Scale = Vector3.new(400,3000,3000)
local ExtinctionSunsetTransparencyEquation = 1
local Sun3D = script.Customize.EnableSun.Sun3D:Clone()
Sun3D.Parent = AtmosphereModel
local BottomAtmosphereDarkness = Instance.new("Decal", BottomAtmosphere)
BottomAtmosphereDarkness.Texture = "rbxassetid://7983012824"
Sun3D.Transparency = 0.011
game.Lighting.EnvironmentDiffuseScale = 0

if FindServerClockTime ~= nil then
	ClockTimeExists = true
else
	ClockTimeExists = false
end

if ClockTimeExists == true and script.Customize.EnableApparentPlanetRotation["EnableApparentSunMovement (EXPERIMENTAL)"].Value == true then
	InitialTime = workspace.ServerClockTime.Value%24
else
	InitialTime = game.Lighting.ClockTime
end

-- Replacement Sun. Why? SunRays can't pass through opaque parts and the atmosphere has to be opaque to prevent any transparency glitches.

local function onPlayerEntered(character)
	local SunTextureGui;
	do
		for i,v in pairs(script.Parent:GetChildren()) do
			if v:IsA("ScreenGui") then
				SunTextureGui = v
				break
			end
		end
		if not SunTextureGui then 
			SunTextureGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
			SunTextureGui.DisplayOrder = -1 
			SunTextureGui.Name = "Sun"
		end
	end
	local SunTexture = Instance.new("ImageLabel",SunTextureGui)
	SunTexture.Image = script.Customize.EnableSun.SunshineTexture.Value
	SunTexture.BackgroundTransparency = 1
	SunTexture.Size = UDim2.new(0,1000,0,1000)
	SunTexture.AnchorPoint = Vector2.new(0.5,0.5)
	SunTexture.ZIndex = 1
	local IsObstructed = false
	local SunTexture2 = Instance.new("ImageLabel",SunTextureGui)
	SunTexture2.Image = "rbxassetid://5200654205"
	SunTexture2.BackgroundTransparency = 1
	SunTexture2.Size = UDim2.new(0,(2100/Camera.FieldOfView),0,(2100/Camera.FieldOfView))
	SunTexture2.AnchorPoint = Vector2.new(0.5,0.5)
	SunTexture2.ZIndex = 2
	local SunTexture3 = SunTexture:Clone()
	SunTexture3.Parent = SunTextureGui
	
	Earth.Orientation = script.Customize.EnableApparentPlanetRotation.InitialPlanetOrientation.Value
	SunOffsetX = 0
	SunOffsetZ = 0
	
	Run:UnbindFromRenderStep("Sunshine")
	Run:BindToRenderStep("Sunshine", Enum.RenderPriority.Last.Value, function()
		
		if script.Customize.EnableSun.Value == true then
			SunTextureGui.Enabled = true
			Sky.SunTextureId = "rbxasset://sky/sun.jpg"
		else
			SunTextureGui.Enabled = false
			Sky.SunTextureId = ""
		end

		local ScaleFactor = (script.Customize.Scale.Value)^-1
		local x = (Camera.CFrame.Position.Y+script.Customize.AltitudeOffset.Value)*ScaleFactor
		local SunBrightness = script.Customize.EnableSun.SunBrightness.Value
		local SunDirectionV = game.Lighting:GetSunDirection()
		local sunPosition = Camera.CoordinateFrame.p+SunDirectionV * 999
		local screenPosition, isVisible = Camera:WorldToScreenPoint(sunPosition)
		local CamToSun = Ray.new(Camera.CoordinateFrame.p, SunDirectionV * 999)
		local CamToSunDirection = (SunDirectionV * 999)-Camera.CFrame.LookVector
		local ignore = {}
		local SunElevation = math.deg(math.atan((CamToSunDirection.y)/math.sqrt(CamToSunDirection.x^2+CamToSunDirection.z^2)))
		local HorizonElevation = -math.deg(math.acos(20925656.2/(20925656.2+x)))
		local CamZoomDistance = (Camera.Focus.Position - Camera.CFrame.Position).Magnitude
		local HorizonElevationSunsetDifference = SunElevation-HorizonElevation
		local ApparentDiameter = script.Customize.EnableSun.SunApparentDiameter.Value
		local SunExtinctionColorR = script.Customize.EnableSun.SunAtmosphericExtinctionColor.Value.R*255
		local SunExtinctionColorG = script.Customize.EnableSun.SunAtmosphericExtinctionColor.Value.G*255
		local SunExtinctionColorB = script.Customize.EnableSun.SunAtmosphericExtinctionColor.Value.B*255
		local SunExtinctionColorIntermediateR = script.Customize.EnableSun.SunAtmosphericExtinctionIntermediateColor.Value.R*255
		local SunExtinctionColorIntermediateG = script.Customize.EnableSun.SunAtmosphericExtinctionIntermediateColor.Value.G*255
		local SunExtinctionColorIntermediateB = script.Customize.EnableSun.SunAtmosphericExtinctionIntermediateColor.Value.B*255
		local SunsetFOVTransparencyScale = 1 - math.clamp(((workspace.CurrentCamera.FieldOfView - 5) / 5 + 1) 
			* (HorizonElevationSunsetDifference ^ 3 / 10), 0, 1)
		local H1 = 6*(2^(-x/500000))

		if HorizonElevationSunsetDifference <= 0 then
			HorizonElevationSunsetDifference10 = 0
		elseif HorizonElevationSunsetDifference > 0 and HorizonElevationSunsetDifference <= H1 then
			HorizonElevationSunsetDifference10 = HorizonElevationSunsetDifference
		elseif HorizonElevationSunsetDifference > H1 then
			HorizonElevationSunsetDifference10 = H1
		end
		local HorizonElevationSunsetDifference10Ratio = HorizonElevationSunsetDifference10 / H1
		local HorizonElevationSunsetDifference10Ratio3 = (math.clamp(HorizonElevationSunsetDifference10, 0, 2) * 3) / H1
		local HorizonElevationSunsetDifference10Ratio1_5 = (math.clamp(HorizonElevationSunsetDifference10, 0, 1) * 6) / H1

		table.insert(ignore,Atmosphere)
		if CamZoomDistance <= 1.1 then -- Check if player is in first person.
			table.insert(ignore,Character)
		elseif CamZoomDistance > 1.1 then
			ignore[Character] = nil
		end
		
		-- Checks if something is blocking the Sun
		local Obstructed, hitPosition = workspace:FindPartOnRayWithIgnoreList(CamToSun,ignore)
		SunTexture.Position = UDim2.new(0,screenPosition.x,0,screenPosition.y)
		SunTexture2.Position = UDim2.new(0,screenPosition.x,0,screenPosition.y)
		SunTexture3.Position = UDim2.new(0,screenPosition.x,0,screenPosition.y)

		if Obstructed then 
			IsObstructed = true
		else
			IsObstructed = false
		end

		if isVisible then -- Converts the Sun's location in the sky to position coordinates of the shine gui.
			local AltitudeSunTransparencyFadeRate = math.clamp(-0.00000133333333333 * x + 0.75666666666666, 0.55, 0.75)
			SunTexture.ImageTransparency = 1 - math.clamp(
				((2 - (2.6111111111111 * AltitudeSunTransparencyFadeRate))
					* 30 * (HorizonElevationSunsetDifference10Ratio3 + 0.55
						- AltitudeSunTransparencyFadeRate - SunsetFOVTransparencyScale)),
				0,
				1
			)
			SunTexture:TweenSize(
				UDim2.new(
					0, 100 + HorizonElevationSunsetDifference10Ratio * 900*SunBrightness*(-((Camera.FieldOfView-70)/200)+1),
					0, 100 + HorizonElevationSunsetDifference10Ratio * 900*SunBrightness*(-((Camera.FieldOfView-70)/200)+1)
				),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true
			)
			SunTexture2.ImageTransparency = 1 - math.clamp(
				((2 - (2.6111111111111 * AltitudeSunTransparencyFadeRate))
					* 30 * (HorizonElevationSunsetDifference10Ratio1_5 + 0.55
						- AltitudeSunTransparencyFadeRate - SunsetFOVTransparencyScale)),
				0,
				1
			)
			SunTexture2:TweenSize(
				UDim2.new(
					0, ((2.5*Camera.ViewportSize.Y*ApparentDiameter/31.983)/Camera.FieldOfView)*SunBrightness,
					0, ((2.5*Camera.ViewportSize.Y*ApparentDiameter/31.9)/Camera.FieldOfView)*SunBrightness
				),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true
			)
			local SunApparentDiameterRatio = script.Customize.EnableSun.SunApparentDiameter.Value / 31.983
			Sun3D.SunsetLight.Light.ImageTransparency = HorizonElevationSunsetDifference10Ratio
			Sun3D.Mesh.Scale = Vector3.new(
				12.25,
				10.5 + (1.75 * HorizonElevationSunsetDifference10Ratio),
				12.25
			) * SunApparentDiameterRatio
			if IsObstructed == true then
				SunTexture:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
				SunTexture2:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
			elseif SunElevation <= HorizonElevation then
				SunTexture:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
				SunTexture2:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
			elseif HorizonElevation ~= HorizonElevation then
				SunTexture:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
				SunTexture2:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
			end
			SunTexture3.Size = UDim2.new(0, SunTexture.Size.X.Offset / 2, 0, SunTexture.Size.Y.Offset / 2)
			SunTexture3.ImageColor3 = Color3.new(
				SunTexture.ImageColor3.R * 1.5,
				SunTexture.ImageColor3.G * 1.5,
				SunTexture.ImageColor3.B * 1.5
			)
			SunTexture3.Position = SunTexture.Position
			SunTexture3.Rotation = SunTexture.Rotation
			SunTexture3.ImageTransparency = SunTexture.ImageTransparency
		else
			SunTexture:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
			SunTexture2:TweenSize(UDim2.new(0,-5,0,-5),Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.1,true)
			SunTexture3.Size = SunTexture.Size
		end

		if SunTexture.Size.X.Offset <= 0 then -- To ensure the Sun is completely invisible when player is facing away from the Sun.
			SunTexture.Visible = false
			SunTexture2.Visible = false
			SunTexture3.Visible = false
		else
			SunTexture.Visible = true
			SunTexture2.Visible = true
			SunTexture3.Visible = true
		end

		-- Sun Temperature
		local TempValue = math.clamp(script.Customize.EnableSun.SunTemp.Value, 2001, math.huge)
		if script.Customize.EnableSunsetScattering.Value == false then
			TempValue = script.Customize.EnableSun.SunTemp.Value
		end
		local Temp = (TempValue + 1095) / 100
		if TempValue <= 0 then
			SunR = 255
			SunG = 76
			SunB = 0
		elseif TempValue > 0 and TempValue <= 1000 then
			SunR = 255
			SunG = 99.4708025861*math.log(Temp)-161.1195681661
			SunB = 0
		elseif TempValue > 1000 and TempValue <= 2000 then
			SunR = 255
			SunG = 104.49216199393888*math.log(Temp-2)-0.44596950469579133*Temp-155.25485562709179
			SunB = 0
		elseif TempValue > 2000 and TempValue <= 6600 then
			SunR = 255
			SunG = 104.49216199393888*math.log(Temp-2)-0.44596950469579133*Temp-155.25485562709179
			SunB = 115.67994401066147*math.log(Temp-10)+0.8274096064007395*Temp-254.76935184120902
		elseif TempValue > 6600 and TempValue <= 40000 then
			SunR = -40.25366309332127*math.log(Temp-55)+0.114206453784165*Temp+351.97690566805693
			SunG = -28.0852963507957*math.log(Temp-50)+0.07943456536662342*Temp+325.4494125711974
			SunB = 255
		elseif TempValue > 40000 then
			SunR = 162
			SunG = 192
			SunB = 255
		end

		local H2 = (3*(2^(-x/500000)))
		if script.Customize.EnableSunsetScattering.Value then
			local IntermediateColor = Color3.new(
				math.clamp(((((SunR-math.clamp(SunExtinctionColorIntermediateR, 0, SunR - 1))/(H2*(2^(-x/500000))))
					*(math.clamp(HorizonElevationSunsetDifference10, H2, H2 * 2)-H2))+SunExtinctionColorIntermediateR)/255, 0, 1),
				math.clamp(((((SunG-math.clamp(SunExtinctionColorIntermediateG, 0, SunG - 1))/(H2*(2^(-x/500000))))
					*(math.clamp(HorizonElevationSunsetDifference10, H2, H2 * 2)-H2))+SunExtinctionColorIntermediateG)/255, 0, 1),
				math.clamp(((((SunB-math.clamp(SunExtinctionColorIntermediateB, 0, SunB - 1))/(H2*(2^(-x/500000))))
					*(math.clamp(HorizonElevationSunsetDifference10, H2, H2 * 2)-H2))+SunExtinctionColorIntermediateB)/255, 0, 1)
			)
			SunTexture.ImageColor3 = Color3.new(
				(((((IntermediateColor.R*255)-SunExtinctionColorR)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunExtinctionColorR)/255,
				(((((IntermediateColor.G*255)-SunExtinctionColorG)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunExtinctionColorG)/255,
				(((((IntermediateColor.B*255)-SunExtinctionColorB)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunExtinctionColorB)/255
			)
		else
			SunTexture.ImageColor3 = Color3.new(
				(((SunR-SunExtinctionColorR)/(6*(2^(-x/500000)))*HorizonElevationSunsetDifference10)+SunExtinctionColorR)/255,
				((((SunG-SunExtinctionColorG)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunExtinctionColorG)/255,
				((((SunB-SunExtinctionColorB)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunExtinctionColorB)/255
			)
		end
		SunTexture.Rotation = -(screenPosition.x-Camera.ViewportSize.X/2)/100 -- Sunshine rotation as a function of the screen's x-axis.

		-- 3D SUNSET

		if game.Lighting.ClockTime < 12 then
			Sun3D.SunsetLight.ExtentsOffsetWorldSpace = Vector3.new(5, 0, 0)
		else
			Sun3D.SunsetLight.ExtentsOffsetWorldSpace = Vector3.new(-5, 0, 0)
		end

		local AboveHorizon = HorizonElevationSunsetDifference > -2
		if x > 5000 then
			AboveHorizon = HorizonElevationSunsetDifference > 0
		elseif x > 1000 and x <= 5000 then
			AboveHorizon = HorizonElevationSunsetDifference > -0.5
		end
		if script.Customize.EnableSun.Value then
			if AboveHorizon and HorizonElevationSunsetDifference < H1 then
				Sun3D.Position = Camera.CFrame.Position
				Sun3D.Mesh.Offset = Vector3.new(70000, 70000, 70000) * SunDirectionV
			else
				Sun3D.Position = Vector3.new(0, -200000, 0)
				Sun3D.Mesh.Offset = Sun3D.Position
			end
			Sun3D.SunsetLight.StudsOffsetWorldSpace = Sun3D.Mesh.Offset
			Sun3D.SunsetLight.Brightness = math.clamp(400 - (x / 28), 40, 400)
			Sun3D.SunsetLight.Size = UDim2.new(10000 * SunBrightness, 0, math.clamp((-x / 16) + 10000, 4000, 10000) * SunBrightness, 0)
			Sun3D.SunsetLight.Light.ImageColor3 = script.Customize.EnableSun.ThreeDimensionalSunAtmosphericExtinctionColor.Value
		else
			Sun3D.Position = Camera.CFrame.Position - Vector3.new(0, 100000, 0)
		end
	end)
end

repeat wait() until Character
onPlayerEntered(Character)
game.Players.LocalPlayer.CharacterAdded:Connect(onPlayerEntered)

-- The main code:

Run.RenderStepped:Connect(function(dt)
	-- Some more variables to declare.
	local ScaleFactor = (script.Customize.Scale.Value)^-1
	local AtmoThinness = script.Customize.AtmosphereTransparency.Value
	local AtmoHeight = ((script.Customize.AtmosphereThickness.Value)^-1)^0.0625
	local ColorR = script.Customize.AtmosphereColor.Value.R*255
	local ColorG = script.Customize.AtmosphereColor.Value.G*255
	local ColorB = script.Customize.AtmosphereColor.Value.B*255
	local ColorRSunset = script.Customize.AtmosphereSunsetColor.Value.R*255
	local ColorGSunset = script.Customize.AtmosphereSunsetColor.Value.G*255
	local ColorBSunset = script.Customize.AtmosphereSunsetColor.Value.B*255
	local ColorR2 = script.Customize.DistantSurfaceColor.Value.R*255
	local ColorG2 = script.Customize.DistantSurfaceColor.Value.G*255
	local ColorB2 = script.Customize.DistantSurfaceColor.Value.B*255
	local SunBrightness = script.Customize.EnableSun.SunBrightness.Value
	local x = (Camera.CFrame.Position.Y+script.Customize.AltitudeOffset.Value)*ScaleFactor
	local SunDirectionV = game.Lighting:GetSunDirection()
	local CamToSunDirection = (SunDirectionV * 999)-Camera.CFrame.LookVector
	local SunElevation = math.deg(math.atan((CamToSunDirection.y)/math.sqrt(CamToSunDirection.x^2+CamToSunDirection.z^2)))
	local HorizonElevation = -math.deg(math.acos(20925656.2/(20925656.2+math.clamp(x, 0, math.huge))))
	local HorizonElevationSunsetDifference = SunElevation-HorizonElevation
	local EarthTransparencyAltitudeMultiplier = 1/(1+5^(HorizonElevationSunsetDifference-4))
	local LookAngle = math.deg(math.atan((Camera.CFrame.LookVector.Y)/math.sqrt(Camera.CFrame.LookVector.X^2+Camera.CFrame.LookVector.Z^2)))
	local LookAngleHorizonDifference = LookAngle-HorizonElevation
	local EarthTerminatorX = 1.01
	local EarthTerminatorY = 1.2
	local H3 = 10*(2^(-x/500000))
	local H15 = 15*(2^(-x/500000))
	
	-- Makes the atmosphere respond to sunlight.
	
	local t3 = game.Lighting:GetMinutesAfterMidnight()
	
	if HorizonElevationSunsetDifference <= -18 then
		Atmosphere.Transparency = 1
		Sky.StarCount = 3000
	elseif HorizonElevationSunsetDifference > -18 and HorizonElevationSunsetDifference <= -14 then
		Atmosphere.Transparency = -(HorizonElevationSunsetDifference+14)/4
		Sky.StarCount = 3000
	elseif HorizonElevationSunsetDifference > -14 and HorizonElevationSunsetDifference <= 0 then
		Atmosphere.Transparency = 0
		Sky.StarCount = 3000
	elseif HorizonElevationSunsetDifference > 0 then
		Atmosphere.Transparency = 0
		Sky.StarCount = 0
	end
	
	if HorizonElevationSunsetDifference >= 0 and HorizonElevationSunsetDifference < 3.75 then -- Pre-Sunrise/set
		local ColorRResultant = math.clamp((-(ColorRSunset - ColorR) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorRSunset, math.min(ColorR, ColorRSunset), math.max(ColorR, ColorRSunset))
		local ColorGResultant = math.clamp((-(ColorGSunset - ColorG) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorGSunset, math.min(ColorG, ColorGSunset), math.max(ColorG, ColorGSunset))
		local ColorBResultant = math.clamp((-(ColorBSunset - ColorB) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorBSunset, math.min(ColorB, ColorBSunset), math.min(ColorB, ColorBSunset))
		OutdoorAmbientBrightnessEquation = ((((script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value)
			-script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessNight.Value)/17.75)*(HorizonElevationSunsetDifference-3.75)
				+script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value)/255
		game.Lighting.FogColor = Color3.new(
			((ColorRResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorGResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorBResultant/17.75)*(HorizonElevationSunsetDifference+14))/255
		)
		game.Lighting.FogEnd = (-100000*(HorizonElevationSunsetDifference-3.75)+100000)*FogEndRatio*AtmoThinness
		DistantSurface.Color = Color3.new(ColorR2/255, ColorG2/255, ColorB2/255)
		SunBrightness = script.Customize.EnableEnvironmentalLightingChanges.SunlightBrightness.Value
		AirglowLayer.Transparency = 1
		EarthTransparency = ((script.Customize.PlanetTransparency.Value-0.011)/3.75)*HorizonElevationSunsetDifference+0.011
		EarthTexture.Color3 = Color3.new(1,1,1)
	elseif HorizonElevationSunsetDifference >= -7 and HorizonElevationSunsetDifference < 0 then -- Civil twilight
		local ColorRResultant = math.clamp((-(ColorRSunset - ColorR) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorRSunset, math.min(ColorR, ColorRSunset), math.max(ColorR, ColorRSunset))
		local ColorGResultant = math.clamp((-(ColorGSunset - ColorG) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorGSunset, math.min(ColorG, ColorGSunset), math.max(ColorG, ColorGSunset))
		local ColorBResultant = math.clamp((-(ColorBSunset - ColorB) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorBSunset, math.min(ColorB, ColorBSunset), math.min(ColorB, ColorBSunset))
		OutdoorAmbientBrightnessEquation = ((((script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value)
			-script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessNight.Value)/17.75)
				*(HorizonElevationSunsetDifference-3.75)+script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value)/255
		game.Lighting.FogColor = Color3.new(
			((ColorRResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorGResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorBResultant/17.75)*(HorizonElevationSunsetDifference+14))/255
		)
		game.Lighting.FogEnd = (-25000*(HorizonElevationSunsetDifference)+475000)*FogEndRatio*AtmoThinness
		DistantSurface.Color = Color3.new(0,0,0)
		SunBrightness = script.Customize.EnableEnvironmentalLightingChanges.NightBrightness.Value
		AirglowLayer.Transparency = script.Customize.EnableAirglow.AirglowTransparency.Value + AirglowTransparency
		EarthTransparency = 0.011
		EarthTexture.Color3 = Color3.new(7,7,4.5)
	elseif HorizonElevationSunsetDifference >= -14 and HorizonElevationSunsetDifference < -7 then -- Nautical twilight
		local ColorRResultant = math.clamp((-(ColorRSunset - ColorR) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorRSunset, math.min(ColorR, ColorRSunset), math.max(ColorR, ColorRSunset))
		local ColorGResultant = math.clamp((-(ColorGSunset - ColorG) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorGSunset, math.min(ColorG, ColorGSunset), math.max(ColorG, ColorGSunset))
		local ColorBResultant = math.clamp((-(ColorBSunset - ColorB) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorBSunset, math.min(ColorB, ColorBSunset), math.min(ColorB, ColorBSunset))
		OutdoorAmbientBrightnessEquation = ((((script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value)
			-script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessNight.Value)/17.75)
				*(HorizonElevationSunsetDifference-3.75)+script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value)/255
		game.Lighting.FogColor = Color3.new(
			((ColorRResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorGResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorBResultant/17.75)*(HorizonElevationSunsetDifference+14))/255
		)
		game.Lighting.FogEnd = ((550000/7)*(HorizonElevationSunsetDifference+7)+650000)*FogEndRatio*AtmoThinness
		DistantSurface.Color = Color3.new(0,0,0)
		SunBrightness = script.Customize.EnableEnvironmentalLightingChanges.NightBrightness.Value
		AirglowLayer.Transparency = script.Customize.EnableAirglow.AirglowTransparency.Value + AirglowTransparency
		EarthTransparency = 0.011
		EarthTexture.Color3 = Color3.new(7,7,4.5)
	elseif HorizonElevationSunsetDifference < -14 then -- Night
		OutdoorAmbientBrightnessEquation = script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessNight.Value/255
		game.Lighting.FogColor = Color3.new(0,0,0)
		game.Lighting.FogEnd = 100000*FogEndRatio*AtmoThinness
		DistantSurface.Color = Color3.new(0,0,0)
		SunBrightness = script.Customize.EnableEnvironmentalLightingChanges.NightBrightness.Value
		AirglowLayer.Transparency = script.Customize.EnableAirglow.AirglowTransparency.Value + AirglowTransparency
		EarthTransparency = 0.011
		EarthTexture.Color3 = Color3.new(7,7,4.5)
	elseif HorizonElevationSunsetDifference >= 3.75 then -- Broad daylight
		OutdoorAmbientBrightnessEquation = script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value/255
		game.Lighting.FogColor = Color3.new(ColorR/255, ColorG/255, ColorB/255)
		game.Lighting.FogEnd = 100000*FogEndRatio*AtmoThinness
		DistantSurface.Color = Color3.new(ColorR2/255, ColorG2/255, ColorB2/255)
		SunBrightness = script.Customize.EnableEnvironmentalLightingChanges.SunlightBrightness.Value
		AirglowLayer.Transparency = 1
		EarthTransparency = script.Customize.PlanetTransparency.Value
		EarthTexture.Color3 = Color3.new(1,1,1)
	end
	
	local DaycolorR = script.Customize.EnableEnvironmentalLightingChanges.DaytimeSunlightColor.Value.R
	local DaycolorG = script.Customize.EnableEnvironmentalLightingChanges.DaytimeSunlightColor.Value.G
	local DaycolorB = script.Customize.EnableEnvironmentalLightingChanges.DaytimeSunlightColor.Value.B
	local SunsetColorR = script.Customize.EnableEnvironmentalLightingChanges.SunriseSunlightColor.Value.R
	local SunsetColorG = script.Customize.EnableEnvironmentalLightingChanges.SunriseSunlightColor.Value.G
	local SunsetColorB = script.Customize.EnableEnvironmentalLightingChanges.SunriseSunlightColor.Value.B
	if script.Customize.EnableEnvironmentalLightingChanges.Value == true then
		game.Lighting.OutdoorAmbient = Color3.new(OutdoorAmbientBrightnessEquation,OutdoorAmbientBrightnessEquation,OutdoorAmbientBrightnessEquation)
		game.Lighting.Brightness = SunBrightness
		game.Lighting.ColorShift_Top = Color3.new(
			(((DaycolorR-SunsetColorR)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunsetColorR,
			(((DaycolorG-SunsetColorG)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunsetColorG,
			(((DaycolorB-SunsetColorB)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunsetColorB
		)
	else
		game.Lighting.OutdoorAmbient = game.Lighting.OutdoorAmbient
		game.Lighting.Brightness = game.Lighting.Brightness
		game.Lighting.ColorShift_Top = game.Lighting.ColorShift_Top
	end
	
	-- For the atmospheric extinction:
	
	local AtmosphericExtinctionR = script.Customize.AtmosphericExtinctionColor.Value.R*255
	local AtmosphericExtinctionG = script.Customize.AtmosphericExtinctionColor.Value.G*255
	local AtmosphericExtinctionB = script.Customize.AtmosphericExtinctionColor.Value.B*255
	
	local HorizonElevationSunsetDifferenceAdjustmentEquation = -(((HorizonElevationSunsetDifference - 10) ^ 4) / 1000) + 10
	Extinction
	if HorizonElevationSunsetDifference <= H3 and HorizonElevationSunsetDifference > 0 then
		LightEmissionEquation = (1/H3)*HorizonElevationSunsetDifference
		ExtinctionSunsetTransparencyEquation = (1/H3*HorizonElevationSunsetDifference)
		if script.Customize.EnableSunsetScattering.Value then
			ExtinctionTransparencyEquation = (0.8/H3*HorizonElevationSunsetDifferenceAdjustmentEquation)
			ExtinctionColorEquation = Color3.fromRGB(
				((255-AtmosphericExtinctionR)/10*(2^(-x/500000)))*HorizonElevationSunsetDifference+AtmosphericExtinctionR,
				((255-AtmosphericExtinctionG)/10*(2^(-x/500000)))*HorizonElevationSunsetDifference+AtmosphericExtinctionG,
				((255-AtmosphericExtinctionB)/10*(2^(-x/500000)))*HorizonElevationSunsetDifference+AtmosphericExtinctionB
			)
		else
			ExtinctionTransparencyEquation = 0.8
			ExtinctionColorEquation = Color3.fromRGB(255,255,255)
		end
	elseif HorizonElevationSunsetDifference > H3 then
		LightEmissionEquation = 1
		ExtinctionTransparencyEquation = 0.8
		ExtinctionSunsetTransparencyEquation = 1
		ExtinctionColorEquation = Color3.fromRGB(255,255,255)
	elseif HorizonElevationSunsetDifference > -14 and HorizonElevationSunsetDifference <= 0 then
		LightEmissionEquation = 0
		ExtinctionSunsetTransparencyEquation = (1/(1.2*H3)*math.abs(HorizonElevationSunsetDifference))
		if script.Customize.EnableSunsetScattering.Value then
			ExtinctionTransparencyEquation = (-HorizonElevationSunsetDifference/14)
			local AstroAtmosphericExtinctionR = script.Customize.AtmosphericExtinctionColor.AstronomicalTwilightAtmosphericExtinctionColor.Value.R*255
			local AstroAtmosphericExtinctionG = script.Customize.AtmosphericExtinctionColor.AstronomicalTwilightAtmosphericExtinctionColor.Value.G*255
			local AstroAtmosphericExtinctionB = script.Customize.AtmosphericExtinctionColor.AstronomicalTwilightAtmosphericExtinctionColor.Value.B*255
			ExtinctionColorEquation = Color3.fromRGB(
				((AstroAtmosphericExtinctionR-AtmosphericExtinctionR)/14)*-HorizonElevationSunsetDifference+AtmosphericExtinctionR,
				((AstroAtmosphericExtinctionG-AtmosphericExtinctionG)/14)*-HorizonElevationSunsetDifference+AtmosphericExtinctionG,
				((AstroAtmosphericExtinctionB-AtmosphericExtinctionB)/14)*-HorizonElevationSunsetDifference+AtmosphericExtinctionB
			)
		else
			ExtinctionTransparencyEquation = 0.8
			ExtinctionColorEquation = Color3.fromRGB(255,255,255)
		end
	elseif HorizonElevationSunsetDifference <= -14 then
		LightEmissionEquation = 0
		ExtinctionTransparencyEquation = 1
		ExtinctionSunsetTransparencyEquation = 1
		if script.Customize.EnableSunsetScattering.Value then
			ExtinctionColorEquation = Color3.fromRGB(AtmosphericExtinctionR,AtmosphericExtinctionG,AtmosphericExtinctionB)
		else
			ExtinctionTransparencyEquation = 0.8
			ExtinctionColorEquation = Color3.fromRGB(255,255,255)
		end
	end
	
	local ExtinctionIntensity = ((1 - 5) / 20000) * math.clamp(x - 20000, 0, 20000) + 5
	Extinction.AtmosphericExtinction2.Beam1.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam2.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam3.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam4.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam5.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam6.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam7.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam8.Brightness = ExtinctionIntensity
	Extinction.AtmosphericExtinction2.Beam1.LightEmission = LightEmissionEquation
	Extinction.AtmosphericExtinction2.Beam2.LightEmission = LightEmissionEquation
	Extinction.AtmosphericExtinction2.Beam3.LightEmission = LightEmissionEquation
	Extinction.AtmosphericExtinction2.Beam4.LightEmission = LightEmissionEquation
	Extinction.AtmosphericExtinction2.Beam5.LightEmission = LightEmissionEquation
	Extinction.AtmosphericExtinction2.Beam6.LightEmission = LightEmissionEquation
	Extinction.AtmosphericExtinction2.Beam7.LightEmission = LightEmissionEquation
	Extinction.AtmosphericExtinction2.Beam8.LightEmission = LightEmissionEquation
	local ExtinctionTransNumSequence = NumberSequence.new(ExtinctionTransparencyEquation / (1.5 - 0.5 * math.clamp(x / 32808, 0, 1)) * ((2/3)*(1+((14+math.clamp(HorizonElevationSunsetDifference, -14, 0)))/28)))
	local ExtinctionTransNumSequence_2 = NumberSequence.new(ExtinctionTransparencyEquation / (2 * (1+math.clamp(HorizonElevationSunsetDifference, -14, 0) / 28)))
	Extinction.AtmosphericExtinction2.Beam1.Transparency = ExtinctionTransNumSequence_2
	Extinction.AtmosphericExtinction2.Beam2.Transparency = ExtinctionTransNumSequence_2
	Extinction.AtmosphericExtinction2.Beam3.Transparency = ExtinctionTransNumSequence_2
	Extinction.AtmosphericExtinction2.Beam4.Transparency = ExtinctionTransNumSequence_2
	Extinction.AtmosphericExtinction2.Beam5.Transparency = ExtinctionTransNumSequence
	Extinction.AtmosphericExtinction2.Beam6.Transparency = ExtinctionTransNumSequence
	Extinction.AtmosphericExtinction2.Beam7.Transparency = ExtinctionTransNumSequence
	Extinction.AtmosphericExtinction2.Beam8.Transparency = ExtinctionTransNumSequence
	local ExtinctionColorSequence = ColorSequence.new(ExtinctionColorEquation, ExtinctionTransparencyEquation)
	Extinction.AtmosphericExtinction2.Beam1.Color = ExtinctionColorSequence
	Extinction.AtmosphericExtinction2.Beam2.Color = ExtinctionColorSequence
	Extinction.AtmosphericExtinction2.Beam3.Color = ExtinctionColorSequence
	Extinction.AtmosphericExtinction2.Beam4.Color = ExtinctionColorSequence
	Extinction.AtmosphericExtinction2.Beam5.Color = ExtinctionColorSequence
	Extinction.AtmosphericExtinction2.Beam6.Color = ExtinctionColorSequence
	Extinction.AtmosphericExtinction2.Beam7.Color = ExtinctionColorSequence
	Extinction.AtmosphericExtinction2.Beam8.Color = ExtinctionColorSequence

	--SUNSET
	if ExtinctionSunsetTransparencyEquation < 1 and script.Customize.EnableSunsetScattering.Value then
		local ExtinctionSunsetBrightness = math.clamp((3 * HorizonElevationSunsetDifference) + 10, 10, 40)
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Brightness = ExtinctionSunsetBrightness
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Brightness = ExtinctionSunsetBrightness
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Brightness = ExtinctionSunsetBrightness
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Brightness = ExtinctionSunsetBrightness
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Brightness = ExtinctionSunsetBrightness
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Brightness = ExtinctionSunsetBrightness
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Brightness = ExtinctionSunsetBrightness
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Brightness = ExtinctionSunsetBrightness
		local ExtinctionTransNumSequenceSunset1 = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1);
			NumberSequenceKeypoint.new(math.clamp(((HorizonElevationSunsetDifference - 10) / 30) + 1, 0.3, 1), ExtinctionSunsetTransparencyEquation + 0.1);
			NumberSequenceKeypoint.new(1, ExtinctionSunsetTransparencyEquation);
		})
		local ExtinctionTransNumSequenceSunset2 = NumberSequence.new({
			NumberSequenceKeypoint.new(0, ExtinctionSunsetTransparencyEquation);
			NumberSequenceKeypoint.new(math.clamp(-(HorizonElevationSunsetDifference - 10) / 30, 0.3, 1), ExtinctionSunsetTransparencyEquation + 0.1);
			NumberSequenceKeypoint.new(1, 1);
		})
		local ExtinctionTransNumSequenceSunset1BoV = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1);
			NumberSequenceKeypoint.new(math.clamp(((HorizonElevationSunsetDifference - 10) / 30) + 1, 0.3, 1), ExtinctionSunsetTransparencyEquation + 0.1);
			NumberSequenceKeypoint.new(1, ExtinctionSunsetTransparencyEquation + math.clamp(-(HorizonElevationSunsetDifference + 6.6) / 2.7, 0, 1));
		})
		local ExtinctionTransNumSequenceSunset2BoV = NumberSequence.new({
			NumberSequenceKeypoint.new(0, ExtinctionSunsetTransparencyEquation + math.clamp(-(HorizonElevationSunsetDifference + 6.6) / 2.7, 0, 1));
			NumberSequenceKeypoint.new(math.clamp(-(HorizonElevationSunsetDifference - 10) / 30, 0.3, 1), ExtinctionSunsetTransparencyEquation + 0.1 + math.clamp(-(HorizonElevationSunsetDifference + 6.6) / 2.7, 0, 1));
			NumberSequenceKeypoint.new(1, 1);
		})
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Transparency = ExtinctionTransNumSequenceSunset1
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Transparency = ExtinctionTransNumSequenceSunset2
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Transparency = ExtinctionTransNumSequenceSunset1BoV
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Transparency = ExtinctionTransNumSequenceSunset2BoV
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Transparency = ExtinctionTransNumSequenceSunset1
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Transparency = ExtinctionTransNumSequenceSunset2
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Transparency = ExtinctionTransNumSequenceSunset1BoV
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Transparency = ExtinctionTransNumSequenceSunset2BoV

		local BeltOfVenusEmission = math.clamp(0.4 * HorizonElevationSunsetDifference + 1, 0, 1)
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Color = ColorSequence.new(script.Customize.BeltOfVenusColor.Value)
		ExtinctionSunset.AtmosphericExtinction2.Beam3.LightEmission = BeltOfVenusEmission
		ExtinctionSunset.AtmosphericExtinction2.Beam4.LightEmission = BeltOfVenusEmission
		ExtinctionSunset.AtmosphericExtinction2.Beam7.LightEmission = BeltOfVenusEmission
		ExtinctionSunset.AtmosphericExtinction2.Beam8.LightEmission = BeltOfVenusEmission
		ExtinctionSunset.AtmosphericExtinction2.Beam3.LightInfluence = BeltOfVenusEmission
		ExtinctionSunset.AtmosphericExtinction2.Beam4.LightInfluence = BeltOfVenusEmission
		ExtinctionSunset.AtmosphericExtinction2.Beam7.LightInfluence = BeltOfVenusEmission
		ExtinctionSunset.AtmosphericExtinction2.Beam8.LightInfluence = BeltOfVenusEmission
		local InnerAtmosphericExtinctionColor = script.Customize.AtmosphericExtinctionColor.InnerAtmosphericExtinctionColor.Value
		local InnerExtinctionSunsetColor = Color3.fromRGB(
			((script.Customize.AtmosphericExtinctionColor.Value.R * 255 - script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.R * 255) / H3)
				* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.R * 255,
			((script.Customize.AtmosphericExtinctionColor.Value.G * 255 - script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.G * 255) / H3)
				* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.G * 255,
			((script.Customize.AtmosphericExtinctionColor.Value.B * 255 - script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.B * 255) / H3)
				* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.B * 255
		)
		if HorizonElevationSunsetDifference < 0 then
			InnerExtinctionSunsetColor = Color3.fromRGB(
				((script.Customize.AtmosphericExtinctionColor.NauticalTwlightAtmosphericExtinctionColor.Value.R * 255
					- script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.R * 255) / H3)
					* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.R * 255,
				((script.Customize.AtmosphericExtinctionColor.NauticalTwlightAtmosphericExtinctionColor.Value.G * 255
					- script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.G * 255) / H3)
					* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.G * 255,
				((script.Customize.AtmosphericExtinctionColor.NauticalTwlightAtmosphericExtinctionColor.Value.B * 255
					- script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.B * 255) / H3)
					* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.SunsideAtmosphericExtinctionColor.Value.B * 255
			)
			InnerAtmosphericExtinctionColor = Color3.fromRGB(
				((script.Customize.AtmosphericExtinctionColor.NauticalInnerAtmosphericExtinctionColor.Value.R * 255
					- script.Customize.AtmosphericExtinctionColor.InnerAtmosphericExtinctionColor.Value.R * 255) / H3)
					* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.InnerAtmosphericExtinctionColor.Value.R * 255,
				((script.Customize.AtmosphericExtinctionColor.NauticalInnerAtmosphericExtinctionColor.Value.G * 255
					- script.Customize.AtmosphericExtinctionColor.InnerAtmosphericExtinctionColor.Value.G * 255) / H3)
					* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.InnerAtmosphericExtinctionColor.Value.G * 255,
				((script.Customize.AtmosphericExtinctionColor.NauticalInnerAtmosphericExtinctionColor.Value.B * 255
					- script.Customize.AtmosphericExtinctionColor.InnerAtmosphericExtinctionColor.Value.B * 255) / H3)
					* (math.abs(HorizonElevationSunsetDifference)) + script.Customize.AtmosphericExtinctionColor.InnerAtmosphericExtinctionColor.Value.B * 255
			)
		end
		local ExtinctionSunsetColor1 = ColorSequence.new(
			InnerAtmosphericExtinctionColor,
			InnerExtinctionSunsetColor
		)
		local ExtinctionSunsetColor2 = ColorSequence.new(
			InnerExtinctionSunsetColor,
			InnerAtmosphericExtinctionColor
		)
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Color = ExtinctionSunsetColor1
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Color = ExtinctionSunsetColor2
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Color = ExtinctionSunsetColor1
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Color = ExtinctionSunsetColor2
	else
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Transparency = NumberSequence.new(1)
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Transparency = NumberSequence.new(1)
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Transparency = NumberSequence.new(1)
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Transparency = NumberSequence.new(1)
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Transparency = NumberSequence.new(1)
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Transparency = NumberSequence.new(1)
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Transparency = NumberSequence.new(1)
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Transparency = NumberSequence.new(1)
	end
	
	if HorizonElevationSunsetDifference >= -14 and HorizonElevationSunsetDifference < 0 then
		ShowTerminator = -HorizonElevationSunsetDifference/14
		EarthTexture.Texture = script.Customize.PlanetTextureNight.Value
		Mesh.TextureId = "http://www.roblox.com/asset/?ID=2013298"
	elseif HorizonElevationSunsetDifference < -14 then
		ShowTerminator = 1
		EarthTexture.Texture = script.Customize.PlanetTextureNight.Value
	elseif HorizonElevationSunsetDifference >= 0 then
		ShowTerminator = 0
		EarthTexture.Texture = script.Customize.PlanetTexture.Value
	end
	
	if SunElevation < 0 and SunElevation >= -17.5 then
		Mesh.TextureId = "http://www.roblox.com/asset/?ID=2013298"
	elseif SunElevation < -17.5 or SunElevation >= 0 then
		Mesh.TextureId = ""
	end
	
	--[[
		This changes the atmosphere's decay with altitude. By default, it's calibrated for Earth's atmosphere IN REAL LIFE!
		
		DO NOT CHANGE ANYTHING HERE UNLESS YOU KNOW WHAT YOU'RE DOING! 
		If you wanna change something, just go to the customize folder under this script.
		If you know what you're doing, make sure you have a graphing calculator and plot key points to get functions like the ones below.
		
		This works by having the actual part follow the player's camera. The functions are specific for the Y direction
		since ROBLOX's draw distance is limited to 100,000 studs, we had to make the actual part increase in altitude at a slightly 
		slower rate than the player itself so that the NET velocity is slower than the player's velocity in the Y direction.
	]]
	
	
	if x > 100000 and x < 5246873.871 then 
		FogEndRatio = ((4377.1/(((x+180020.1514)^0.810723)))+0.83211)
		local r = 208974
		local u = -62832.1
		local l = -1.3935e+10
		local o = -109932
		local w = -167.036
		local p = -0.109192
		local m = -24.6005
		local n = 9554.31
		Atmosphere.Position = Vector3.new(Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(x-36799.1218621))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		DistantSurface.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(x-54996.930114))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		SurfaceMesh.Scale = Vector3.new(700, 1000, 700)
		game.Lighting.FogStart = ((15/(0.0000984275+0.38^(((x^0.193962)+0.00154112))))-69535.15141)*AtmoHeight
		Mesh.Scale = Vector3.new(((r/(w*((x-u)^p)))+(l/(m*(x-o)))+n),3000,(((r/(w*((x-u)^p)))+(l/(m*(x-o)))+n)))
	elseif x <= 100000 and x > 10000 then
		FogEndRatio = 1
		local d = 25400
		local b = -60715
		local c = 30500
		local f = -43630
		local a7 = 1.31047990554
		local b7 = 3.9710993937e-26
		local c7 = 5.85019468322
		local d7 = 0.701839373626
		local f7 = -2.9477486752e-11
		local g7 = 3.05504012873
		local h7 = -2607.06952132
		local i7 = 0.168115525945
		local j7 = 43.9601841689
		Atmosphere.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((((x+d)*(x+b))/(x+c))-f-18178.846))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		DistantSurface.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(a7*x+(b7*x^c7)+(j7*x^d7)+(f7*x^g7)+(h7*x^i7)-161500))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		SurfaceMesh.Scale = Vector3.new(700, 25*(((x/10000)-10)^2)+1000, 700)
		game.Lighting.FogStart = 0
		local a6 = 2.7154155381e+19
		local b6 = -5.1373398109e+19
		local c6 = 9.1620578497e+9
		local d6 = 9.1430590143e+9
		local f6 = 2.421957201e+19
		local g6 = 9.1219469736e+9
		Mesh.Scale = Vector3.new(
			(a6/(((x-50000)^2)+c6))+(b6/(((x-50000)^2)+d6))+(f6/(((x-50000)^2)+g6)),
			3000,
			(a6/(((x-50000)^2)+c6))+(b6/(((x-50000)^2)+d6))+(f6/(((x-50000)^2)+g6))
		)
	elseif x <= 10000 and x > 0 then
		FogEndRatio = 1
		local d = 25400
		local b = -60715
		local c = 30500
		local f = -43630
		local a7 = 1.31047990554
		local b7 = 3.9710993937e-26
		local c7 = 5.85019468322
		local d7 = 0.701839373626
		local f7 = -2.9477486752e-11
		local g7 = 3.05504012873
		local h7 = -2607.06952132
		local i7 = 0.168115525945
		local j7 = 43.9601841689
		Atmosphere.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((((x+d)*(x+b))/(x+c))-f-18178.846))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		DistantSurface.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(2.95*x-162000))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		SurfaceMesh.Scale = Vector3.new(700, 25*(((x/10000)-10)^2)+1000, 700)
		game.Lighting.FogStart = 0
		local a6 = 2.7154155381e+19
		local b6 = -5.1373398109e+19
		local c6 = 9.1620578497e+9
		local d6 = 9.1430590143e+9
		local f6 = 2.421957201e+19
		local g6 = 9.1219469736e+9
		Mesh.Scale = Vector3.new(
			(a6/(((x-50000)^2)+c6))+(b6/(((x-50000)^2)+d6))+(f6/(((x-50000)^2)+g6)),
			3000+((60/10000)*(x-10000)),
			(a6/(((x-50000)^2)+c6))+(b6/(((x-50000)^2)+d6))+(f6/(((x-50000)^2)+g6))
		)
	elseif x <= 0 then
		FogEndRatio = 1
		local d = 25400
		local b = -60715
		local c = 30500
		local f = -43630
		Atmosphere.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(-25111.502+x))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		DistantSurface.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(-162000+x))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		SurfaceMesh.Scale = Vector3.new(700, 3500, 700)
		game.Lighting.FogStart = 0
		Mesh.Scale = Vector3.new(7600,2940,7600)
	elseif x >= 5246873.871 and x < 21588000 then
		local a4 = -98579869.16641106069088
		local b4 = 0.999855267221903034941
		local c4 = 1.17384438375563399982
		local d4 = -57563664.78762125104666
		local f4 = -0.196011457493862806416
		local g4 = 3642.75971943516306506
		local h4 = -3.95985950072681194396
		local i4 = 145010709.56709843635559
		local j4 = 0.999901664356939897242
		local k4 = -46430900.38206506252289
		local l4 = 5197398.215953723676503
		FogEndRatio = (((a4*x^b4)+(b4*x^c4)+(d4*x^f4)+(g4*x^h4)+(i4*x^j4)+(k4*x)+l4)/100000)
		local a2 = -2.8575150114e+13
		local b2 = -56.5968339427
		local c2 = -20830785.2368
		local d2 = 1.11194612973
		local f2 = 11.9620104512
		Atmosphere.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(x-36799.1218621))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		DistantSurface.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(x-54996.930114))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		SurfaceMesh.Scale = Vector3.new(700, 1000, 700)
		local a5 = -0.1351049236213618273176
		local b5 = 1.198848625660491833764
		local c5 = 1196240.55139738689177
		local d5 = -0.1855817589433473224192
		local f5 = 0.1360663106851749438068
		local g5 = 1.1984539473086930711
		game.Lighting.FogStart = ((a5*x^b5)+(c5*x^d5)+(f5*x^g5))*AtmoHeight
		Mesh.Scale = Vector3.new((a2/(b2*((x-c2)^d2))+f2),3000,(a2/(b2*((x-c2)^d2))+f2))
	elseif x >= 5246873.871 then
		local a4 = -98579869.16641106069088
		local b4 = 0.999855267221903034941
		local c4 = 1.17384438375563399982
		local d4 = -57563664.78762125104666
		local f4 = -0.196011457493862806416
		local g4 = 3642.75971943516306506
		local h4 = -3.95985950072681194396
		local i4 = 145010709.56709843635559
		local j4 = 0.999901664356939897242
		local k4 = -46430900.38206506252289
		local l4 = 5197398.215953723676503
		FogEndRatio = (((a4*x^b4)+(b4*x^c4)+(d4*x^f4)+(g4*x^h4)+(i4*x^j4)+(k4*x)+l4)/100000)
		local a2 = -2.8575150114e+13
		local b2 = -56.5968339427
		local c2 = -20830785.2368
		local d2 = 1.11194612973
		local f2 = 11.9620104512
		Atmosphere.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(x-36799.1218621))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		DistantSurface.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(x-54996.930114))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		SurfaceMesh.Scale = Vector3.new(700, 1000, 700)
		game.Lighting.FogStart = 87751.051*AtmoHeight
		Mesh.Scale = Vector3.new((a2/(b2*((x-c2)^d2))+f2),3000,(a2/(b2*((x-c2)^d2))+f2))
	end
	
	-- To make objects still visible when you look up while you're in space:
	
	if x <= 110000 then
		AtmosphereApparentHeight = 5.5
	else
		AtmosphereApparentHeight = 340334.643262*(x^-0.948472308886)
	end
	
	if x > 110000 and (LookAngleHorizonDifference-AtmosphereApparentHeight) >= Camera.FieldOfView/2 and HorizonElevationSunsetDifference >= 0 then
		Mesh.MeshId = ""
		SurfaceMesh.MeshId = ""
	else
		Mesh.MeshId = "rbxassetid://5077225120"
		SurfaceMesh.MeshId = "rbxassetid://452341386"
	end
	
	-- Earth Surface

	if x > 100000 and x <= 1000000 then
		EarthPositionEquation = (x/ScaleFactor)-(x-((x-100000+(7306.78*(x^0.872004))+(-266624*(x^-0.0237557))+(-7309.42*(x^0.87197956847)))))
		EarthMeshEquation = ((-25.3972387974*x^1.05354335619)+(25.4369609378*x^1.05342854607)+101237.056899)/8.13653899048
		EarthTexture.Transparency = (1-EarthTransparency)/(1+(1.0001^(x-150000)))+EarthTransparency
		EarthTerminatorTexture.Transparency = (1/(1+(1.00002^(x-500000))))+ShowTerminator
		Earth.Transparency = 1/(1+(1.0001^(x-150000)))+EarthTransparencyAltitudeMultiplier
	elseif x > 1000000 and x <= 3500000 then
		EarthPositionEquation = ((x/ScaleFactor)-(x-((((2.0240445172e+13)/((x^-1.61220817515)-0.410381984491))
			+((-2.9626966906e+11)/(x+55704.2710045))+(4.9320988669e+13))+(x-100000)-836.387)))
		EarthMeshEquation = (100000000000/x)/8.13653899048
		EarthTexture.Transparency = EarthTransparency
		EarthTerminatorTexture.Transparency = 0+ShowTerminator
		Earth.Transparency = 0
	elseif x > 3500000 and x <= 5246873.871 then
		EarthPositionEquation = (x/ScaleFactor)-(x-((1.00123264194*x)-106467.5166))
		EarthMeshEquation = ((7.8380064061e+17)*((x+222825889.501)^-1.50563875544)-177960.408667)/8.13653899048
		EarthTexture.Transparency = EarthTransparency
		EarthTerminatorTexture.Transparency = 0+ShowTerminator
		Earth.Transparency = 0
	elseif x > 5246873.871 and x <= 67263000 then
		local a3 = 4709.38474994
		local b3 = 1.013817207034910740965
		local c3 = -204535111.700393855572
		local d3 = 0.3568792446560499938392
		local f3 = -218410.864076
		local m3 = 1.036589479214418688465
		local n3 = 1002557179.90194106102
		local o3 = 0.3045239696673475114881
		local p3 = -1283983614.101778745651
		local q3 = 0.2525169854454897197899
		local r3 = 214169.771949
		local s3 = 1.036884246162165828041
		local t3 = -5.0691452176e+10
		local u3 = -0.3658668418098382413327
		local A3 = -3431253.77136
		local B3 = 0.9999996527455057070014
		local C3 = 0.6366179904251653126221
		local D3 = -4568303.25078
		local E3 = 0.9999992677251237902809
		local F3 = -1.205493651548074211279
		local G3 = 3229298347.720854282379
		EarthPositionEquation = (x/ScaleFactor)-(x-(x-100000))
		EarthMeshEquation = ((a3*x^b3)+(c3*x^d3)+(f3*x^m3)+(n3*x^o3)+(p3*x^q3)+(r3*x^s3)+(t3*x^u3)+(A3*B3^(x-C3))+(D3*E3^(x-F3))+G3)/8.13653899048
		EarthTexture.Transparency = EarthTransparency
		EarthTerminatorTexture.Transparency = 0+ShowTerminator
		Earth.Transparency = 0
	elseif x > 67263000 then
		local g3 = 8.5549040903e+11
		local h3 = -0.487707702858
		local i3 = -8.5504558849e+11
		local j3 = -0.487681650235
		local k3 = 1321.30366835
		EarthPositionEquation = (x/ScaleFactor)-(x-(x-100000))
		EarthMeshEquation = ((g3*x^h3)+(i3*x^j3)+k3)/8.13653899048
		EarthTexture.Transparency = EarthTransparency
		EarthTerminatorTexture.Transparency = 0+ShowTerminator
		Earth.Transparency = 0
	elseif x <= 100000 and x > 0 then
		EarthPositionEquation = (x/ScaleFactor)-(x-((x-100000+(7306.78*(x^0.872004))+(-266624*(x^-0.0237557))+(-7309.42*(x^0.87197956847)))))/8.13653899048
		EarthMeshEquation = ((-25.3972387974*x^1.05354335619)+(25.4369609378*x^1.05342854607)+101237.056899)
		EarthTexture.Transparency = 1
		EarthTerminatorTexture.Transparency = 1+ShowTerminator
		Earth.Transparency = 1
	end
	
	if HorizonElevationSunsetDifference <= 0 then
		EarthTerminatorX = 1.0001
		EarthTerminatorY = 1.0001
	elseif HorizonElevationSunsetDifference > 0 then
		EarthTerminatorX = 1.01
		EarthTerminatorY = 1.2
	end
	
	Earth.Position = Vector3.new(Camera.CFrame.Position.X,EarthPositionEquation-script.Customize.AltitudeOffset.Value,Camera.CFrame.Position.Z)
	EarthTerminator.Position = Vector3.new(Camera.CFrame.Position.X,EarthPositionEquation-script.Customize.AltitudeOffset.Value,Camera.CFrame.Position.Z)
	EarthTerminator2.Position = EarthTerminator.Position
	EarthMesh.Scale = Vector3.new(EarthMeshEquation,EarthMeshEquation,EarthMeshEquation)
	EarthMesh.VertexColor = Vector3.new((game.Lighting.FogColor.R)*2,(game.Lighting.FogColor.G)*2,(game.Lighting.FogColor.B)*2)
	EarthTerminatorMesh.Scale = Vector3.new(EarthMeshEquation*EarthTerminatorX,EarthMeshEquation*EarthTerminatorY,EarthMeshEquation*EarthTerminatorX)
	EarthTerminatorMesh2.Scale = EarthTerminatorMesh.Scale
	EarthTerminatorTexture2.Transparency = EarthTerminatorTexture.Transparency
	EarthTerminator.CFrame = CFrame.new(
		EarthTerminator.Position)*CFrame.fromMatrix(Vector3.new(),
		EarthTerminator.CFrame.LookVector,
		game.Lighting:GetSunDirection())*CFrame.Angles(0,1.5*math.pi,0)
	EarthTerminator2.CFrame = (CFrame.new(EarthTerminator2.Position)
		*CFrame.fromMatrix(Vector3.new(),EarthTerminator2.CFrame.LookVector,-game.Lighting:GetSunDirection())*CFrame.Angles(0,1.5*math.pi,0))
	
	-- Ionospheric airglow:
	local AirglowColorR = script.Customize.EnableAirglow.AirglowColor.Value.R
	local AirglowColorG = script.Customize.EnableAirglow.AirglowColor.Value.G
	local AirglowColorB = script.Customize.EnableAirglow.AirglowColor.Value.B
	AirglowMesh.VertexColor = Vector3.new(AirglowColorR,AirglowColorG,AirglowColorB)
	if script.Customize.EnableAirglow.Value == true then
		AirglowLayer.Position = Vector3.new(Camera.CFrame.Position.X,EarthPositionEquation-script.Customize.AltitudeOffset.Value,Camera.CFrame.Position.Z)
		AirglowMesh.Scale = Vector3.new(EarthMeshEquation*1.014*8.13653899048,EarthMeshEquation*1.014*8.13653899048,EarthMeshEquation*1.014*8.13653899048)
		AirglowTransparency = 0
	else
		AirglowLayer.Position = Vector3.new(0,0,0)
		AirglowMesh.Scale = Vector3.new(0,0,0)
		AirglowTransparency = 1
	end
	
	-- Moon Settings:
	
	Sky.MoonAngularSize = 0.57*(script.Customize.EnableMoon.MoonApparentDiameter.Value/31.6)
	if script.Customize.EnableMoon.Value == false then
		Sky.MoonTextureId = ""
	else
		Sky.MoonTextureId = script.Customize.EnableMoon.MoonTexture.Value
	end
	
	-- Atmospheric Extinction:
	
	if x > 0 and x < 21882.1504 then
		local a9 = 2006.90567819
		local b9 = 1.21405239737
		local c9 = -2007.17985974
		local d9 = 1.21403977579
		local f9 = 3500.97360274
		local ExtinctionPosition = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((a9*x^b9)+(c9*x^d9)+f9+x))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		Extinction.AtmosphericExtinction1.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Beam1.Enabled = true
		Extinction.AtmosphericExtinction2.Beam2.Enabled = true
		Extinction.AtmosphericExtinction2.Beam3.Enabled = true
		Extinction.AtmosphericExtinction2.Beam4.Enabled = true
		Extinction.AtmosphericExtinction2.Beam5.Enabled = true
		Extinction.AtmosphericExtinction2.Beam6.Enabled = true
		Extinction.AtmosphericExtinction2.Beam7.Enabled = true
		Extinction.AtmosphericExtinction2.Beam8.Enabled = true
		--+(-0.0498367812967*x+1515)
		local SSa = 8229.544885035839548218
		local SSb = 1.925649423786986196024
		local SSc = 4351.473081335900484363
		local SSd = 1.91834873220339419038
		local SSe = -7493.591639846589775593
		local SSf = 1.925973151276423534168
		local SSg = -5087.402639489375134849
		local SSh = 1.918929359930211610991
		local SSi = 1399.623669562920662458
		local ExtinctionSunsetEquation = (SSa*x^SSb)+(SSc*x^SSd)+(SSe*x^SSf)+(SSg*x^SSh)+SSi
		local ExtinctionPositionSunset = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(ExtinctionSunsetEquation))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		ExtinctionSunset.AtmosphericExtinction1.Position = ExtinctionPositionSunset
		ExtinctionSunset.AtmosphericExtinction2.Position = ExtinctionPositionSunset
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Enabled = true
		ExtinctionWidthEquation = -(40000*x/21882.1504)+80000
		ExtinctionOrientationEquation = (2*x/21882.1504)+79
	elseif x >= 21882.1504 and x < 100000 then
		local a8 = 6.2712061263e-21
		local b8 = 4.76359763589
		local c8 = 644.975565777
		local d8 = 0.322499727907
		local f8 = -87.7371373004
		local g8 = 0.56698113042
		local h8 = 0.00149802609093
		local i8 = 1.54285932958
		local j8 = -0.00000452047107416
		local k8 = 2.0219644294
		local l8 = 4000.17081685
		local ExtinctionPosition = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((a8*x^b8)+(c8*x^d8)+(f8*x^g8)+(h8*x^i8)+(j8*x^k8)+l8+x))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		Extinction.AtmosphericExtinction1.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Beam1.Enabled = true
		Extinction.AtmosphericExtinction2.Beam2.Enabled = true
		Extinction.AtmosphericExtinction2.Beam3.Enabled = true
		Extinction.AtmosphericExtinction2.Beam4.Enabled = true
		Extinction.AtmosphericExtinction2.Beam5.Enabled = true
		Extinction.AtmosphericExtinction2.Beam6.Enabled = true
		Extinction.AtmosphericExtinction2.Beam7.Enabled = true
		Extinction.AtmosphericExtinction2.Beam8.Enabled = true


		local SSa = 15000
		local SSb = 1.00000103302
		local SSc = -14999.2215578
		local ExtinctionSunsetEquation = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((SSa*x^SSb)+(SSc*x)))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		ExtinctionSunset.AtmosphericExtinction1.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Enabled = true
		ExtinctionWidthEquation = 40000
		ExtinctionOrientationEquation = 81
	elseif x >= 100000 and x < 200000 then
		local ExtinctionPosition = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((-7.0577896884*x^0.594641088876)+620.275987688+x))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		Extinction.AtmosphericExtinction1.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Beam1.Enabled = true
		Extinction.AtmosphericExtinction2.Beam2.Enabled = true
		Extinction.AtmosphericExtinction2.Beam3.Enabled = true
		Extinction.AtmosphericExtinction2.Beam4.Enabled = true
		Extinction.AtmosphericExtinction2.Beam5.Enabled = true
		Extinction.AtmosphericExtinction2.Beam6.Enabled = true
		Extinction.AtmosphericExtinction2.Beam7.Enabled = true
		Extinction.AtmosphericExtinction2.Beam8.Enabled = true

		local SSa = 15000
		local SSb = 1.00000103302
		local SSc = -14999.2215578
		local ExtinctionSunsetEquation = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((SSa*x^SSb)+(SSc*x)))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z)
		ExtinctionSunset.AtmosphericExtinction1.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Enabled = true
		ExtinctionWidthEquation = 40000
		ExtinctionOrientationEquation = 81
	elseif x < 0 then
		local ExtinctionPosition = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(3500+x))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		Extinction.AtmosphericExtinction1.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Beam1.Enabled = true
		Extinction.AtmosphericExtinction2.Beam2.Enabled = true
		Extinction.AtmosphericExtinction2.Beam3.Enabled = true
		Extinction.AtmosphericExtinction2.Beam4.Enabled = true
		Extinction.AtmosphericExtinction2.Beam5.Enabled = true
		Extinction.AtmosphericExtinction2.Beam6.Enabled = true
		Extinction.AtmosphericExtinction2.Beam7.Enabled = true
		Extinction.AtmosphericExtinction2.Beam8.Enabled = true

		local ExtinctionSunsetEquation = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(1399.6236695629))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		ExtinctionSunset.AtmosphericExtinction1.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Enabled = true
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Enabled = true
		ExtinctionWidthEquation = 80000
		ExtinctionOrientationEquation = 79
	elseif x >= 200000 then
		local ExtinctionPosition = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((-7.0577896884*x^0.594641088876)+620.275987688+x))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		)
		Extinction.AtmosphericExtinction1.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Position = ExtinctionPosition
		Extinction.AtmosphericExtinction2.Beam1.Enabled = false
		Extinction.AtmosphericExtinction2.Beam2.Enabled = false
		Extinction.AtmosphericExtinction2.Beam3.Enabled = false
		Extinction.AtmosphericExtinction2.Beam4.Enabled = false
		Extinction.AtmosphericExtinction2.Beam5.Enabled = false
		Extinction.AtmosphericExtinction2.Beam6.Enabled = false
		Extinction.AtmosphericExtinction2.Beam7.Enabled = false
		Extinction.AtmosphericExtinction2.Beam8.Enabled = false

		local SSa = 15000
		local SSb = 1.00000103302
		local SSc = -14999.2215578
		local ExtinctionSunsetEquation = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-((SSa*x^SSb)+(SSc*x)))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		) 
		ExtinctionSunset.AtmosphericExtinction1.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Position = ExtinctionSunsetEquation
		ExtinctionSunset.AtmosphericExtinction2.Beam1.Enabled = false
		ExtinctionSunset.AtmosphericExtinction2.Beam2.Enabled = false
		ExtinctionSunset.AtmosphericExtinction2.Beam3.Enabled = false
		ExtinctionSunset.AtmosphericExtinction2.Beam4.Enabled = false
		ExtinctionSunset.AtmosphericExtinction2.Beam5.Enabled = false
		ExtinctionSunset.AtmosphericExtinction2.Beam6.Enabled = false
		ExtinctionSunset.AtmosphericExtinction2.Beam7.Enabled = false
		ExtinctionSunset.AtmosphericExtinction2.Beam8.Enabled = false
		ExtinctionWidthEquation = 40000
		ExtinctionOrientationEquation = 81
	end
	local sunHDG = -(math.deg(-math.atan2(SunDirectionV.X, SunDirectionV.Z))-180)%360
	local BeltOfVenusWidth = math.clamp(-.4*HorizonElevationSunsetDifference+1, 1, 10)
	Extinction.AtmosphericExtinction2.Beam1.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam2.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam3.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam4.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam1.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam2.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam3.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam4.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam5.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam6.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam7.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam8.Width0 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam5.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam6.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam7.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Beam8.Width1 = ExtinctionWidthEquation
	Extinction.AtmosphericExtinction2.Attachment2a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,90+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment3a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,0+sunHDG,0)
	Extinction.AtmosphericExtinction2.Attachment4a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,-90+sunHDG,0)
	Extinction.AtmosphericExtinction2.Attachment1b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,90+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment2b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,0+sunHDG,0)
	Extinction.AtmosphericExtinction2.Attachment3b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,-90+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment1a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,180+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment4b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,180+sunHDG,0)

	Extinction.AtmosphericExtinction2.Attachment6a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,90+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment7a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,0+sunHDG,0)
	Extinction.AtmosphericExtinction2.Attachment8a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,-90+sunHDG,0)
	Extinction.AtmosphericExtinction2.Attachment5b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,90+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment6b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,0+sunHDG,0)
	Extinction.AtmosphericExtinction2.Attachment7b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,-90+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment5a.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,180+sunHDG,0)
	Extinction.AtmosphericExtinction1.Attachment8b.WorldOrientation = Vector3.new(ExtinctionOrientationEquation,180+sunHDG,0)

	local ExtinctionWidthEquationSunset = ExtinctionWidthEquation / 4
	local ExtinctionSunsetBeltOfVenus = ExtinctionWidthEquationSunset * BeltOfVenusWidth
	ExtinctionSunset.AtmosphericExtinction2.Beam1.Width0 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam2.Width0 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam3.Width0 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Beam4.Width0 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Beam1.Width1 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam2.Width1 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam3.Width1 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Beam4.Width1 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Beam5.Width0 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam6.Width0 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam7.Width0 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Beam8.Width0 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Beam5.Width1 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam6.Width1 = ExtinctionWidthEquationSunset
	ExtinctionSunset.AtmosphericExtinction2.Beam7.Width1 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Beam8.Width1 = ExtinctionSunsetBeltOfVenus
	ExtinctionSunset.AtmosphericExtinction2.Attachment2a.WorldOrientation = Vector3.new(81, 0+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment3a.WorldOrientation = Vector3.new(81, -90+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction2.Attachment4a.WorldOrientation = Vector3.new(81, -180+sunHDG, -0)
	ExtinctionSunset.AtmosphericExtinction2.Attachment1b.WorldOrientation = Vector3.new(81, 0+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment2b.WorldOrientation = Vector3.new(81, -90+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction2.Attachment3b.WorldOrientation = Vector3.new(81, 180+sunHDG, -0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment1a.WorldOrientation = Vector3.new(81, 90+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment4b.WorldOrientation = Vector3.new(81, 90+sunHDG, 0)

	ExtinctionSunset.AtmosphericExtinction2.Attachment6a.WorldOrientation = Vector3.new(81, -0+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment7a.WorldOrientation = Vector3.new(81, -90+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction2.Attachment8a.WorldOrientation = Vector3.new(81, -180+sunHDG, -0)
	ExtinctionSunset.AtmosphericExtinction2.Attachment5b.WorldOrientation = Vector3.new(81, 0+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment6b.WorldOrientation = Vector3.new(81, -90+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction2.Attachment7b.WorldOrientation = Vector3.new(81, 180+sunHDG, -0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment5a.WorldOrientation = Vector3.new(81, 90+sunHDG, 0)
	ExtinctionSunset.AtmosphericExtinction1.Attachment8b.WorldOrientation = Vector3.new(81, 90+sunHDG, 0)

	Extinction.AtmosphericExtinction1.Orientation = Vector3.new(0, sunHDG - 90, 0)
	Extinction.AtmosphericExtinction2.Orientation = Vector3.new(0, sunHDG + 180, 0)
	ExtinctionSunset.AtmosphericExtinction1.Orientation = Vector3.new(0, sunHDG - 180, 0)
	ExtinctionSunset.AtmosphericExtinction2.Orientation = Vector3.new(0, sunHDG + 90, 0)
	
	ExtinctionSunset.AtmosphericExtinction2.Beam9.Width0 = ExtinctionSunset.AtmosphericExtinction2.Beam1.Width0
	ExtinctionSunset.AtmosphericExtinction2.Beam9.Width1 = ExtinctionSunset.AtmosphericExtinction2.Beam1.Width1
	ExtinctionSunset.AtmosphericExtinction2.Beam9.Brightness = ExtinctionSunset.AtmosphericExtinction2.Beam1.Brightness
	ExtinctionSunset.AtmosphericExtinction2.Beam9.Color = ExtinctionSunset.AtmosphericExtinction2.Beam1.Color
	ExtinctionSunset.AtmosphericExtinction2.Beam9.Transparency = ExtinctionSunset.AtmosphericExtinction2.Beam1.Transparency
	ExtinctionSunset.AtmosphericExtinction2.Beam9.LightEmission = ExtinctionSunset.AtmosphericExtinction2.Beam1.LightEmission
	ExtinctionSunset.AtmosphericExtinction2.Beam9.Enabled = ExtinctionSunset.AtmosphericExtinction2.Beam1.Enabled
	
	ExtinctionSunset.AtmosphericExtinction2.Beam10.Width0 = ExtinctionSunset.AtmosphericExtinction2.Beam2.Width0
	ExtinctionSunset.AtmosphericExtinction2.Beam10.Width1 = ExtinctionSunset.AtmosphericExtinction2.Beam2.Width1
	ExtinctionSunset.AtmosphericExtinction2.Beam10.Brightness = ExtinctionSunset.AtmosphericExtinction2.Beam2.Brightness
	ExtinctionSunset.AtmosphericExtinction2.Beam10.Color = ExtinctionSunset.AtmosphericExtinction2.Beam2.Color
	ExtinctionSunset.AtmosphericExtinction2.Beam10.Transparency = ExtinctionSunset.AtmosphericExtinction2.Beam2.Transparency
	ExtinctionSunset.AtmosphericExtinction2.Beam10.LightEmission = ExtinctionSunset.AtmosphericExtinction2.Beam2.LightEmission
	ExtinctionSunset.AtmosphericExtinction2.Beam10.Enabled = ExtinctionSunset.AtmosphericExtinction2.Beam2.Enabled
	
	ExtinctionSunset.AtmosphericExtinction2.Beam11.Width0 = ExtinctionSunset.AtmosphericExtinction2.Beam1.Width0
	ExtinctionSunset.AtmosphericExtinction2.Beam11.Width1 = ExtinctionSunset.AtmosphericExtinction2.Beam1.Width1
	ExtinctionSunset.AtmosphericExtinction2.Beam11.Brightness = ExtinctionSunset.AtmosphericExtinction2.Beam1.Brightness
	ExtinctionSunset.AtmosphericExtinction2.Beam11.Color = ExtinctionSunset.AtmosphericExtinction2.Beam1.Color
	ExtinctionSunset.AtmosphericExtinction2.Beam11.Transparency = ExtinctionSunset.AtmosphericExtinction2.Beam1.Transparency
	ExtinctionSunset.AtmosphericExtinction2.Beam11.LightEmission = ExtinctionSunset.AtmosphericExtinction2.Beam1.LightEmission
	ExtinctionSunset.AtmosphericExtinction2.Beam11.Enabled = ExtinctionSunset.AtmosphericExtinction2.Beam1.Enabled
	
	ExtinctionSunset.AtmosphericExtinction2.Beam12.Width0 = ExtinctionSunset.AtmosphericExtinction2.Beam2.Width0
	ExtinctionSunset.AtmosphericExtinction2.Beam12.Width1 = ExtinctionSunset.AtmosphericExtinction2.Beam2.Width1
	ExtinctionSunset.AtmosphericExtinction2.Beam12.Brightness = ExtinctionSunset.AtmosphericExtinction2.Beam2.Brightness
	ExtinctionSunset.AtmosphericExtinction2.Beam12.Color = ExtinctionSunset.AtmosphericExtinction2.Beam2.Color
	ExtinctionSunset.AtmosphericExtinction2.Beam12.Transparency = ExtinctionSunset.AtmosphericExtinction2.Beam2.Transparency
	ExtinctionSunset.AtmosphericExtinction2.Beam12.LightEmission = ExtinctionSunset.AtmosphericExtinction2.Beam2.LightEmission
	ExtinctionSunset.AtmosphericExtinction2.Beam12.Enabled = ExtinctionSunset.AtmosphericExtinction2.Beam2.Enabled

	if script.Customize.EnableGroundAtmosphere.Value == true then
		BottomAtmosphere.Position = Vector3.new(
			Camera.CFrame.Position.X,
			(x/ScaleFactor)-(x-(0.975794628099*x-9972.10330579))-script.Customize.AltitudeOffset.Value,
			Camera.CFrame.Position.Z
		) 
		BottomAtmosphere.Transparency = ((1-script.Customize.EnableGroundAtmosphere.GroundAtmosphereTransparency.Value)
			/(1+(1.0001^(-(x-150000)))))+((1.01-script.Customize.EnableGroundAtmosphere.GroundAtmosphereTransparency.Value)
			/(1+(1.0005^((x-10000)))))+script.Customize.EnableGroundAtmosphere.GroundAtmosphereTransparency.Value
		BottomAtmosphereMesh.VertexColor = EarthMesh.VertexColor
	else
		BottomAtmosphere.Position = Vector3.new(0,0,0)
		BottomAtmosphere.Transparency = 1
		BottomAtmosphereMesh.VertexColor = EarthMesh.VertexColor
	end
	
	-- Earth Apparent Movement: (FEEL FREE TO TWEAK!)
	
	local EarthPosition = Earth.CFrame.Position
	local EarthOrientation = Earth.CFrame - EarthPosition
	local VelocityX = (((HumanoidRootPart.Velocity.X/script.Customize.Scale.Value)*dt)
		/(2*math.pi*(20925656.2+HumanoidRootPart.Position.Y*script.Customize.Scale.Value)/360))
	local VelocityZ = (((HumanoidRootPart.Velocity.Z/script.Customize.Scale.Value)*dt)
		/(2*math.pi*(20925656.2+HumanoidRootPart.Position.Y*script.Customize.Scale.Value)/360))
	local RotationSpeed = CFrame.Angles(math.rad(-VelocityZ),0,math.rad(VelocityX))
	local NewEarthRotation = RotationSpeed*EarthOrientation 
	local NewEarthOrientation = NewEarthRotation + EarthPosition
	
	if script.Customize.EnableApparentPlanetRotation.Value == true then
		Earth.CFrame = NewEarthOrientation
	else
		Earth.CFrame = EarthOrientation
	end
	
	if ClockTimeExists == true and script.Customize.EnableApparentPlanetRotation["EnableApparentSunMovement (EXPERIMENTAL)"].Value == true then
		InitialTime = game.Workspace.ServerClockTime.Value%24
	end
	
	-- And for the Sun (EXPERIMENTAL)
	if script.Customize.EnableApparentPlanetRotation["EnableApparentSunMovement (EXPERIMENTAL)"].Value == true then
		SunOffsetX = (SunOffsetX+(VelocityX)*4)
		SunOffsetZ = SunOffsetZ+(-VelocityZ)
		if script.Customize.EnableApparentPlanetRotation["EnableApparentSunMovement (EXPERIMENTAL)"].EquatorialMovementOnly.Value == true then
			game.Lighting:SetMinutesAfterMidnight(InitialTime*60+SunOffsetX)
			game.Lighting.GeographicLatitude = game.Lighting.GeographicLatitude
		else
			game.Lighting:SetMinutesAfterMidnight(InitialTime*60+SunOffsetX)
			game.Lighting.GeographicLatitude = InitialGL+SunOffsetZ
		end
		
		-- Assuming this is the size of your spawn location of 20,000 by 20,000 by 1000 studs.
		if ((HumanoidRootPart.Position.X >= -10000 and HumanoidRootPart.Position.X < 10000)
			and (HumanoidRootPart.Position.Z >= -10000) and ((HumanoidRootPart.Position.Y+script.Customize.AltitudeOffset.Value) < 1000)) then
			SunOffsetX = 0
			SunOffsetZ = 0
			Earth.Orientation = script.Customize.EnableApparentPlanetRotation.InitialPlanetOrientation.Value
		end
	else
		game.Lighting.ClockTime = game.Lighting.ClockTime
		game.Lighting.GeographicLatitude = game.Lighting.GeographicLatitude
	end
	
	-- ATMOSPHERE TWILIGHT DARKNESS

	local ATDa = 1.42956638935406912395e-17
	local ATDb = 3.11869410895
	local ATDc = 5010.5925368
	local ATDd = -0.998839715953

	local ATDTimeCompensation
	local CT = game.Lighting.ClockTime
	if CT >= 5.9 and CT < 6.2 then -- Sunrise fade
		ATDTimeCompensation = (CT - 5.9) / 0.3
	elseif CT >= 4.8 and CT < 5.1 then -- Early Morning fade
		ATDTimeCompensation = -(CT - 5.1) / 0.3
	elseif CT >= 6.2 and CT < 17.8 then -- Day
		ATDTimeCompensation = 1
	elseif CT >= 17.8 and CT < 18.1 then -- Sunset fade
		ATDTimeCompensation = -(CT - 18.1) / 0.3
	elseif CT >= 18.9 and CT < 19.2 then -- Evening fade
		ATDTimeCompensation = (CT - 18.9) / 0.3
	elseif CT >= 19.2 or CT < 4.8 then -- Night
		ATDTimeCompensation = 1
	else
		ATDTimeCompensation = 0
	end

	if x >= 5060 and x < 250251 and script.Customize.EnableGroundAtmosphere.Value then
		BottomAtmosphereDarkness.Transparency = math.clamp(ATDa * (x ^ ATDb) + ATDc * (x ^ ATDd), 0, 1) + ATDTimeCompensation
	else
		BottomAtmosphereDarkness.Transparency = 1
	end
	
	-- EARTH'S ATMOSPHERE COLOR (SPECIAL CASE)
	if script.Customize.AtmosphereColor.Value == Color3.fromRGB(115, 180, 255) then
		local groundAtmosphereColorFactor = math.clamp(1 - ((x/ScaleFactor) / 32808), 0, 1) * (math.clamp(HorizonElevationSunsetDifference, 0, 10) / 10)
		Atmosphere.Color = Color3.new(
			0,
			(95 / 255) * groundAtmosphereColorFactor,
			(148 / 255) * groundAtmosphereColorFactor
		)
		
		local sunsetFade15 = math.clamp(HorizonElevationSunsetDifference / H15, 0, 1)
		local altitudeFade = 1 - math.clamp((((x/ScaleFactor) - 100000) / 20000), 0, 1)
		game.Lighting.FogColor = Color3.new(
			game.Lighting.FogColor.R * (1 + (0.0434782608695652 * sunsetFade15 * altitudeFade)),
			game.Lighting.FogColor.G * (1 + (0.2222222222222222 * sunsetFade15 * altitudeFade)),
			game.Lighting.FogColor.B * (1 + (0.4313725490196079 * sunsetFade15 * altitudeFade))
		)
	else
		Atmosphere.Color = Color3.new()
	end
	local atmosphericReflectionColorFactor = math.clamp(HorizonElevationSunsetDifference / 10, 0, 1)
	game.Lighting.Ambient = Color3.new(
		script.Customize.AtmosphereColor.AtmosphereReflectionColor.Value.R * atmosphericReflectionColorFactor,
		script.Customize.AtmosphereColor.AtmosphereReflectionColor.Value.G * atmosphericReflectionColorFactor,
		script.Customize.AtmosphereColor.AtmosphereReflectionColor.Value.B * atmosphericReflectionColorFactor
	)
end)
