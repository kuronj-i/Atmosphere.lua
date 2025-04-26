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
	edited by @vietnamricefarmerz / @_kuronjie
	Version 65
]]

local rgb = Color3.fromRGB
local AtmoSphere = {
	AltitudeOffset = 0,
	AtmosphereColor = rgb(115, 180, 255),
	AtmosphereReflectionColor = rgb(42, 133, 198),
	AtmosphereSunsetColor = rgb(171, 213, 255),
	AtmosphereThickness = 1,
	AtmosphereTransparency = 1,
	AtmosphereExtinctionColor = rgb(255, 100, 0),
	AstronomicalTwilightAtmosphericExtinctionColor = rgb(60, 60, 60),
	InnerAtmosphericExtinctionColor = rgb(255, 85, 0),
	NauticalInnerAtmosphericExtinctionColor = rgb(150, 125, 50),
	NauticalTwlightAtmosphericExtinctionColor = rgb(255, 100, 50),
	SunsideAtmosphericExtinctionColor = rgb(255, 20, 0),
	BeltOfVenusColor = rgb(0, 13, 25),
	DistantSurfaceColor = rgb(45, 118, 255),
	EnableAirglow = true,
	AirglowColor = rgb(0, 255, 0),
	AirglowTransparency = rgb(0.93),
	EnableEnvironmentalLightingChanges = true,
	DaytimeSunlightColor = rgb(255, 255, 255),
	NightBrightness = 0,
	OutdoorAmbientBrightnessDay = 128,
	OutdoorAmbientBrightnessNight = 48,
	SunlightBrightness = 5, 
	SunriseSunlightColor = rgb(255, 140, 20),
	EnableGroundAtmosphere = true,
	GroundAtmosphereTransparency = 0.8,
	EnableMoon = true,
	MoonApparentDiameter = 31.6,
	MoonTexture = "rbxassetid://10855868393",
	EnableSun = true,
	SunApparentDiamater = 31.983,
	SunAtmosphericExtinctionColor = rgb(255, 140, 50),
	SunAtmosphericExtinctionIntermediateColor = rgb(255, 200, 80),
	SunBrightness = 1,
	SunTemp = 5505,
	SunshineTexture = "rbxassetid://6196665106",
	ThreeDimensionalSunAtmosphericExtinctionColor = rgb(255, 20, 0),
	EnableSunsetScattering = true,
	PlanetTexture = "rbxassetid://5079554320",
	PlanetTextureNight = "rbxassetid://5088333693",
	PlanetTransparency = 0.421,
	Scale = 2.3,
	FogEndRatio = 1,
	AtmosphereMetadata = {},
}

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Camera = workspace.Camera

local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Ensures that the player to script connection doesn't glitch!
Player.CharacterAdded:Connect(function(Char)
	Character = Char
	Humanoid = Char:WaitForChild("Humanoid")
	HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")
end)

for _, v in pairs(Lighting:GetDescendants())do
	if v.ClassName == "Atmosphere" then
		v:Destroy()
	end
end

-- // helper functions
function AtmoSphere:GetMeta()
	return self.AtmosphereMetadata
end

function AtmoSphere:GetScale()
	return self.Scale
end

-- // global variables
local ScaleFactor = AtmoSphere:GetScale() * -1
local meta = AtmoSphere:GetMeta()
local x

function AtmoSphere:Connect(funcName: string, event: RBXScriptSignal): RBXScriptConnection
	return event:Connect(function(...) return self[funcName](self, ...) end)
end

