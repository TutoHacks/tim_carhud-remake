	local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local vSyncwetter = false -- if you have activated vsync set it to true

local prox = 10.0
local isTalking = false
local elementeSperren = false
local wszedlDoGry = false
local großeMap = false
local fortschrittHud = false
local verschiebenHud = false
local warten = 500

local inVeh = false
local distance = 0
local vehPlate

local x = 0.01135
local y = 0.002
hasKM = 0
showKM = 0

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(500)
		if not wszedlDoGry then
			NetworkSetVoiceActive(false)
			NetworkSetTalkerProximity(1.0)
			wszedlDoGry = true
		end
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	NetworkSetTalkerProximity(1.0)
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(warten)
		local playerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(playerPed, true) then
			warten = 150
			local playerVeh = GetVehiclePedIsIn(playerPed, false)
			if großeMap == false then
				if fortschrittHud == false then
					fortschrittHud = true
					SendNUIMessage({action = "toggleCar", show = true})
				end
				SendNUIMessage({action = "animateHud", show = true})
			else
				SendNUIMessage({action = "animateMap", show = true})		
			end
			fuel = math.floor(GetVehicleFuelLevel(playerVeh)+0.0)		
			SendNUIMessage({action = "updateGas", key = "gas", value = fuel})
			radarToggle(true)
			if not großeMap then

			end
			standort = false
		else
			warten = 500
			if fortschrittHud == true then
				fortschrittHud = false
				SendNUIMessage({action = "toggleCar", show = false})
			end
			if not elementeSperren then
				if verschiebenHud == false then
					verschiebenHud = true
					SendNUIMessage({action = "animateHud", show = true})
				end
			end
			radarToggle(false)
			if IsControlPressed(1, 243) then
				radarToggle(true)
				SendNUIMessage({action = "toggleAllHud", show = true})
				SendNUIMessage({action = "animateMap", show = true})
				standort = true
			else
				SendNUIMessage({action = "toggleAllHud", show = false})
				if not elementeSperren then
					SendNUIMessage({action = "animateMap", show = false})
				end
				standort = false
				if not großeMap then
				end
			end
		end
	end
end)

function radarToggle(on)
DisplayRadar(true)
	if on and not elementeSperren then
		if verschiebenHud == false then
			verschiebenHud = true
			SendNUIMessage({action = "animateHud", show = true})
		end
		
	elseif not elementeSperren then
		if verschiebenHud == true then
			verschiebenHud = false
			SendNUIMessage({action = "animateHud", show = false})
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local playerPed = PlayerPedId()
		if IsPedInAnyVehicle(playerPed, false) then
			local vehicle = GetVehiclePedIsIn(playerPed, false)
			local lockStatus = GetVehicleDoorLockStatus(vehicle)

			if GetIsVehicleEngineRunning(vehicle) == false then
				SendNUIMessage({action = "engineSwitch", status = false})
			else
				SendNUIMessage({action = "engineSwitch", status = true})
			end
			if (lockStatus == 0 or lockStatus == 1) then
				SendNUIMessage({action = "lockSwitch", status = true})
			elseif lockstatus ~= 0 and lockstatus ~= 1 then
				SendNUIMessage({action = "lockSwitch", status = false})
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(1, 243) then
			SendNUIMessage({action = "toggleCar", show = false})
			if not elementeSperren then
				SendNUIMessage({action = "animateMap", show = true})
			end
			großeMap = true
		elseif IsControlJustReleased(1, 243) and großeMap == true then
			großeMap = false
			if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
				SendNUIMessage({action = "toggleCar", show = true})
				SendNUIMessage({action = "animateHud", show = true})
			end

		end
	end
end)

local zones = { ['AIRP'] = "Airport LS", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "Klub Golfowy", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port LS", ['ZQ_UAR'] = "Davis Quartz" }
local directions = { [0] = 'N', [45] = 'NW', [90] = 'W', [135] = 'SW', [180] = 'S', [225] = 'SE', [270] = 'E', [315] = 'NE', [360] = 'N', }
local textLokalisierung = ''
local zeittag = ''
local wetterHash = ''

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		local Ped = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(Ped, false)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			carSpeed = math.ceil(GetEntitySpeed(PedCar) * 2.0)
			SendNUIMessage({
				showhud = true,
				speed = carSpeed
			})
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]

		for k,v in pairs(directions)do
			direction = GetEntityHeading(GetPlayerPed(-1))
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break;
			end
		end

		if(GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z)) then
			if(zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1))) then
				textLokalisierung = direction..' | '..tostring(GetStreetNameFromHashKey(var1))
				SendNUIMessage({
					showstandort = true,
					standort = textLokalisierung
				})
			end
		end

	end
end)