function AtmoSphere:Init()
	if self.Initialized then
		return
	end
	self.Initialized = true

	-- Atmosphere Model
	meta.AtmosphereModel = Instance.new("Model", workspace)
	meta.AtmosphereModel.Name = "Atmosphere"

	-- Atmosphere Part
	meta.Atmosphere = Instance.new("Part", meta.AtmosphereModel)
	meta.Atmosphere.Name = "Atmosphere"
	meta.Atmosphere.Size = Vector3.new(1, 1, 1)
	meta.Atmosphere.Color = Color3.new(0, 0, 0)
	meta.Atmosphere.Position = Camera.CFrame.Position
	meta.Atmosphere.Orientation = Vector3.new(0, -90, 0)
	meta.Atmosphere.Anchored = true
	meta.Atmosphere.CanCollide = false
	meta.Atmosphere.CastShadow = false
	meta.Atmosphere.Material = Enum.Material.Fabric
	meta.Atmosphere.Transparency = 0

	-- Atmosphere Mesh
	meta.AtmosphereMesh = Instance.new("FileMesh", meta.Atmosphere)
	meta.AtmosphereMesh.MeshId = "rbxassetid://5077225120"
	meta.AtmosphereMesh.Scale = Vector3.new(7600, 3000, 7600)
	meta.AtmosphereMesh.TextureId = "http://www.roblox.com/asset/?ID=2013298"

	-- Distant Surface
	meta.DistantSurface = Instance.new("Part", meta.AtmosphereModel)
	meta.DistantSurface.Name = "DistantSurface"
	meta.DistantSurface.Size = Vector3.new(1, 1, 1)
	meta.DistantSurface.Color = Color3.new(33/255, 84/255, 185/255)
	meta.DistantSurface.Anchored = true
	meta.DistantSurface.CanCollide = false
	meta.DistantSurface.CastShadow = false
	meta.DistantSurface.Orientation = Vector3.new(0, -90, 0)
	meta.DistantSurface.Material = Enum.Material.SmoothPlastic

	meta.SurfaceMesh = Instance.new("FileMesh", meta.DistantSurface)
	meta.SurfaceMesh.MeshId = "rbxassetid://452341386"
	meta.SurfaceMesh.Scale = Vector3.new(700, 1000, 700)

	-- Sky
	meta.Sky = Instance.new("Sky", Lighting)
	meta.Sky.SkyboxBk = "http://www.roblox.com/asset/?ID=2013298"
	meta.Sky.SkyboxDn = "http://www.roblox.com/asset/?ID=2013298"
	meta.Sky.SkyboxFt = "http://www.roblox.com/asset/?ID=2013298"
	meta.Sky.SkyboxLf = "http://www.roblox.com/asset/?ID=2013298"
	meta.Sky.SkyboxRt = "http://www.roblox.com/asset/?ID=2013298"
	meta.Sky.SkyboxUp = "http://www.roblox.com/asset/?ID=2013298"
	meta.Sky.MoonAngularSize = 0.57
	meta.Sky.SunAngularSize = 1.44

	-- Earth
	meta.Earth = Instance.new("Part", meta.AtmosphereModel)
	meta.Earth.Name = "EarthSurface"
	meta.Earth.Size = Vector3.new(1, 1, 1)
	meta.Earth.Color = Color3.new(33/255, 84/255, 185/255)
	meta.Earth.Anchored = true
	meta.Earth.CanCollide = false
	meta.Earth.CastShadow = false
	meta.Earth.Material = Enum.Material.ForceField
	
	meta.EarthMesh = Instance.new("FileMesh", meta.Earth)
	meta.EarthMesh.MeshId = "rbxassetid://5276376752"
	meta.EarthMesh.TextureId = "rbxassetid://2013298"
	meta.EarthMesh.VertexColor = Vector3.new((115/255)*2, (152/255)*2, 2)
	meta.EarthMesh.Parent = meta.Earth
	meta.EarthTexture = Instance.new("Decal", meta.Earth)
	meta.EarthTexture.Texture = AtmoSphere.PlanetTexture

	-- earth terminator
	meta.EarthTerminator = Instance.new("Part", meta.AtmosphereModel)
	meta.EarthTerminator.Name = "EarthTerminator"
	meta.EarthTerminator.Size = Vector3.new(1, 1, 1)
	meta.EarthTerminator.Color = Color3.new(33/255, 84/255, 185/255)
	meta.EarthTerminator.Anchored = true
	meta.EarthTerminator.CanCollide = false
	meta.EarthTerminator.CastShadow = false
	meta.EarthTerminator.Transparency = 1
	-- mesh & texture
	meta.EarthTerminatorMesh = Instance.new("FileMesh", meta.EarthTerminator)
	meta.EarthTerminatorMesh.MeshId = "rbxassetid://5276376752"
	meta.EarthTerminatorTexture = Instance.new("Decal", meta.EarthTerminator)
	meta.EarthTerminatorTexture.Texture = "rbxassetid://5410829227"
	
	-- earth terminator 2
	meta.EarthTerminator2 = Instance.new("Part", meta.AtmosphereModel)
	meta.EarthTerminator2.Name = "EarthTerminator2"
	meta.EarthTerminator2.Size = Vector3.new(1, 1, 1)
	meta.EarthTerminator2.Color = Color3.new(33/255, 84/255, 185/255)
	meta.EarthTerminator2.Anchored = true
	meta.EarthTerminator2.CanCollide = false
	meta.EarthTerminator2.CastShadow = false
	meta.EarthTerminator2.Transparency = 1
 	-- mesh & texture
	meta.EarthTerminatorMesh2 = Instance.new("FileMesh",  meta.EarthTerminator2)
	meta.EarthTerminatorMesh2.MeshId = "rbxassetid://5276376752"
	meta.EarthTerminatorTexture2 = Instance.new("Decal", meta.EarthTerminator2)
	meta.EarthTerminatorTexture2.Texture = "rbxassetid://5410829627"

	-- Airglow
	meta.AirglowLayer = Instance.new("Part", meta.AtmosphereModel)
	meta.AirglowLayer.Name = "Airglow"
	meta.AirglowLayer.Size = Vector3.new(1, 1, 1)
	meta.AirglowLayer.Color = Color3.new(58/255, 125/255, 21/255)
	meta.AirglowLayer.Anchored = true
	meta.AirglowLayer.CanCollide = false
	meta.AirglowLayer.CastShadow = false
	meta.AirglowLayer.Material = Enum.Material.ForceField
	meta.AirglowLayer.Transparency = AtmoSphere.AirglowTransparency

	meta.AirglowMesh = Instance.new("FileMesh")
	meta.AirglowMesh.MeshId = "rbxassetid://1886703108"
	meta.AirglowMesh.TextureId = "rbxassetid://2013298"
	meta.AirglowMesh.VertexColor = Vector3.new(0, 1, 0)
	meta.AirglowMesh.Parent = meta.AirglowLayer

	-- Bottom Atmosphere
	meta.BottomAtmosphere = Instance.new("Part", meta.AtmosphereModel)
	meta.BottomAtmosphere.Name = "BottomAtmosphere"
	meta.BottomAtmosphere.Size = Vector3.new(1, 1, 1)
	meta.BottomAtmosphere.Color = Color3.new(33/255, 84/255, 185/255)
	meta.BottomAtmosphere.Anchored = true
	meta.BottomAtmosphere.CanCollide = false
	meta.BottomAtmosphere.CastShadow = false
	meta.BottomAtmosphere.Material = Enum.Material.ForceField
	meta.BottomAtmosphere.Orientation = Vector3.new(0, 90, -90)
	meta.BottomAtmosphere.Transparency = 0.6

	meta.BottomAtmosphereMesh = Instance.new("FileMesh", meta.BottomAtmosphere)
	meta.BottomAtmosphereMesh.MeshId = "rbxassetid://5276376752"
	meta.BottomAtmosphereMesh.TextureId = "rbxassetid://2013298"
	meta.BottomAtmosphereMesh.VertexColor = Vector3.new((115/255)*2, (152/255)*2, 2)
	meta.BottomAtmosphereMesh.Scale = Vector3.new(400, 3000, 3000)

	meta.BottomAtmosphereDarkness = Instance.new("Decal", meta.BottomAtmosphere)
	meta.BottomAtmosphereDarkness.Texture = "rbxassetid://7983012824"
	meta.BottomAtmosphereDarkness.Parent = meta.BottomAtmosphere
	
	meta.Extinction = script:FindFirstChild("AtmosphericExtinction", true)
	meta.Parent = meta.AtmosphereModel
	
	-- Set Fog
	Lighting.FogColor = Color3.new(115/255, 152/255, 255/255)
	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	
	-- sun
	meta.Sun3D = script:FindFirstChild("Sun3D", true)
	if not meta.Sun3D then
		return
	end
	meta.Sun3D.Parent = meta.AtmosphereModel
	meta.SunColor = rgb(255, 255, 255)
	meta.SunOffset = Vector2.new(0, 0)
	
	-- Lighting tweaks
	Lighting.EnvironmentDiffuseScale = 0
	
	self.AtmoSphere:Resume()