RegisterNetEvent('tim_carhud:UstawPogode')
AddEventHandler('tim_carhud:UstawPogode', function(wetter)
    wetterHash = wetter
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local tagInt = GetClockDayOfWeek()
		local tag = ''
		if tagInt == 0 then
			tag = 'Sunday'
		elseif tagInt == 1 then
			tag = 'Monday'
		elseif tagInt == 2 then
			tag = 'Tuesday'
		elseif tagInt == 3 then
			tag = 'Wednesday'
		elseif tagInt == 4 then
			tag = 'Thursday'
		elseif tagInt == 5 then
			tag = 'Friday'
		elseif tagInt == 6 then
			tag = 'Saturday'
		end

		local sekundeInt = GetClockHours()
		local sekunde = ''
		if string.len(tostring(sekundeInt)) == 1 then
			sekunde = '0'..sekundeInt
		else
			sekunde = sekundeInt
		end

		local minuteInt = GetClockMinutes()
		local minute = ''
		if string.len(tostring(minuteInt)) == 1 then
			minute = '0'..minuteInt
		else
			minute = minuteInt
		end

		local wetter = ''

		if vSyncwetter == true then
			if wetterHash == 'EXTRASUNNY' then
				wetter = 'Sunny'
			elseif wetterHash == 'CLEAR' then
				wetter = 'Clear'
			elseif wetterHash == 'NEUTRAL' then
				wetter = 'Neutral'
			elseif wetterHash == 'SMOG' then
				wetter = 'Smog'
			elseif wetterHash == 'FOGGY' then
				wetter = 'Fog'
			elseif wetterHash == 'OVERCAST' then
				wetter = 'Overcast'
			elseif wetterHash == 'CLOUDS' then
				wetter = 'Clouds'
			elseif wetterHash == 'CLEARING' then
				wetter = 'Clearing'
			elseif wetterHash == 'RAIN' then
				wetter = 'Rain'
			elseif wetterHash == 'THUNDER' then
				wetter = 'Thunder'
			elseif wetterHash == 'BLIZZARD' then
				wetter = 'Blizzard'
			elseif wetterHash == 'SNOWLIGHT' then
				wetter = 'Winter'
			elseif wetterHash == 'XMAS' then
				wetter = 'Christmas'
			elseif wetterHash == 'HALLOWEEN' then
				wetter = 'Halloween'
			end

			zeittag = sekunde..':'..minute..' | '..tag..' | '..wetter
		else
			zeittag = sekunde..':'..minute..' | '..tag
		end

		SendNUIMessage({
			showDni = true,
			dni = zeittag
		})
	end
end)



Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(250)
			  if IsPedInAnyVehicle(PlayerPedId(), false) and not inVeh then
			  Citizen.Wait(50)
			  local veh = GetVehiclePedIsIn(PlayerPedId(),false)
			  local driver = GetPedInVehicleSeat(veh, -1)
			  if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
			  inVeh = true
			  Citizen.Wait(50)
			  vehPlate = GetVehicleNumberPlateText(veh)
			  Citizen.Wait(1)
			  ESX.TriggerServerCallback('tim_carhud:getKilometerstand', function(hasKM)
			  showKM = math.floor(hasKM*1.33)/1000
			  local oldPos = GetEntityCoords(PlayerPedId())
			  Citizen.Wait(1000)
			  local curPos = GetEntityCoords(PlayerPedId())
			  if IsVehicleOnAllWheels(veh) then
			  dist = GetDistanceBetweenCoords(oldPos.x, oldPos.y, oldPos.z, curPos.x, curPos.y, curPos.z, true)
			  else
			  dist = 0
			  end
			  hasKM = hasKM + dist
			  TriggerServerEvent('tim_carhud:addKilometerstand', vehPlate, hasKM)
			  inVeh = false
			  end, GetVehicleNumberPlateText(veh))
			  else
			  end
		  end
	  end
  end)
  
  displayHud = true
  
	  Citizen.CreateThread(function()
		  while true do
			  if IsPedInAnyVehicle(PlayerPedId(), false) then
						  local veh = GetVehiclePedIsIn(PlayerPedId(),false)
					  local driver = GetPedInVehicleSeat(veh, -1)
					  if driver == PlayerPedId() and GetVehicleClass(veh) ~= 13 and GetVehicleClass(veh) ~= 14 and GetVehicleClass(veh) ~= 15 and GetVehicleClass(veh) ~= 16 and GetVehicleClass(veh) ~= 17 and GetVehicleClass(veh) ~= 21 then
				  SendNUIMessage({action = "updateKM", key = "km", value = round(showKM, 2)})
				  end
			  else
				  Citizen.Wait(750)
			  end
  
			  Citizen.Wait(0)
		  end
	  end)
	  
  function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
  end