end

function AtmoSphere:Pause()
	if self.UpdateConnection then
		self.UpdateConnection:Disconnect()
		self.UpdateConnection = nil
	end
end

function AtmoSphere:Resume()
	if self.Running then
		return
	end
	self.Running = true
	self.UpdateConnection = AtmoSphere:Connect("Update", RunService.Heartbeat)
end

-- Replacement Sun. Why? SunRays can't pass through opaque parts and the atmosphere has to be opaque to prevent any transparency glitches.
function AtmoSphere:Sun(character)
	if not x then
		return
	end
	local SunTextureGui;
	SunTextureGui = Instance.new("ScreenGui", Player.PlayerGui)
	SunTextureGui.DisplayOrder = -1 
	SunTextureGui.Name = "Sun"
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
	SunTexture2.AnchorPoint = Vector2.new(0.5, 0.5)
	SunTexture2.ZIndex = 2
	local SunTexture3 = SunTexture:Clone()
	SunTexture3.Parent = SunTextureGui

	local SunOffsetX, SunOffsetZ = 0, 0

	RunService:UnbindFromRenderStep("Sunshine")
	RunService:BindToRenderStep("Sunshine", Enum.RenderPriority.Last.Value, function()

		if self.EnableSun then
			SunTextureGui.Enabled = true
			meta.Sky.SunTextureId = "rbxasset://sky/sun.jpg"
		else
			SunTextureGui.Enabled = false
			meta.Sky.SunTextureId = ""
		end
		
		local SunBrightness = self.SunBrightness
		local SunDirectionV = game.Lighting:GetSunDirection()
		local sunPosition = Camera.CFrame.p+SunDirectionV * 999
		local screenPosition, isVisible = Camera:WorldToScreenPoint(sunPosition)
		local CamToSun = Ray.new(Camera.CFrame.p, SunDirectionV * 999)
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
		local SunsetFOVTransparencyScale = 1 
		- math.clamp(
			((workspace.CurrentCamera.FieldOfView - 5) 
				/ 5 + 1) 
				* (HorizonElevationSunsetDifference ^ 3 / 10), 0, 1
		)
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

		table.insert(ignore, meta.Atmosphere)
		if CamZoomDistance <= 1.1 then -- Check if player is in first person.
			table.insert(ignore,Character)
		elseif CamZoomDistance > 1.1 then
			ignore.Character = nil
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
			meta.Sun3D.SunsetLight.Light.ImageTransparency = HorizonElevationSunsetDifference10Ratio
			meta.Sun3D.Mesh.Scale = Vector3.new(
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
		local TempValue
		if not self.EnableSunScattering then
			TempValue = self.SunTemp
		else
			TempValue = math.clamp(self.SunTemp, 2001, math.huge)
		end
		local Temp = (TempValue + 1095) / 100
		if TempValue > 2000 and TempValue <= 6600 then
			meta.SunColor.R = 255
			meta.SunColor.G = 104.49216199393888*math.log(Temp-2)-0.44596950469579133*Temp-155.25485562709179
			meta.SunColor.B = 115.67994401066147*math.log(Temp-10)+0.8274096064007395*Temp-254.76935184120902
		end
		local SunR = meta.SunColor.R
		local SunG = meta.SunColor.G
		local SunB = meta.SunColor.B
		--[[if TempValue <= 0 then
			meta.SunColor.R = 255
			meta.SunColor.G = 76
			meta.SunColor.B = 0
		elseif TempValue > 0 and TempValue <= 1000 then
			meta.SunColor.R = 255
			meta.SunColor.B = 99.4708025861*math.log(Temp)-161.1195681661
			meta.SunColor.G = 0
		elseif TempValue > 1000 and TempValue <= 2000 then
			meta.SunColor.R = 255
			meta.SunColor.G = 104.49216199393888*math.log(Temp-2)-0.44596950469579133*Temp-155.25485562709179
			meta.SunColor.B = 0
		elseif TempValue > 6600 and TempValue <= 40000 then
			meta.SunColor.R = -40.25366309332127*math.log(Temp-55)+0.114206453784165*Temp+351.97690566805693
			meta.SunColor.G = -28.0852963507957*math.log(Temp-50)+0.07943456536662342*Temp+325.4494125711974
			meta.SunColor.B = 255
		elseif TempValue > 40000 then
			meta.SunColor.R = 162
			meta.SunColor.G = 192
			meta.SunColor.B = 255
		end]]

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
			meta.Sun3D.SunsetLight.ExtentsOffsetWorldSpace = Vector3.new(5, 0, 0)
		else
			meta.Sun3D.SunsetLight.ExtentsOffsetWorldSpace = Vector3.new(-5, 0, 0)
		end

		local AboveHorizon = HorizonElevationSunsetDifference > -2
		if x > 5000 then
			AboveHorizon = HorizonElevationSunsetDifference > 0
		elseif x > 1000 and x <= 5000 then
			AboveHorizon = HorizonElevationSunsetDifference > -0.5
		end
		if script.Customize.EnableSun.Value then
			if AboveHorizon and HorizonElevationSunsetDifference < H1 then
				meta.Sun3D.Position = Camera.CFrame.Position
				meta.Sun3D.Mesh.Offset = Vector3.new(70000, 
					70000, 
					70000
				) * SunDirectionV
			else
				meta.Sun3D.Position = Vector3.new(0, -200000, 0)
				meta.Sun3D.Mesh.Offset = meta.Sun3D.Position
			end
			meta.Sun3D.SunsetLight.StudsOffsetWorldSpace = meta.Sun3D.Mesh.Offset
			meta.Sun3D.SunsetLight.Brightness = math.clamp(
				400 
				- (x / 28), 
				40, 
				400
			)
			meta.Sun3D.SunsetLight.Size = UDim2.new(
				10000 
				* meta.SunBrightness, 
				0, 
				math.clamp(
					(-x / 16) 
					+ 10000, 
					4000, 
					10000
				) * SunBrightness, 0
			)
			meta.Sun3D.SunsetLight.Light.ImageColor3 = script.Customize.EnableSun.ThreeDimensionalSunAtmosphericExtinctionColor.Value
		else
			meta.Sun3D.Position = Camera.CFrame.Position - Vector3.new(0, 100000, 0)
		end
	end)
end

function AtmoSphere:Update()
	local AtmoThinness = self.AtmosphereTransparency
	local AtmoHeight = (self.AtmosphereThickness^-1)^0.0625
	local Color = rgb(
		self.AtmosphereColor.R * 255,
		self.AtmosphereColor.G * 255,
		self.AtmosphereColor.B * 255
	)
	local ColorSunset = rgb(
		self.AtmosphereSunsetColor.R * 255,
		self.AtmosphereSunsetColor.G * 255,
		self.AtmosphereSunsetColor.B * 255
	)
	local Color2 = rgb(
		self.DistantSurfaceColor.R * 255,
		self.DistantSurfaceColor.G * 255,
		self.DistantSurfaceColor.B * 255
	)
	x = (Camera.CFrame.Position.Y + self.AtmosphereOffset) * ScaleFactor
	local SunDirectionV = Lighting:GetSunDirection()
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

	local t3 = Lighting:GetMinutesAfterMidnight()

	if HorizonElevationSunsetDifference <= -18 then
		meta.Atmosphere.Transparency = 1
		meta.Sky.StarCount = 3000
	elseif HorizonElevationSunsetDifference > -18 and HorizonElevationSunsetDifference <= -14 then
		meta.Atmosphere.Transparency = -(HorizonElevationSunsetDifference+14)/4
		meta.Sky.StarCount = 3000
	elseif HorizonElevationSunsetDifference > -14 and HorizonElevationSunsetDifference <= 0 then
		meta.Atmosphere.Transparency = 0
		meta.Sky.StarCount = 3000
	elseif HorizonElevationSunsetDifference > 0 then
		meta.Atmosphere.Transparency = 0
		meta.Sky.StarCount = 0
	end

	if HorizonElevationSunsetDifference >= 0 and HorizonElevationSunsetDifference < 3.75 then -- Pre-Sunrise/set
		local ColorRResultant = math.clamp((-(ColorSunset.R - Color.R) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorSunset.R, 
			math.min(Color.R, ColorSunset.R), 
			math.max(Color.R, ColorSunset.R)
		)
		local ColorGResultant = math.clamp((-(ColorSunset.G - Color.G) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorSunset.G, 
			math.min(Color.G, ColorSunset.G), 
			math.max(Color.G, ColorSunset.G))
		local ColorBResultant = math.clamp((-(ColorSunset.B - Color.B) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorSunset.B, math.min(Color.B, ColorSunset.B), math.min(Color.B, ColorSunset.B))
		self.OutdoorAmbientBrightnessEquation = (
			((meta.OutdoorAmbientBrightnessDay
				-meta.OutdoorAmbientBrightnessNight)/17.75)
				*(HorizonElevationSunsetDifference-3.75)
				+script.Customize.EnableEnvironmentalLightingChanges.OutdoorAmbientBrightnessDay.Value)/255
		Lighting.FogColor = Color3.new(
			((ColorRResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorGResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorBResultant/17.75)*(HorizonElevationSunsetDifference+14))/255
		)
		Lighting.FogEnd = (-100000*(HorizonElevationSunsetDifference-3.75)+100000)
			*self.FogEndRatio
			*AtmoThinness
		meta.DistantSurface.Color = Color3.new(Color2.R/255, Color2.G/255, Color2.B/255)
		meta.SunBrightness = meta.SunlightBrightness
		meta.AirglowLayer.Transparency = 1
		meta.EarthTransparency = ((script.Customize.PlanetTransparency.Value-0.011)/3.75)*HorizonElevationSunsetDifference+0.011
		meta.EarthTexture.Color3 = Color3.new(1, 1, 1)
	elseif HorizonElevationSunsetDifference >= -7 and HorizonElevationSunsetDifference < 0 then -- Civil twilight
		local ColorRResultant = math.clamp((-(ColorSunset.R - Color.R) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorSunset.R, 
			math.min(Color.R, ColorSunset.R), 
			math.max(Color.R, ColorSunset.R))
		
		local ColorGResultant = math.clamp((-(ColorSunset.G - Color.G) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) + ColorSunset.G, 
			math.min(Color.G, ColorSunset.G), 
			math.max(Color.G, ColorSunset.G))
		
		local ColorBResultant = math.clamp((-(ColorSunset.G - Color.G) / (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) 
			+ ColorSunset.B, 
			math.min(Color.B, ColorSunset.B), 
			math.min(Color.B, ColorSunset.B))
		
		self.OutdoorAmbientBrightnessEquation = (
			((self.OutdoorAmbientBrightnessDay
				-self.OutdoorAmbientBrightnessNight)/17.75)
				*(HorizonElevationSunsetDifference-3.75)
				+self.OutdoorAmbientBrightnessDay)/255
		
		Lighting.FogColor = Color3.new(
			((ColorRResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorGResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorBResultant/17.75)*(HorizonElevationSunsetDifference+14))/255
		)
		
		Lighting.FogEnd = (-25000
			*(HorizonElevationSunsetDifference)+475000)
			*self.FogEndRatio
			*AtmoThinness
		
		meta.DistantSurface.Color = Color3.new(0,0,0)
		self.SunBrightness = self.NightBrightness
		meta.AirglowLayer.Transparency = self.AirglowTransparency + self.AirglowTransparency
		meta.EarthTransparency = 0.011
		meta.EarthTexture.Color3 = Color3.new(7,7,4.5)
	elseif HorizonElevationSunsetDifference >= -14 and HorizonElevationSunsetDifference < -7 then -- Nautical twilight
		local ColorRResultant = math.clamp((-(ColorSunset.R - Color.R) 
			/ (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) 
			+ ColorSunset.R, math.min(Color.R, ColorSunset.R), 
			math.max(Color.R, ColorSunset.R))
		
		local ColorGResultant = math.clamp((-(ColorSunset.G - Color.G)
			/ (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) 
			+ ColorSunset.G, math.min(Color.G, ColorSunset.G), 
			math.max(Color.G, ColorSunset.G))
		
		local ColorBResultant = math.clamp((-(ColorSunset.B - Color.B) 
			/ (H3 / 2.666666666666))
			* math.abs(HorizonElevationSunsetDifference) 
			+ ColorSunset.B, math.min(Color.B, ColorSunset.B), 
			math.min(Color.B, ColorSunset.B))
		
		self.OutdoorAmbientBrightnessEquation = (
			((self.OutdoorAmbientBrightnessDay
				-self.OutdoorAmbientBrightnessNight)/17.75)
				*(HorizonElevationSunsetDifference-3.75)
				+self.OutdoorAmbientBrightnessDay)/255
		
		Lighting.FogColor = Color3.new(
			((ColorRResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorGResultant/17.75)*(HorizonElevationSunsetDifference+14))/255,
			((ColorBResultant/17.75)*(HorizonElevationSunsetDifference+14))/255
		)
		
		Lighting.FogEnd = ((550000/7)*(HorizonElevationSunsetDifference+7)+650000)*self.FogEndRatio*AtmoThinness
		meta.DistantSurface.Color = Color3.new(0,0,0)
		self.SunBrightness = self.NightBrightness
		meta.AirglowLayer.Transparency = self.AirglowTransparency + self.AirglowTransparency
		meta.EarthTransparency = 0.011
		meta.EarthTexture.Color3 = Color3.new(7,7,4.5)
	elseif HorizonElevationSunsetDifference < -14 then -- Night
		self.OutdoorAmbientBrightnessEquation = self.OutdoorAmbientBrightnessNight/255
		Lighting.FogColor = Color3.new(0,0,0)
		Lighting.FogEnd = 100000*self.FogEndRatio*AtmoThinness
		meta.DistantSurface.Color = Color3.new(0,0,0)
		self.SunBrightness = self.NightBrightness
		meta.AirglowLayer.Transparency = self.AirglowTransparency + self.AirglowTransparency
		meta.EarthTransparency = 0.011
		meta.EarthTexture.Color3 = Color3.new(7,7,4.5)
	elseif HorizonElevationSunsetDifference >= 3.75 then -- Broad daylight
		self.OutdoorAmbientBrightnessEquation = self.OutdoorAmbientBrightnessDay/255
		Lighting.FogColor = Color3.new(Color.R/255, Color.G/255, Color.B/255)
		Lighting.FogEnd = 100000*self.FogEndRatio*AtmoThinness
		meta.DistantSurface.Color = Color3.new(Color2.R/255, Color2.G/255, Color2.B/255)
		self.SunBrightness = self.SunlightBrightness
		meta.AirglowLayer.Transparency = 1
		meta.EarthTransparency = self.PlanetTransparency
		meta.EarthTexture.Color3 = Color3.new(1,1,1)
	end

	local Daycolor = Color3.fromRGB(self.DaytimeSunlightColor.R,
		self.DaytimeSunlightColor.G,
		self.DaytimeSunlightColor.B
	)
	local SunsetColor = Color3.fromRGB(self.SunriseSunlightColor.R, 
		self.SunriseSunlightColor.G,
		self.SunriseSunlightColor.B
	)
	if self.EnableEnvironmentalLightingChanges then
		Lighting.OutdoorAmbient = Color3.new(self.OutdoorAmbientBrightnessEquation,
			self.OutdoorAmbientBrightnessEquation,
			self.OutdoorAmbientBrightnessEquation
		)
		
		Lighting.Brightness = self.SunBrightness
		Lighting.ColorShift_Top = Color3.new(
			(((Daycolor.R-SunsetColor.R)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunsetColor.R,
			(((Daycolor.G-SunsetColor.G)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunsetColor.G,
			(((Daycolor.B-SunsetColor.B)/(6*(2^(-x/500000))))*HorizonElevationSunsetDifference10)+SunsetColor.B
		)
	else end
	-- For the atmospheric extinction:

	local AtmosphericExtinction = Color3.fromRGB(
		self.AtmosphericExtinctionColor.R,
		self.AtmosphericExtinctionColor.G,
		self.AtmosphericExtinctionColor.B
	)

	local HorizonElevationSunsetDifferenceAdjustmentEquation = -(((HorizonElevationSunsetDifference - 10) ^ 4) / 1000) + 10

	if HorizonElevationSunsetDifference <= H3 and HorizonElevationSunsetDifference > 0 then
		self.LightEmissionEquation = (1/H3)*HorizonElevationSunsetDifference
		self.ExtinctionSunsetTransparencyEquation = (1/H3*HorizonElevationSunsetDifference)
		if self.EnableSunsetScattering then
			self.ExtinctionTransparencyEquation = (0.8/H3*HorizonElevationSunsetDifferenceAdjustmentEquation)
			self.ExtinctionColorEquation = Color3.fromRGB(
				((255-AtmosphericExtinction.R)/10*(2^(-x/500000)))*HorizonElevationSunsetDifference+AtmosphericExtinction.R,
				((255-AtmosphericExtinction.G)/10*(2^(-x/500000)))*HorizonElevationSunsetDifference+AtmosphericExtinction.G,
				((255-AtmosphericExtinction.B)/10*(2^(-x/500000)))*HorizonElevationSunsetDifference+AtmosphericExtinction.B
			)
		else
			self.ExtinctionTransparencyEquation = 0.8
			self.ExtinctionColorEquation = Color3.fromRGB(255, 255, 255)
		end
	elseif HorizonElevationSunsetDifference > H3 then
		self.LightEmissionEquation = 1
		self.ExtinctionTransparencyEquation = 0.8
		self.ExtinctionSunsetTransparencyEquation = 1
		self.ExtinctionColorEquation = Color3.fromRGB(255,255,255)
	elseif HorizonElevationSunsetDifference > -14 and HorizonElevationSunsetDifference <= 0 then
		self.LightEmissionEquation = 0
		self.ExtinctionSunsetTransparencyEquation = (1
			/(1.2*H3)
			*math.abs(HorizonElevationSunsetDifference))
		if self.EnableSunsetScattering then
			self.ExtinctionTransparencyEquation = (-HorizonElevationSunsetDifference/14)
			local AstroAtmosphericExtinction = Color3.fromRGB(self.AstronomicalTwilightAtmosphericExtinctionColor.R*255,
				self.AstronomicalTwilightAtmosphericExtinctionColor.G*255,
				self.AstronomicalTwilightAtmosphericExtinctionColor.B*255
			)
			self.ExtinctionColorEquation = Color3.fromRGB(
				((AstroAtmosphericExtinction.R-AtmosphericExtinction.R)/14)*-HorizonElevationSunsetDifference+AtmosphericExtinction.R,
				((AstroAtmosphericExtinction.G-AtmosphericExtinction.G)/14)*-HorizonElevationSunsetDifference+AtmosphericExtinction.G,
				((AstroAtmosphericExtinction.B-AtmosphericExtinction.B)/14)*-HorizonElevationSunsetDifference+AtmosphericExtinction.B
			)
		else
			self.ExtinctionTransparencyEquation = 0.8
			self.ExtinctionColorEquation = Color3.fromRGB(255,255,255)
		end
	elseif HorizonElevationSunsetDifference <= -14 then
		self.LightEmissionEquation = 0
		self.ExtinctionTransparencyEquation = 1
		self.ExtinctionSunsetTransparencyEquation = 1
		if self.EnableSunsetScattering then
			self.ExtinctionColorEquation = Color3.fromRGB(AtmosphericExtinctionR,AtmosphericExtinctionG,AtmosphericExtinctionB)
		else
			self.ExtinctionTransparencyEquation = 0.8
			self.ExtinctionColorEquation = Color3.fromRGB(255,255,255)
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
		BottomAtmosphereMesh.VertexColor = meta.EarthMesh.VertexColor
	else
		meta.BottomAtmosphere.Position = Vector3.new(0,0,0)
		meta.BottomAtmosphere.Transparency = 1
		meta.BottomAtmosphereMesh.VertexColor = meta.EarthMesh.VertexColor
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
			meta.Earth.Orientation = script.Customize.EnableApparentPlanetRotation.InitialPlanetOrientation.Value
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
		meta.BottomAtmosphereDarkness.Transparency = math.clamp(ATDa * (x ^ ATDb) + ATDc * (x ^ ATDd), 0, 1) + ATDTimeCompensation
	else
		meta.BottomAtmosphereDarkness.Transparency = 1
	end
	-- EARTH'S ATMOSPHERE COLOR (SPECIAL CASE)
	if script.Customize.AtmosphereColor.Value == Color3.fromRGB(115, 180, 255) then
		local groundAtmosphereColorFactor = math.clamp(1 - ((x/ScaleFactor) / 32808), 0, 1) * (math.clamp(HorizonElevationSunsetDifference, 0, 10) / 10)
		meta.Atmosphere.Color = Color3.new(
			0,
			(95 / 255) * groundAtmosphereColorFactor,
			(148 / 255) * groundAtmosphereColorFactor
		)

		local sunsetFade15 = math.clamp(meta.HorizonElevationSunsetDifference / H15, 0, 1)
		local altitudeFade = 1 - math.clamp((((x/ScaleFactor) - 100000) / 20000), 0, 1)
		game.Lighting.FogColor = Color3.new(
			game.Lighting.FogColor.R * (1 + (0.0434782608695652 * sunsetFade15 * altitudeFade)),
			game.Lighting.FogColor.G * (1 + (0.2222222222222222 * sunsetFade15 * altitudeFade)),
			game.Lighting.FogColor.B * (1 + (0.4313725490196079 * sunsetFade15 * altitudeFade))
		)
	else
		meta.Atmosphere.Color = Color3.new()
	end
	local atmosphericReflectionColorFactor = math.clamp(meta.HorizonElevationSunsetDifference / 10, 0, 1)
	game.Lighting.Ambient = Color3.new(
		script.Customize.AtmosphereColor.AtmosphereReflectionColor.Value.R * atmosphericReflectionColorFactor,
		script.Customize.AtmosphereColor.AtmosphereReflectionColor.Value.G * atmosphericReflectionColorFactor,
		script.Customize.AtmosphereColor.AtmosphereReflectionColor.Value.B * atmosphericReflectionColorFactor
	)
end)
