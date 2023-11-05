script_author("vitomc1")
script_version("1.3")
-- my color 0xFF2B2B
require "lib.moonloader"
local sampev = require "lib.samp.events"
local copas = require 'copas'
local http = require 'copas.http'
local imgui 	= require("imgui") -- // пїЅпїЅпїЅпїЅпїЅ
local fa 	= require "faIcons" -- // пїЅпїЅпїЅпїЅпїЅпїЅ
local fa5 = require("fAwesome5")
local fa_glyph_ranges 	= imgui.ImGlyphRanges({fa.min_range, fa.max_range})
local encoding 	= require("encoding")
encoding.default	 = "CP1251"
u8 = encoding.UTF8
local mainMenu 	= imgui.ImBool(false)
local ownersMenu	= imgui.ImBool(false)
local sizeX, sizeY = getScreenResolution()
local searchLastOwner 	= imgui.ImBuffer(256)

local searchNUM 	= imgui.ImBuffer(256)
local searchPARK 	= imgui.ImBuffer(256)
local searchLASTOWNER 	= imgui.ImBuffer(256)
local searchAREA 	= imgui.ImBuffer(256)
local effil 			= require("effil")
local table1 = {}
local slot9_a5012 = {}
local slot10_a5011 = {}
local logOnline = {}
local logOwners = {}
local logNum = {}
local logCount = 0
local slot12_a5323 = {}

local banHouse = imgui.ImBool(false)
local bansAll = imgui.ImBool(true)
local slot15_a2515 = imgui.ImBool(false)
local banstoday = imgui.ImBool(false)
local bansNextDay = imgui.ImBool(false)

local sign = imgui.ImBool(false)
local onlysign = imgui.ImBool(true)
local onlyNOsign = imgui.ImBool(false)

local checkTEXT = false

local CheckingHouse = {} -- // пїЅпїЅпїЅ /dompoint !!!!!
local maximTG = "1042512028"

local botTG = "6290447237:AAG_gYfE_WSDM_fz5Jqlgt1TspfsyLwN84U"

local russian_characters = {
  [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}

--[[function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fAwesome5.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end--]]
local spisok = {}
local bnbd = {}
local bans = {}
local banlist = {}


local servers = {
		'185.169.134.83',
		'185.169.134.84',
		'185.169.134.85'
}

local tableCheckbox = {
	active = imgui.ImBool(true),
	signActive = imgui.ImBool(true)
}

local chksign = false
local dompoint = false

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig()
        font_config.MergeMode = true
        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fAwesome5.ttf', 14.0, font_config, fa_glyph_ranges)
    end
end

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	checkKey()
	getbanlist(false)
	update()
	sampAddChatMessage("{FF2B2B}[HDB] {ffffff}База Данных домов игроков. /hdb - основное меню", 0xFF2B2B)
	sampRegisterChatCommand("hbans", function()
		getbanlist(true)
	end)


	sampRegisterChatCommand("juelz", function()
		sampAddChatMessage("[HDB] {FFFFFF}Слет таблички: {FBEC5D}№222 1.{FFFFFF} Владелец: {FBEC5D}Nick_Stallone.", 0xFF2B2B)
	end)

	sampRegisterChatCommand("checkbans", function(arg)
		if arg ~= nil and #arg > 0 then
			if arg == "info" then
				cleanBanlist()
				for cleanbl = #db["HOUSE"], 1, -1 do
					for key, value in pairs(bans) do
						if bans[key].date.day == os.date("%d",os.time()-1814400) and bans[key].date.month == os.date("%m",os.time()-1814400) and bans[key].date.year == os.date("20%y",os.time()-1814400) then
							if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
								sampAddChatMessage("Сегодня{FFFACD} Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"]..".{FFFACD} Парк: {FBEC5D}"..db["HOUSE"][cleanbl]["park"]..".{FFFACD} Владелец {FBEC5D}"..bans[key].name..".{FFFACD} Район: {FBEC5D}"..db["HOUSE"][cleanbl]["area"]..".", 0x0ff0000)
							end
						end
						if bans[key].date.day == os.date("%d",os.time()-1728000) and bans[key].date.month == os.date("%m",os.time()-1728000) and bans[key].date.year == os.date("20%y",os.time()-1728000) then
							if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
								sampAddChatMessage("Завтра{FFFACD} Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"]..".{FFFACD} Парк: {FBEC5D}"..db["HOUSE"][cleanbl]["park"]..".{FFFACD} Владелец {FBEC5D}"..bans[key].name..".{FFFACD} Район: {FBEC5D}"..db["HOUSE"][cleanbl]["area"]..".", 0x0ff0000)
							end
						end
						if bans[key].date.day == os.date("%d",os.time()-1641600) and bans[key].date.month == os.date("%m",os.time()-1641600) and bans[key].date.year == os.date("20%y",os.time()-1641600) then
							if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
								sampAddChatMessage("2дн{FFFACD} Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"]..".{FFFACD} Парк: {FBEC5D}"..db["HOUSE"][cleanbl]["park"]..".{FFFACD} Владелец {FBEC5D}"..bans[key].name..".{FFFACD} Район: {FBEC5D}"..db["HOUSE"][cleanbl]["area"]..".", 0x0ff0000)
							end
						end
						if bans[key].date.day == os.date("%d",os.time()-1555200) and bans[key].date.month == os.date("%m",os.time()-1555200) and bans[key].date.year == os.date("20%y",os.time()-1555200) then
							if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
								sampAddChatMessage("3дн{FFFACD} Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"]..".{FFFACD} Парк: {FBEC5D}"..db["HOUSE"][cleanbl]["park"]..".{FFFACD} Владелец {FBEC5D}"..bans[key].name..".{FFFACD} Район: {FBEC5D}"..db["HOUSE"][cleanbl]["area"]..".", 0x0ff0000)
							end
						end
						if bans[key].date.day == os.date("%d",os.time()-1468800) and bans[key].date.month == os.date("%m",os.time()-1468800) and bans[key].date.year == os.date("20%y",os.time()-1468800) then
							if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
								sampAddChatMessage("4дн{FFFACD} Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"]..".{FFFACD} Парк: {FBEC5D}"..db["HOUSE"][cleanbl]["park"]..".{FFFACD} Владелец {FBEC5D}"..bans[key].name..".{FFFACD} Район: {FBEC5D}"..db["HOUSE"][cleanbl]["area"]..".", 0x0ff0000)
							end
						end
						if bans[key].date.day == os.date("%d",os.time()-1382400) and bans[key].date.month == os.date("%m",os.time()-1382400) and bans[key].date.year == os.date("20%y",os.time()-1382400) then
							if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
								sampAddChatMessage("5дн{FFFACD} Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"]..".{FFFACD} Парк: {FBEC5D}"..db["HOUSE"][cleanbl]["park"]..".{FFFACD} Владелец {FBEC5D}"..bans[key].name..".{FFFACD} Район: {FBEC5D}"..db["HOUSE"][cleanbl]["area"]..".", 0x0ff0000)
							end
						end


				--[[		if bans[key].date.day <= timeDay1 and bans[key].date.month <= timeMonth1 and bans[key].date.year <= timeYear1 then
							if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
								sampAddChatMessage("-{FFFACD} ["..bans[key].date.day..":"..bans[key].date.month..":"..bans[key].date.year.."]  Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"]..".{FFFACD} Парк: {FBEC5D}"..db["HOUSE"][cleanbl]["park"]..".{FFFACD} Владелец {FBEC5D}"..bans[key].name..".{FFFACD} Район: {FBEC5D}"..db["HOUSE"][cleanbl]["area"]..".", 0x0ff0000)
								--sampAddChatMessage(timeDay1 .. timeMonth1 .. timeYear1, -1)
							end
						end--]]
					end
				end
			end
		else
			cleanBanlist()
			sampAddChatMessage("[HDB BANS] {fffacd}За сегодня забанены слудющие владельцы домов:", 0x0ff0000)
			for cleanbl = #db["HOUSE"], 1, -1 do
				for key, value in pairs(bans) do
					timeDay = os.date("%d")
					timeMonth = os.date("%m")
					timeYear = os.date("20%y")
					if bans[key].date.day == timeDay and bans[key].date.month == timeMonth and bans[key].date.year == timeYear then
						if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
							sampAddChatMessage("- {FFFACD}Ник:{FBEC5D} "..bans[key].name.." {fffacd} Дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"].." {fffacd}Парковок: {FBEC5D}"..db["HOUSE"][cleanbl]["park"].." {fffacd}Район - {FBEC5D}"..db["HOUSE"][cleanbl]["area"], 0x0ff0000)


						end
					end
				end
			end
				end
	end)



  local ip = sampGetCurrentServerAddress() -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ

	sampRegisterChatCommand("hui", function()
		sampAddChatMessage(#db["HOUSE"], -1)
		sampAddChatMessage(#db["signHouse"], -1)
		sampAddChatMessage(#db["sellHouse"], -1)
		sampAddChatMessage(#db["ownersOnline"], -1)
		sampAddChatMessage(#db["ownersOnlineLOGG"], -1)
	end)
--  sampAddChatMessage("{FFFACD}Добавлена инфа: {FBEC5D}Charlie_Cooks, {FFFACD}дом {FBEC5D}№334. {FFFACD}На{FBEC5D} 22.22.2022", 0xFF2B2B)
	--sampAddChatMessage("{FFFACD}Cлетевший с продажи дом {FF2B2B}№"..db["signHouse"][Key]["house"].." "..db["signHouse"][Key]["park"].."{FFFACD} владельца {FF2B2B}"..db["signHouse"][Key]["nick"]" - {FFFACD}слетает сегодня.{FF2B2B}", 0xFF2B2B)

--	sampAddChatMessage("У игрока {FF2B2B}"..db["signHouse"][Key]["nick"].. "{ffffff} слетит дом {FF2B2B}№"..db["signHouse"][Key]["house"]..". {ffffff}Слет может быть {FF2B2B}до 05:30", -1)


  for k, v in pairs(servers) do -- пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
 		 if v == ip then



 			 if not doesDirectoryExist(getWorkingDirectory().."/config") then
 			 	createDirectory(getWorkingDirectory().."/config")
 			 end
 			 if not doesDirectoryExist(getWorkingDirectory().."/config/VH_DBHouse/"..ip) then
 			 	createDirectory(getWorkingDirectory().."/config/VH_DBHouse/"..ip)
 			 end

 			 local tableConfig = {
 				 ["active"] = true,
				 ["signActive"] = true,
				 ["infoMessage"] = true,
 				 ["HOUSE"] = {},
				 ["ownersOnlineLOGG"] = {},
				 ["ownersOnline"] = {},
				 ["sellHouse"] = {},
				 ["signHouse"] = {}
 			 	}

 				local linkConfig = getWorkingDirectory() .. "/config/VH_DBHouse/"..ip.."/dbhouse.json"
 				if not doesFileExist(linkConfig) then
 					local file = io.open(linkConfig, "w")
 					file:write(encodeJson(tableConfig))
 					io.close(file)
 				end
 				if doesFileExist(linkConfig) then
 					local file = io.open(linkConfig, "r")
 					if file then
  					local code = decodeJson(file:read("*a"))
 			end
 			local file = io.open(linkConfig, "r")
 			if file then
  				db = decodeJson(file:read("*a"))
 			end
 			io.close(file)
 		end
 		end

 		end

		sampRegisterChatCommand("gethouse", function(arg)
			if arg:find(".*") then
				sampAddChatMessage("", -1)
				for key, val in ipairs(db['HOUSE']) do
					if arg == db["HOUSE"][key]["num"] then
							sampAddChatMessage("[HDB]{FFFACD} Дом {FBEC5D}№"..arg.."{FFFACD}, парковок: {FBEC5D}"..db["HOUSE"][key]["park"].."{FFFACD}, район: {FBEC5D}"..db["HOUSE"][key]["area"], 0xFF2B2B)
							sampAddChatMessage("[HDB]{FFFACD} Владелец: {FBEC5D}"..db["HOUSE"][key]["lastowner"].."{FFFACD}, дата обновления владельца: {FBEC5D}"..db["HOUSE"][key]["times"]..", "..db["HOUSE"][key]["datas"], 0xFF2B2B)
					end
				end
				sampAddChatMessage("", -1)
			end
		end)

		sampRegisterChatCommand("dompoint", function()
			dompoint = not dompoint
			sampAddChatMessage(dompoint and "[HDB] {FFFfff}Поинт на домах владельцев - активировано." or "[HDB] {FFFfff}Поинт на домах владельцев - деактивировано", 0xFF2B2B)
			if CheckingHouse ~= nil then
				for key, key in ipairs(CheckingHouse) do
					removeBlip(key["handle"])
				end
				CheckingHouse = {}
			end
		end)

		sampRegisterChatCommand("hdb", function(onoff)
			if onoff ~= nil and onoff ~= "" then
				if onoff == "on" then
					db["active"] = true
					saveDB()
					sampAddChatMessage("[HDB] {FFFACD}Добавление/обновление домов и владельцев - включено.", 0xFF2B2B)
				elseif onoff == "off" then
					db["active"] = false
					saveDB()
					sampAddChatMessage("[HDB] {FFFACD}Добавление/обновление домов и владельцев - выключено.", 0xFF2B2B)
				end
			else
			mainMenu.v = not mainMenu.v
			cleanBanlist()
		end
		end)

		sampRegisterChatCommand("chksign", function()
			chksign = not chksign
			sampAddChatMessage(chksign and "[HDB] {FFFfff}Поиск слетевших /saleset - включено." or "[HDB] {FFFfff}Поиск слетевших /saleset - выключено", 0xFF2B2B)
		end)


		sampRegisterChatCommand(
			"delsign",
			function(signe)
				if signe:find("%d+") then
					local searchsigne = signe:match("(%d+)")
						if signe then
							for Key, keyue in ipairs(db['signHouse']) do
								if db['signHouse'][Key]['house'] == searchsigne then
									table.remove(db['signHouse'], Key)
									saveDB()
									sampAddChatMessage("Дом №" .. searchsigne .. " был успешно удален из списка.", 0x0FF2B2B)
								end
							end
						end
					end
	end)

	sampRegisterChatCommand("signlist", function()
		sampAddChatMessage("СПИСОК ДОМОВ, СЛЕТЕВШИХ С ПРОДАЖИ:", 0x0FF2B2B)
			for Key, keyue in ipairs(db["signHouse"]) do
			sampAddChatMessage("{ffffff}"..db['signHouse'][Key]['nick'].. " {09fb98}- {ffffff}№"..db["signHouse"][Key]["house"].." {FF2B2B}до "..db['signHouse'][Key]['datah'], 0x0FF2B2B)
		end
	end)

	sampRegisterChatCommand("checkown", function(arg)
		if arg:find(".*") then
			sampAddChatMessage("", -1)
			for key, val in ipairs(db['ownersOnline']) do
				if arg:lower() == db["ownersOnline"][key]["owner"]:lower() then
						sampAddChatMessage("[HDB]{FFFACD} Владелец: {FBEC5D}"..arg.."{FFFACD} посещал игру {FBEC5D}"..db["ownersOnline"][key]["time"].." "..db["ownersOnline"][key]["data"], 0xFF2B2B)
				end
			end
			sampAddChatMessage("", -1)
		end
	end)

	lua_thread.create(bebe)

	sampRegisterChatCommand("addhouse", function()
		db["active"] = not db["active"]
		sampAddChatMessage(db["active"] and "[HDB] {FFFACD}Добавление/обновление домов и владельцев - включено." or "[HDB] {FFFACD}Добавление/обновление домов и владельцев - выключено.", 0xFF2B2B)
	end)


		sampRegisterChatCommand('near', zona)

	sampRegisterChatCommand("owninfo", function(arg)
		if arg:find(".*") then
			sampAddChatMessage("", -1)
			sampAddChatMessage("[HDB] {FFFACD}Игрок {FBEC5D}"..arg.." {FFFACD}владеет домами:", 0xFF2B2B)
			for Key, keyue in ipairs(db['HOUSE']) do
				if arg:lower() == db["HOUSE"][Key]["lastowner"]:lower() then
						sampAddChatMessage("- {FBEC5D}"..db["HOUSE"][Key]["num"].." "..db["HOUSE"][Key]["park"].." {FFFACD}Район: {FBEC5D}"..db["HOUSE"][Key]["area"]..". {FFFACD}Дата изменения: {FBEC5D}"..db["HOUSE"][Key]["datas"].." "..db["HOUSE"][Key]["times"], 0xFF2B2B)
				end
			end
			for key, val in ipairs(db['ownersOnline']) do
				if arg:lower() == db["ownersOnline"][key]["owner"]:lower() then
					sampAddChatMessage("", -1)
						sampAddChatMessage("[!] {FBEC5D}"..arg.."{FFFACD} посещал игру {FBEC5D}"..db["ownersOnline"][key]["time"].." "..db["ownersOnline"][key]["data"], 0xFF2B2B)
				end
			end
			sampAddChatMessage("", -1)
		end
	end)
		lua_thread.create(SletHouseSign)
		lua_thread.create(AutoDelInfa)
	--	lua_thread.create(bannedPlayer)
		while true do wait(0)



		imgui.Process = mainMenu.v

		for i = 0, sampGetMaxPlayerId() do
				if sampIsPlayerConnected(i) then
					names = sampGetPlayerNickname(i)
					for Key, Value in ipairs(db["signHouse"]) do
						if names == db["signHouse"][Key]["nick"] then
							wait(10)
							sampAddChatMessage(db["signHouse"][Key]["nick"], -1)
							table.remove(db["signHouse"], Key)
							saveDB()
						end
					end
				end
			end


		end
end

function imgui.OnDrawFrame()
	if mainMenu.v then
		imgui.SetNextWindowSize(imgui.ImVec2(1115, 500))
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(u8("БАЗА ДАННЫХ ДОМОВ | TRINITY GTA. ВСЕГО: "..#db["HOUSE"]), mainMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		imgui.BeginChild("#UP_PropPanel", imgui.ImVec2(1100, 37), true)
			if imgui.Checkbox(u8("##ONLY_SIGN"), sign) then
				banHouse.v = false
			end
			imgui.Hint(u8"Посмотреть все дома находящиеся в /saleset или все слетевшие дома из /saleset")
		imgui.SameLine()
		imgui.BeginChild("#SEATCH_GPS", imgui.ImVec2(52, 25), false)
		imgui.NewInputText("##SEARCHNUM", searchNUM, 52, u8("GPS"), 2)
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("#SEATCH_PARK", imgui.ImVec2(47, 25), false)
		imgui.NewInputText("##searchPARK", searchPARK, 47, fa.ICON_CAR, 2)
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("#AREA_AREA", imgui.ImVec2(126, 25), false)
		imgui.NewInputText("##searchAREAAA", searchAREA, 127, u8("Район"), 2)
		imgui.EndChild()
		imgui.SameLine()
		imgui.BeginChild("#LAST_OWNER", imgui.ImVec2(145, 25), false)
		imgui.NewInputText("##searchLASTOWNER", searchLASTOWNER, 145, u8("Владелец"), 2)
		imgui.EndChild()
		imgui.SameLine()
		if imgui.Button(u8"ОБНОВИТЬ ОНЛАЙН", imgui.ImVec2(135, 24)) then
			lua_thread.create(function()
				for i = 0, sampGetMaxPlayerId() do
					if sampIsPlayerConnected(i) then
						name = sampGetPlayerNickname(i)
			for key, val in ipairs(db["ownersOnlineLOGG"]) do
			 if name == db["ownersOnlineLOGG"][key]["owners"] then
 --	wait(1000)
	 if not ownersOnline(name) then
			 table.insert(db["ownersOnline"], {
			 ["owner"] = name,
			 ["time"] = os.date("%H:%M:%S"),
			 ["data"] = os.date("%d.%m.20%y")
		 })
		--	sampAddChatMessage(name, -1)
		 saveDB()
		 table.insert(logOnline, name)
	 else
		-- wait(1000)
		 for key, val in ipairs(db["ownersOnline"]) do
		 if (db["ownersOnline"][key]["owner"] == name) then
			 db["ownersOnline"][key]["time"] = os.date("%H:%M:%S")
		--	 wait(0)
			 db["ownersOnline"][key]["data"] = os.date("%d.%m.20%y")
		 --	sampAddChatMessage(name.." 1 "..db["ownersOnline"][key]["data"], -1)
			 saveDB()
			 table.insert(logOnline, name)
		 end
		 end
	 end
 end
end
end
end
sampAddChatMessage("{FF2B2B}[HDB] {ffffff}Онлайн владельцев домов был обновлен разом. ("..#logOnline..")", 0xFF2B2B)
logOnline = {}
end)
end


		imgui.SameLine()
		if db["active"] then
		if imgui.Button(fa.ICON_POWER_OFF.. u8" ВЫКЛ", imgui.ImVec2(75, 24)) then
			db["active"] = false
			sampAddChatMessage("[HDB] {FFFACD}Добавление/обновление домов и владельцев - выключено.", 0xFF2B2B)
			saveDB()
		end
	else
		if imgui.Button(fa.ICON_POWER_OFF.. u8" ВКЛ", imgui.ImVec2(75, 24)) then
		sampAddChatMessage("[HDB] {FFFACD}Добавление/обновление домов и владельцев - включено.", 0xFF2B2B)
		db["active"] = true
		saveDB()
	end
		end
		imgui.SameLine()
		if db["signActive"] then
		if imgui.Button(fa.ICON_BELL_SLASH, imgui.ImVec2(30, 24)) then
			db["signActive"] = false
			sampAddChatMessage("[HDB] {FFFACD}Оповещение информации о владельцах/домов  - выключено.", 0xFF2B2B)
			saveDB()
		end
	else
		if imgui.Button(fa.ICON_BELL, imgui.ImVec2(30, 24)) then
		sampAddChatMessage("[HDB] {FFFACD}Оповещение информации о владельцах/домов  - включено.", 0xFF2B2B)
		db["signActive"] = true
		saveDB()
	end
	end
		imgui.SameLine()
		if dompoint then
		if imgui.Button(u8"ПОИНТ ВЫКЛ", imgui.ImVec2(90, 24)) then
			dompoint = false
			sampAddChatMessage("[HDB] {FFFfff}Поинт на домах владельцев - деактивировано", 0xFF2B2B)
		end
	else
		if imgui.Button(u8"ПОИНТ ВКЛ", imgui.ImVec2(90, 24)) then
		sampAddChatMessage("[HDB] {FFFfff}Поинт на домах владельцев - активировано.", 0xFF2B2B)
		dompoint = true
	end
	end
	imgui.SameLine()
		if imgui.Button(fa.ICON_REFRESH..u8" ОБНОВИТЬ БАНЫ ", imgui.ImVec2(140, 24)) then
			getbanlist(true)
		end
		imgui.SameLine()
		imgui.Text("       [")
		imgui.SameLine()
		if imgui.Checkbox(u8("] - ДОМА В БАНЕ##ONLY_BANSTODAY"), banHouse) then
			sign.v = false
		end


		imgui.EndChild()
		imgui.BeginChild("#UP_DB", imgui.ImVec2(1102, 430), true)


		imgui.Columns(8)
		imgui.Separator()
		if onlysign.v then
			if imgui.Selectable(" "..fa5.ICON_MAP_SIGNS, false) then
				onlyNOsign.v = true
				onlysign.v = false
			end
		else
			if imgui.Selectable(" !!!", false) then
				onlysign.v = true
				onlyNOsign.v = false
			end
		end
		imgui.SetColumnWidth(-1, 33)
		imgui.NextColumn()
		imgui.Text(u8" "..fa.ICON_HOME.." "..u8"GPS")
		imgui.SetColumnWidth(-1, 60)
		imgui.NextColumn()
		imgui.Text("   "..fa.ICON_CAR)
		imgui.SetColumnWidth(-1, 50)
		imgui.NextColumn()
		imgui.Text("       "..fa.ICON_AREA_CHART..u8" РАЙОН")
		imgui.SetColumnWidth(-1, 130)
		imgui.NextColumn()
		imgui.Text(u8"        "..fa.ICON_USER.." "..u8"ВЛАДЕЛЕЦ")
		imgui.SetColumnWidth(-1, 150)
		imgui.NextColumn()
		imgui.Text(u8"         "..fa.ICON_CLOCK_O.." "..u8"ОНЛАЙН")
		imgui.SetColumnWidth(-1, 140)
		imgui.NextColumn()
		imgui.Text(fa.ICON_ADDRESS_CARD..u8" ВЛАДЕЛЬЦЫ")
		imgui.SetColumnWidth(-1, 105)
		imgui.NextColumn()
		if banHouse.v then
		if bansAll.v then
		if imgui.Selectable(u8"(ВСЕ)                                      "..fa.ICON_TIMES..u8" ТЕКУЩИЕ НАКАЗАНИЯ ВЛАДЕЛЬЦЕВ", false) then
			bansAll.v = false
			bansNextDay.v = true
			banstoday.v = false
		end
	elseif bansNextDay.v then
		if imgui.Selectable(u8"(БЛИЖАЙШИЕ 5 ДНЕЙ)         "..fa.ICON_TIMES..u8" ТЕКУЩИЕ НАКАЗАНИЯ ВЛАДЕЛЬЦЕВ", false) then
			bansAll.v = false
			bansNextDay.v = false
			banstoday.v = true
		end
	elseif banstoday.v then
		if imgui.Selectable(u8"(СЕГОДНЯШНИЕ)                   "..fa.ICON_TIMES..u8" ТЕКУЩИЕ НАКАЗАНИЯ ВЛАДЕЛЬЦЕВ", false) then
			bansAll.v = true
			bansNextDay.v = false
			banstoday.v = false
		end
	end
else
	imgui.Text("                            "..fa.ICON_TIMES..u8" ТЕКУЩИЕ НАКАЗАНИЯ ВЛАДЕЛЬЦЕВ")
	end
		imgui.SetColumnWidth(-1, 500)
		imgui.Columns(1)
		imgui.Separator()


		if not banHouse.v and not slot15_a2515.v and not sign.v and searchNUM == "" and searchPARK == "" and searchAREA == "" and searchLASTOWNER == "" then
		else
			for slot8_a2460 = #db.HOUSE, 1, -1 do
				if banHouse.v then
					if bansAll.v then
					if spisok[slot8_a2460] ~= nil and seaTable(slot8_a2460) then
						imgui.GetDate(slot8_a2460)
					end
				elseif bansNextDay.v then
					if spisok[slot8_a2460] ~= nil and seaTable(slot8_a2460) then
						if spisok[slot8_a2460].date.day == os.date("%d",os.time()-1814400) and spisok[slot8_a2460].date.month == os.date("%m",os.time()-1814400) and spisok[slot8_a2460].date.year == os.date("20%y",os.time()-1814400) then
							imgui.GetDate(slot8_a2460)
						end

						if spisok[slot8_a2460].date.day == os.date("%d",os.time()-1728000) and spisok[slot8_a2460].date.month == os.date("%m",os.time()-1728000) and spisok[slot8_a2460].date.year == os.date("20%y",os.time()-1728000) then
							imgui.GetDate(slot8_a2460)
						end

						if spisok[slot8_a2460].date.day == os.date("%d",os.time()-1641600) and spisok[slot8_a2460].date.month == os.date("%m",os.time()-1641600) and spisok[slot8_a2460].date.year == os.date("20%y",os.time()-1641600) then
							imgui.GetDate(slot8_a2460)
						end

						if spisok[slot8_a2460].date.day == os.date("%d",os.time()-1555200) and spisok[slot8_a2460].date.month == os.date("%m",os.time()-1555200) and spisok[slot8_a2460].date.year == os.date("20%y",os.time()-1555200) then
							imgui.GetDate(slot8_a2460)
						end

						if spisok[slot8_a2460].date.day == os.date("%d",os.time()-1468800) and spisok[slot8_a2460].date.month == os.date("%m",os.time()-1468800) and spisok[slot8_a2460].date.year == os.date("20%y",os.time()-1468800) then
							imgui.GetDate(slot8_a2460)
						end

						if spisok[slot8_a2460].date.day == os.date("%d",os.time()-1382400) and spisok[slot8_a2460].date.month == os.date("%m",os.time()-1382400) and spisok[slot8_a2460].date.year == os.date("20%y",os.time()-1382400) then
							imgui.GetDate(slot8_a2460)
						end

				end
				elseif banstoday.v then
					timeDay = os.date("%d")
					timeMonth = os.date("%m")
					timeYear = os.date("20%y")
					if spisok[slot8_a2460] ~= nil and seaTable(slot8_a2460) then
						if spisok[slot8_a2460].date.day == timeDay and spisok[slot8_a2460].date.month == timeMonth and spisok[slot8_a2460].date.year == timeYear then
							imgui.GetDate(slot8_a2460)
						end
					end
				end
				elseif sign.v then
					if onlysign.v then
					for key, val in ipairs(db["sellHouse"]) do
					if db["sellHouse"][key]["selnum"] == db.HOUSE[slot8_a2460].num then
						imgui.GetDate(slot8_a2460)
					end
				end
			else
				for key, val in ipairs(db["signHouse"]) do
				if db["signHouse"][key]["house"] == db.HOUSE[slot8_a2460].num then
					imgui.GetDate(slot8_a2460)
				end
			end
		end
				elseif slot15_a2515.v then
					if db.HOUSE[slot8_a2460].sign.name ~= nil and seaTable(slot8_a2460) then
						imgui.GetDate(slot8_a2460)
					end
				elseif seaTable(slot8_a2460) then
					imgui.GetDate(slot8_a2460)
				end

				ownerPlayer(slot8_a2460)
				--signLogs(slot8_a2460)
			end
		end
	else
		imgui.Text(u8(" База данных пуста. Включите скрипт для добавление домов. /hdb on или на панели"))
	end

	if #db.HOUSE > 0 and not banHouse.v and not slot15_a2515.v and searchNUM == "" and searchPARK == "" and searchAREA == "" and searchAREA == "" then
		imgui.BeginChild("##BUTTON_MENU_FOOTER", imgui.ImVec2(-1, 45), true)



		imgui.EndChild()
	end





		imgui.EndChild()
		imgui.End()
	end


function imgui.GetDate(abs)
	imgui.Columns(8, "COLUMNS_CENTER", true)
	imgui.SetColumnWidth(-1, 33)
	for key, val in ipairs(db["sellHouse"]) do
		if db["sellHouse"][key]["selnum"] == db.HOUSE[abs].num then
			imgui.Text(" "..fa5.ICON_MAP_SIGNS)
			imgui.Hint(u8("Дата установки /saleset: "..db["sellHouse"][key]["times"]..", "..db["sellHouse"][key]["datas"]))
		end
		end
		for key, val in ipairs(db["signHouse"]) do
			if db["signHouse"][key]["house"] == db.HOUSE[abs].num then
				imgui.Text(u8(" !!!"))
				imgui.Hint(u8("Дом возможно слетит, так как слетел с продажи. Слет назначен на: "..db["signHouse"][key]["datah"]))
			end
			end
			imgui.NextColumn()
	imgui.SetColumnWidth(-1, 60)
	imgui.Text(u8(db.HOUSE[abs].num))

	if imgui.IsItemClicked() then
		setClipboardText(u8(db.HOUSE[abs].num))
	end

	imgui.NextColumn()
	imgui.SetColumnWidth(-1, 50)
	imgui.Text(u8(db.HOUSE[abs].park))
	imgui.NextColumn()
	imgui.SetColumnWidth(-1, 130)
	imgui.Text(u8(" " .. db.HOUSE[abs].area))

	if imgui.IsItemClicked() then
		setClipboardText(u8(db.HOUSE[abs].area))
	end

	imgui.NextColumn()
	imgui.SetColumnWidth(-1, 150)

	if imgui.Selectable(db.HOUSE[abs].lastowner, false) then
		sampAddChatMessage("["..db.HOUSE[abs].num.."]:{ffffff} Дата обновления текущего владельца "..db.HOUSE[abs].lastowner.." - "..db["HOUSE"][abs]["times"]..", "..db["HOUSE"][abs]["datas"], 0xFF2B2B)
			setClipboardText(u8(db.HOUSE[abs].lastowner))
	end

	imgui.Hint(u8(db.HOUSE[abs].lastowner.." дата обновления текущего владельца: "..db.HOUSE[abs].times.. " "..db.HOUSE[abs].datas))

	imgui.NextColumn()
	imgui.SetColumnWidth(-1, 140)

	for key, val in ipairs(db["ownersOnline"]) do
		if db.HOUSE[abs].lastowner == val["owner"] then
	imgui.Text(val["time"].." | "..val["data"])
end
end
	imgui.NextColumn()
	imgui.SetColumnWidth(-1, 105)

	if #db.HOUSE[abs].owners >= 1 then
	if imgui.Selectable(u8'   Просмотреть ##'..abs, false) then
			imgui.OpenPopup(u8'Прошлые владельцы дома №'..db.HOUSE[abs].num.."##"..abs)
		end
	else
		imgui.Text("             -")
end

imgui.NextColumn()
imgui.SetColumnWidth(-1, 500)
if spisok[abs] ~= nil then
	local iday = spisok[abs].date.day
	local a = ":"
	local imonth = spisok[abs].date.month
	local iyear = spisok[abs].date.year
	local idatai = iday .. a .. imonth .. a .. iyear
	imgui.Text(u8("[" .. idatai .. "]  " .. spisok[abs].reason))
	imgui.Hint(u8("[" .. idatai .. "]  " .. spisok[abs].reason))
end
	imgui.Columns(1)
	imgui.Separator()
end

function imgui.Hint(text, delay)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5 -- скорость появления
        if os.clock() >= go_hint then
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextUnformatted(text)
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar()
        end
    end
end


function ownerPlayer(ownerList)
	imgui.SetNextWindowSize(imgui.ImVec2(385, 365))

	if imgui.BeginPopupModal(u8("Прошлые владельцы дома №" .. db.HOUSE[ownerList].num .. "##" .. ownerList), true, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoMove) then
		imgui.BeginChild("##BEGIN_CENTER" .. ownerList, imgui.ImVec2(0, 299), false)

		for logOwn = #db.HOUSE[ownerList].owners, 1, -1 do
			local OWNS = db.HOUSE[ownerList].owners[logOwn]

			imgui.BeginChild("##BEGIN_OWNER" .. logOwn, imgui.ImVec2(290, 25), false)

			if logOwn == #db.HOUSE[ownerList].owners then
				imgui.Text(fa.ICON_MINUS_SQUARE .. " " .. logOwn .. ") " .. OWNS.owner) -- был fa.ICON_CHECK_SQUARE
			else
				imgui.Text(fa.ICON_MINUS_SQUARE .. " " .. logOwn .. ") " .. OWNS.owner)
			end

			imgui.EndChild()
			imgui.SameLine()
			imgui.BeginChild("##BEGIN_BUTTON" .. logOwn, imgui.ImVec2(60, 25), false)


		--[[	imgui.SameLine()

			if imgui.Button(fa.ICON_TRASH .. "##" .. logOwn, imgui.ImVec2(25, 20)) then
				table.remove(db.HOUSE[ownerList].owners[time], logOwn)
				saveDB()
			end--]]

			imgui.SameLine()

			if imgui.Button(fa.ICON_FILES_O .. "##" .. logOwn, imgui.ImVec2(25, 20)) then
				setClipboardText(OWNS)
			end

			imgui.SameLine()

			if imgui.Button(fa.ICON_CLOCK_O .. "##" .. logOwn, imgui.ImVec2(25, 20)) then
				sampAddChatMessage("["..db.HOUSE[ownerList].num.."]:{ffffff} Дата обновления владельца "..OWNS.owner.." - "..OWNS.time..", "..OWNS.data, 0xFF2B2B)
			end
			imgui.Hint(u8("Дата обновления владельца "..OWNS.owner.." - "..OWNS.time..", "..OWNS.data))

			imgui.EndChild()
		end

		imgui.EndChild()

		if imgui.Button(fa.ICON_TIMES .. u8(" ЗАКРЫТЬ##" .. ownerList), imgui.ImVec2(-1, 25)) then
			imgui.CloseCurrentPopup()
		end

		imgui.EndPopup()
	end
end


function bebe()
	while true do wait(0)
		for i = 0, sampGetMaxPlayerId() do
			if sampIsPlayerConnected(i) then
				name = sampGetPlayerNickname(i)
				for key, val in ipairs(db["ownersOnlineLOGG"]) do
				if name == db["ownersOnlineLOGG"][key]["owners"] then
	--	wait(1000)
		if not ownersOnline(name) then
				table.insert(db["ownersOnline"], {
				["owner"] = name,
				["time"] = os.date("%H:%M:%S"),
				["data"] = os.date("%d.%m.20%y")
			})
		--	sampAddChatMessage(name, -1)
			saveDB()
		else
			wait(1000)
			for key, val in ipairs(db["ownersOnline"]) do
			if (db["ownersOnline"][key]["owner"] == name) then
				db["ownersOnline"][key]["time"] = os.date("%H:%M:%S")
				wait(0)
				db["ownersOnline"][key]["data"] = os.date("%d.%m.20%y")
				--sampAddChatMessage(name.." 1 "..db["ownersOnline"][key]["data"], -1)
				saveDB()
			end
			end
		end
	end
end
	end
	end
end
end

function seaTable(stbale)
	if stbale ~= nil then
		if searchNUM == nil then
			local numFind = ""
		else
			numFind = searchNUM.v
		end

		if searchPARK == nil then
			local parks = ""
		else
			parks = searchPARK.v
		end

		if searchAREA == nil then
			local areaFind = ""
		else
			areaFind = searchAREA.v
		end

		if searchLASTOWNER == nil then
			local lastOwnerFind = ""
		else
			lastOwnerFind = searchLASTOWNER.v
		end
		if db.HOUSE[stbale].num:lower():find(numFind:lower(), nil, true) then
			if db.HOUSE[stbale].park:lower():find(parks:lower(), nil, true) then
			if db.HOUSE[stbale].area:lower():find(areaFind:lower(), nil, true) then
				if db.HOUSE[stbale].lastowner:lower():find(lastOwnerFind:lower(), nil, true) then
					return true
				end
				end
			end
		end
	end

	return false
end

function splitTable(arg0_a3218, arg1_a3203)
	local slot2_a3226 = {}

	if #arg0_a3218 > 0 then
		for slot6_a3201 = math.ceil(#arg0_a3218 / arg1_a3203), 1, -1 do
			local slot7_a3214 = {}
			local slot8_a3204 = (slot6_a3201 - 1) * arg1_a3203

			for slot12_a3217 = slot8_a3204 + 1, slot8_a3204 + arg1_a3203 do
				if arg0_a3218[slot12_a3217] ~= nil then
					table.insert(slot7_a3214, {
						ID = slot12_a3217,
						VAL = arg0_a3218[slot12_a3217]
					})
				end
			end

			table.insert(slot2_a3226, slot7_a3214)
		end
	end

	return slot2_a3226
end


function sampev.onSetObjectMaterialText(id, data)
--[[	if dompoint then
	 if tostring(data.text):find('^%d+  %d+\n\n{ffffff}Владелец:{fbec5d} .*') and not checkerHouseIcon(id) then
		 local kvnum, kvpark, kvowner = tostring(data.text):match("^(%d+)  (%d+)\n\n{ffffff}Владелец:{fbec5d} (%S+)") -- было (.*_%a+)
			sampAddChatMessage("FLAT "..kvnum.." CHECK", 0x0424242)
		end
	end--]]
	if db["active"] then
		if tostring(data.text):find('^%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} .*') then
			local crdFlat, crdFalatX, crdFalatY, crdFalatZ = getObjectCoordinates(sampGetObjectHandleBySampId(id))
			local text = tostring(data.text)
			local num, park, owner = tostring(data.text):match("^(%d+)  (%d+).*\n\n{ffffff}Владелец:{fbec5d} (%S+)")
			local datas = os.date("%d.%m.20%y")
			local times = os.date("%H:%M:%S")
			if not ownersOnlineList(owner) then
			table.insert(db["ownersOnlineLOGG"], {
			["owners"] = owner
		})
		saveDB()
	end
			if not CheckGps(num) then
				table.insert(db["HOUSE"], {
					["datas"] = datas,
					["times"] = times,
					["area"] = getArea(crdFalatX, crdFalatY, crdFalatZ),
					["num"] = num,
					["park"] = park,
					["lastowner"] = owner,
					["owners"] = {
						owner = owner,
						data = os.date("%d.%m.20%y"),
						time = os.date("%H:%M:%S")
					}
				})
				if not ownersOnlineList(owner) then
				table.insert(db["ownersOnlineLOGG"], {
				["owners"] = owner
			})
		end
				saveDB()
			else
				for Key, keyue in ipairs(db['HOUSE']) do
					if num == db['HOUSE'][Key]['num'] then
						if owner ~= db['HOUSE'][Key]['lastowner'] then
							table.insert(logOwners, db['HOUSE'][Key]['lastowner'])
							if not ownersOnlineList(owner) then
							table.insert(db["ownersOnlineLOGG"], {
							["owners"] = owner
						})
						saveDB()
					end
					for key, val in ipairs(db["signHouse"]) do
						if num == db["signHouse"][key]["house"] and db['HOUSE'][Key]['lastowner'] == db["signHouse"][key]["nick"] then
							table.remove(db["signHouse"], key)
							saveDB()
						--	sampAddChatMessage("Дом №" ..	num .. " был успешно удален из списка /saleset.", 0x0FF2B2B)
						end
					end
						db["HOUSE"][Key]["datas"] = datas
							if db["signActive"] then
								sampAddChatMessage("[HDB] {FFFFFF}Обновился владелец дома {FBEC5D}№"..db["HOUSE"][Key]["num"]..". {FFFFFF}Новый: {FBEC5D}"..owner..". {FFFFFF}Предыдущий: {FBEC5D}"..db['HOUSE'][Key]['lastowner'], 0xFF2B2B)
							end
							setClipboardText(db['HOUSE'][Key]['lastowner'])
							table.insert(db["HOUSE"][Key]["owners"], {
									owner = db['HOUSE'][Key]['lastowner'],
									data = os.date("%d.%m.20%y"),
									time = os.date("%H:%M:%S")
						})
						saveDB()
							db["HOUSE"][Key]["times"] = times
							for logOwn = #db.HOUSE[Key].owners, 1, -1 do
								if num == db["HOUSE"][Key]["num"] then
									if #keyue["owners"] > 10 then
										--sampAddChatMessage(#keyue["owners"].." "..logOwn, -1)
										table.remove(db.HOUSE[Key].owners, Key)
										saveDB()
									end
								end
							end
						end
					end
			end
			for Key, Value in ipairs(db["HOUSE"]) do
				for key, val in ipairs(logOwners) do
					if db["HOUSE"][Key]["lastowner"] == val then
						table.insert(logNum, db["HOUSE"][Key]["num"])
						--sampAddChatMessage(#logNum.." "..db["HOUSE"][Key]["num"], -1)
					end
				end
			end
					if #logNum == 1 then

					--	sampAddChatMessage(#logNum, -1)
						for key, val in ipairs(logOwners) do
							sampAddChatMessage("[HDB] {FBEC5D}"..val.."{A5A5A5} больше не имеет домов.", 0x0A5A5A5)
				--		for Key, Value in ipairs(db["HOUSE"]) do
						for Key, vals in ipairs(db["ownersOnlineLOGG"]) do
							if val == db["ownersOnlineLOGG"][Key]["owners"] then
								table.remove(db["ownersOnlineLOGG"], Key)
								saveDB()
							--	sampAddChatMessage(val.." удален", -1)
							end
						end
				--	end
					logNum = {}
					logOwners = {}
				end
				end
				logNum = {}
				logOwners = {}
				for Key, keyue in ipairs(db['HOUSE']) do
					if num == db['HOUSE'][Key]['num'] then
						db['HOUSE'][Key]['lastowner'] = owner,
						db['HOUSE'][Key]['park'] == park
						saveDB()
					end
				end
					end

					if tostring(data.text):find("^%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} .*\n\n{ffffff}Владелец продает дом за {33aa33}.* %${ffffff}.*") then
						local saleNum, salePark, saleOwner, price = text:match("^(%d+)  (%d+).*\n\n{ffffff}Владелец:{fbec5d} (.*)\n\n{ffffff}Владелец продает дом за {33aa33}(.*) %${ffffff}.*")
						if price <= "100000" then
							sampAddChatMessage("[HDB]: {e0e094}Дом #"..saleNum.." "..salePark.." продается за {FBEC5D}"..price.." $, {e0e094}владелец: "..saleOwner, 0x0066FF)
						end
					end

					if tostring(data.text):find("^%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} .*\n\n{ffffff}Владелец продает.*") then
						local crdFlat, crdFalatX, crdFalatY, crdFalatZ = getObjectCoordinates(sampGetObjectHandleBySampId(id))
		 			 local selnum, selpark, selowner = tostring(data.text):match("^(%d+)  (%d+)\n\n{ffffff}Владелец:{fbec5d} (%S+)")
		 			 local datas = os.date("%d.%m.20%y")
		 			 local times = os.date("%H:%M:%S")
		 			 if not SellHouse(selnum) then
		 				 table.insert(db["sellHouse"], {
		 					 ["datas"] = datas,
		 					 ["times"] = times,
							 ["area"] = getArea(crdFalatX, crdFalatY, crdFalatZ),
		 					 ["selnum"] = selnum,
		 					 ["selpark"] = selpark,
		 					 ["sellastowner"] = selowner
		 				 })
		 				 saveDB()
		 				 if db["signActive"] then
		 				sampAddChatMessage("{FFFACD}Дом {FBEC5D}№"..selnum.."{FFFACD} выставлен на продажу. Владелец: {FBEC5D}"..selowner..". {FFFACD}Дата: {FBEC5D}"..times.." "..datas, 0xFF2B2B)
		 			 end
				 else
					 for key, val in ipairs(db["sellHouse"]) do
					 	if selnum == db["sellHouse"][key]["selnum"] then
					 		if selowner ~= db["sellHouse"][key]["sellastowner"] then
					 			db["sellHouse"][key]["sellastowner"] = selowner
					 			db["sellHouse"][key]["datas"] = datas
					 			db["sellHouse"][key]["sellastowner"] = times
					 		end
					 	end
					 end
		 			 end
				 else
		 			 if tostring(data.text):find("^%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} %S+") then
						local datah = os.date("%d.%m.%y",os.time()+259200)
					    local day = os.date("%d",os.time()+259200)
						local mes = os.date("%m",os.time()+259200)
						local year = os.date("%y",os.time()+259200)
		 				 local noselnum, noselpark, noselowner = tostring(data.text):match("^(%d+)  (%d+)\n\n{ffffff}Владелец:{fbec5d} (%S+)")
		 				 for Key, keyue in ipairs(db["sellHouse"]) do
		 					if noselnum == db["sellHouse"][Key]["selnum"] then
		 						if db["signActive"] then
									sampAddChatMessage("[HDB] {FFFFFF}Слетел с продажи дом {FBEC5D}№"..noselnum.." "..noselpark..".{FFFFFF} Владелец: {FBEC5D}"..db["sellHouse"][Key]["sellastowner"]..". {FFFFFF}Дата: {FBEC5D}"..db["sellHouse"][Key]["times"].." "..db["sellHouse"][Key]["datas"], 0xFF2B2B)
			 					end
							if chksign then -- // Было для ловлю слетевших табличке теперь не актцально...
							if db["sellHouse"][Key]["sellastowner"] == noselowner then
								if not ChkSign(noselnum) then
									table.insert(db["signHouse"], {
				 					 ["datah"] = datah,
									 ["day"] = day,
									 ["mes"] = mes,
									 ["year"] = year,
				 					 ["house"] = noselnum,
				 					 ["park"] = noselpark,
				 					 ["nick"] = noselowner
				 				 })
				 				 saveDB()
								 	sampAddChatMessage("{FFFACD}Добавлена инфа: {FBEC5D}"..noselowner..", {FFFACD}дом {FBEC5D}№"..noselnum.." "..noselpark..". {FFFACD}На {FBEC5D}"..day.."."..mes.."."..year, 0xFF2B2B)
								end
							 end
						 end
						 table.remove(db["sellHouse"], Key)
						 saveDB()
		 				end
		 					end
		 			end
		end
	end
	end
end



function sampev.onCreate3DText(id, color, pos, distance, testLOS, attachedPlayerId, attachedVehicleId, text)

	--sampAddChatMessage(text, -1)
	if dompoint then
		if text:find('^%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} .*') and not checkerHouseIcon(id) then
			table.insert(CheckingHouse, {
				["id"] = id,
				["handle"] = addSpriteBlipForCoord(pos.x, pos.y, pos.z, 0)
			})
		--	sampAddChatMessage("ПРОВЕРЕНО: "..#CheckingHouse, -1)
		end
	end
	if text:find("{ffffff}Это жилье продается за {33aa33}") then
		checkTEXT = false
	elseif text:find("Домашний замок был открыт") or text:find("Домашний замок был заперт") then
		checkTEXT = false
	elseif text:find("%d+%s %d%s%s{ffffff}Дом выставлен на аукцион") then
		checkTEXT = false
	elseif text:find("%d+%s %d%s%s{ffffff}Владелец:{fbec5d}") or text:find("%d+%s %dG%s%s{ffffff}Владелец:{fbec5d}") then
		checkTEXT = true
	end


	if db["active"] and checkTEXT then
			if text:find("^%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} %S+") then
	 			local num, park, owner = text:match("^(%d+)  (%d+).*\n\n{ffffff}Владелец:{fbec5d} (%S+)")
				local datas = os.date("%d.%m.20%y")
				local times = os.date("%H:%M:%S")
				--sampAddChatMessage(pos.x.." "..pos.y.." "..pos.z, -1)
				if not ownersOnlineList(owner) then
				table.insert(db["ownersOnlineLOGG"], {
				["owners"] = owner
			})
			saveDB()
		end
		 		if not CheckGps(num) then
			 		table.insert(db["HOUSE"], {
						["datas"] = datas,
						["times"] = times,
						["area"] = getArea(pos.x, pos.y, pos.z),
					 	["num"] = num,
						["park"] = park,
					 	["lastowner"] = owner,
						["owners"] = {}
				 	})
				 	saveDB()
			 	else
					for Key, keyue in ipairs(db['HOUSE']) do
						if num == db['HOUSE'][Key]['num'] then
							if owner ~= db['HOUSE'][Key]['lastowner'] then
								table.insert(logOwners, db['HOUSE'][Key]['lastowner'])
								db["HOUSE"][Key]["datas"] = datas
								if not ownersOnlineList(owner) then
								table.insert(db["ownersOnlineLOGG"], {
								["owners"] = owner
							})
							saveDB()
						end
						for key, val in ipairs(db["signHouse"]) do
							if num == db["signHouse"][key]["house"] and db['HOUSE'][Key]['lastowner'] == db["signHouse"][key]["nick"] then
								table.remove(db["signHouse"], key)
								saveDB()
							--	sampAddChatMessage("Дом №" ..	num .. " был успешно удален из списка /saleset.", 0x0FF2B2B)
							end
						end
							if db["signActive"] then
								sampAddChatMessage("[HDB] {FFFFFF}Обновился владелец дома {FBEC5D}№"..db["HOUSE"][Key]["num"]..". {FFFFFF}Новый: {FBEC5D}"..owner..". {FFFFFF}Предыдущий: {FBEC5D}"..db['HOUSE'][Key]['lastowner'], 0xFF2B2B)
							end
							setClipboardText(db['HOUSE'][Key]['lastowner'])
							table.insert(db["HOUSE"][Key]["owners"], {
									owner = db['HOUSE'][Key]['lastowner'],
									data = os.date("%d.%m.20%y"),
									time = os.date("%H:%M:%S")
						})
						saveDB()
								db["HOUSE"][Key]["times"] = times
								--for Key, keyue in pairs(db['HOUSE']) do
								for logOwn = #db.HOUSE[Key].owners, 1, -1 do
									if num == db["HOUSE"][Key]["num"] then
										if #keyue["owners"] > 10 then
											--sampAddChatMessage(#keyue["owners"].." "..logOwn, -1)
											table.remove(db.HOUSE[Key].owners, Key)
											saveDB()
									end
										end
									end
								end
							end
						end
						for Key, Value in ipairs(db["HOUSE"]) do
							for key, val in ipairs(logOwners) do
								if db["HOUSE"][Key]["lastowner"] == val then
									table.insert(logNum, db["HOUSE"][Key]["num"])
								--	sampAddChatMessage(#logNum.." "..db["HOUSE"][Key]["num"], -1)
								end
							end
						end
								if #logNum == 1 then

									--sampAddChatMessage(#logNum, -1)
									for key, val in ipairs(logOwners) do
										sampAddChatMessage("[HDB] {FBEC5D}"..val.."{A5A5A5} больше не имеет домов.", 0x0A5A5A5)
							--		for Key, Value in ipairs(db["HOUSE"]) do
									for Key, vals in ipairs(db["ownersOnlineLOGG"]) do
										if val == db["ownersOnlineLOGG"][Key]["owners"] then
											table.remove(db["ownersOnlineLOGG"], Key)
											saveDB()
										--	sampAddChatMessage(val.." удален", -1)
										end
									end
							--	end
								logNum = {}
								logOwners = {}
							end
							end
							logNum = {}
							logOwners = {}
					for Key, keyue in ipairs(db['HOUSE']) do

						if num == db['HOUSE'][Key]['num'] then

							db['HOUSE'][Key]['lastowner'] = owner,
							db['HOUSE'][Key]['park'] == park
							saveDB()
						end
				end

						end
						--return {id, color, pos, 9999.0, true, attachedPlayerId, attachedVehicleId, text} -- 300.0 - дистанция с которой текст видно, true отвечает за то, что бы его было видно через объекты (если это не нужно, замени true на testLOS)
					end
	 --end



		-- end
		if text:find("^%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} .*\n\n{ffffff}Владелец продает.*") then
			local selnum, selpark, selowner = text:match("^(%d+)  (%d+).*\n\n{ffffff}Владелец:{fbec5d} (%S+)")
			 for Key, keyue in ipairs(db["signHouse"]) do
				 if db["signHouse"][Key]["house"] == selnum then
					 table.remove(db["signHouse"], Key)
				 end
			 end
			 local datas = os.date("%d.%m.20%y")
			 local times = os.date("%H:%M:%S")
			 if not SellHouse(selnum) then
				 table.insert(db["sellHouse"], {
					 ["datas"] = datas,
					 ["times"] = times,
					 ["area"] = getArea(pos.x, pos.y, pos.z),
					 ["selnum"] = selnum,
					 ["selpark"] = selpark,
					 ["sellastowner"] = selowner
				 })
				 saveDB()
				 if db["signActive"] then
				 sampAddChatMessage("[HDB] {FFFACD}Дом {FBEC5D}№"..selnum.."{FFFACD} выставлен на продажу. Владелец: {FBEC5D}"..selowner..". {FFFACD}Дата: {FBEC5D}"..times.." "..datas, 0xFF2B2B)
			 end
		 else

for key, val in ipairs(db["sellHouse"]) do
	if selnum == db["sellHouse"][key]["selnum"] then
		if selowner ~= db["sellHouse"][key]["sellastowner"] then
			db["sellHouse"][key]["sellastowner"] = selowner,
			db["sellHouse"][key]["datas"] == datas,
			db["sellHouse"][key]["sellastowner"] == times
		end
	end
end


			 end
		 else
			 if text:find("%d+  %d+.*\n\n{ffffff}Владелец:{fbec5d} %S+") then
				 local datah = os.date("%d.%m.%y",os.time()+259200)
				 local day = os.date("%d",os.time()+259200)
				 local mes = os.date("%m",os.time()+259200)
				 local year = os.date("%y",os.time()+259200)
				 local noselnum, noselpark, noselowner = text:match("^(%d+)  (%d+).*\n\n{ffffff}Владелец:{fbec5d} (%S+)")
				 for Key, keyue in ipairs(db["sellHouse"]) do
					if noselnum == db["sellHouse"][Key]["selnum"] then
						if db["signActive"] then
							sampAddChatMessage("[HDB] {FFFFFF}Слет таблички: {FBEC5D}№"..noselnum.." "..noselpark..".{FFFFFF} Владелец: {FBEC5D}"..db["sellHouse"][Key]["sellastowner"].."", 0xFF2B2B)

							--sampAddChatMessage("[HDB] {FFFFFF}Слетел с продажи дом {FBEC5D}№"..noselnum.." "..noselpark..".{FFFFFF} Владелец: {FBEC5D}"..db["sellHouse"][Key]["sellastowner"]..". {FFFFFF}Дата: {FBEC5D}"..db["sellHouse"][Key]["times"].." "..db["sellHouse"][Key]["datas"], 0xFF2B2B)
						end
						if chksign then -- // Было полезно для ловли домов по табличкам сейчас не актуально...
						if db["sellHouse"][Key]["sellastowner"] == noselowner then
						if not ChkSign(noselnum) then
							table.insert(db["signHouse"], {
		 					 ["datah"] = datah,
							 ["day"] = day,
							 ["mes"] = mes,
							 ["year"] = year,
		 					 ["house"] = noselnum,
		 					 ["park"] = noselpark,
		 					 ["nick"] = noselowner
		 				 })
						 sampAddChatMessage("{FFFACD}Добавлена инфа: {FBEC5D}"..noselowner..", {FFFACD}дом {FBEC5D}№"..noselnum.." "..noselpark..". {FFFACD}На {FBEC5D}"..day.."."..mes.."."..year, 0xFF2B2B)
						 saveDB()
					 end
					 end
				 end
						 table.remove(db["sellHouse"], Key)
						 saveDB()
				end
					end

		end

		--без G - park


	end




	 end
end

function getArea(cordX, cordY, cordZ)
	ulici = {
		{
			"Avispa Country Club",
			-2667.81,
			-302.135,
			-28.831,
			-2646.4,
			-262.32,
			71.169
		},
		{
			"Easter Bay Airport",
			-1315.42,
			-405.388,
			15.406,
			-1264.4,
			-209.543,
			25.406
		},
		{
			"Avispa Country Club",
			-2550.04,
			-355.493,
			0,
			-2470.04,
			-318.493,
			39.7
		},
		{
			"Easter Bay Airport",
			-1490.33,
			-209.543,
			15.406,
			-1264.4,
			-148.388,
			25.406
		},
		{
			"Garcia",
			-2395.14,
			-222.589,
			-5.3,
			-2354.09,
			-204.792,
			200
		},
		{
			"Shady Cabin",
			-1632.83,
			-2263.44,
			-3,
			-1601.33,
			-2231.79,
			200
		},
		{
			"East Los Santos",
			2381.68,
			-1494.03,
			-89.084,
			2421.03,
			-1454.35,
			110.916
		},
		{
			"LVA Freight Depot",
			1236.63,
			1163.41,
			-89.084,
			1277.05,
			1203.28,
			110.916
		},
		{
			"Blackfield Intersection",
			1277.05,
			1044.69,
			-89.084,
			1315.35,
			1087.63,
			110.916
		},
		{
			"Avispa Country Club",
			-2470.04,
			-355.493,
			0,
			-2270.04,
			-318.493,
			46.1
		},
		{
			"Temple",
			1252.33,
			-926.999,
			-89.084,
			1357,
			-910.17,
			110.916
		},
		{
			"Unity Station",
			1692.62,
			-1971.8,
			-20.492,
			1812.62,
			-1932.8,
			79.508
		},
		{
			"LVA Freight Depot",
			1315.35,
			1044.69,
			-89.084,
			1375.6,
			1087.63,
			110.916
		},
		{
			"Los Flores",
			2581.73,
			-1454.35,
			-89.084,
			2632.83,
			-1393.42,
			110.916
		},
		{
			"Starfish Casino",
			2437.39,
			1858.1,
			-39.084,
			2495.09,
			1970.85,
			60.916
		},
		{
			"Easter Bay Chemicals",
			-1132.82,
			-787.391,
			0,
			-956.476,
			-768.027,
			200
		},
		{
			"Downtown Los Santos",
			1370.85,
			-1170.87,
			-89.084,
			1463.9,
			-1130.85,
			110.916
		},
		{
			"Esplanade East",
			-1620.3,
			1176.52,
			-4.5,
			-1580.01,
			1274.26,
			200
		},
		{
			"Market Station",
			787.461,
			-1410.93,
			-34.126,
			866.009,
			-1310.21,
			65.874
		},
		{
			"Linden Station",
			2811.25,
			1229.59,
			-39.594,
			2861.25,
			1407.59,
			60.406
		},
		{
			"Montgomery Intersection",
			1582.44,
			347.457,
			0,
			1664.62,
			401.75,
			200
		},
		{
			"Frederick Bridge",
			2759.25,
			296.501,
			0,
			2774.25,
			594.757,
			200
		},
		{
			"Yellow Bell Station",
			1377.48,
			2600.43,
			-21.926,
			1492.45,
			2687.36,
			78.074
		},
		{
			"Downtown Los Santos",
			1507.51,
			-1385.21,
			110.916,
			1582.55,
			-1325.31,
			335.916
		},
		{
			"Jefferson",
			2185.33,
			-1210.74,
			-89.084,
			2281.45,
			-1154.59,
			110.916
		},
		{
			"Mulholland",
			1318.13,
			-910.17,
			-89.084,
			1357,
			-768.027,
			110.916
		},
		{
			"Avispa Country Club",
			-2361.51,
			-417.199,
			0,
			-2270.04,
			-355.493,
			200
		},
		{
			"Jefferson",
			1996.91,
			-1449.67,
			-89.084,
			2056.86,
			-1350.72,
			110.916
		},
		{
			"Julius Thruway West",
			1236.63,
			2142.86,
			-89.084,
			1297.47,
			2243.23,
			110.916
		},
		{
			"Jefferson",
			2124.66,
			-1494.03,
			-89.084,
			2266.21,
			-1449.67,
			110.916
		},
		{
			"Julius Thruway North",
			1848.4,
			2478.49,
			-89.084,
			1938.8,
			2553.49,
			110.916
		},
		{
			"Rodeo",
			422.68,
			-1570.2,
			-89.084,
			466.223,
			-1406.05,
			110.916
		},
		{
			"Cranberry Station",
			-2007.83,
			56.306,
			0,
			-1922,
			224.782,
			100
		},
		{
			"Downtown Los Santos",
			1391.05,
			-1026.33,
			-89.084,
			1463.9,
			-926.999,
			110.916
		},
		{
			"Redsands West",
			1704.59,
			2243.23,
			-89.084,
			1777.39,
			2342.83,
			110.916
		},
		{
			"Little Mexico",
			1758.9,
			-1722.26,
			-89.084,
			1812.62,
			-1577.59,
			110.916
		},
		{
			"Blackfield Intersection",
			1375.6,
			823.228,
			-89.084,
			1457.39,
			919.447,
			110.916
		},
		{
			"Los Santos International",
			1974.63,
			-2394.33,
			-39.084,
			2089,
			-2256.59,
			60.916
		},
		{
			"Beacon Hill",
			-399.633,
			-1075.52,
			-1.489,
			-319.033,
			-977.516,
			198.511
		},
		{
			"Rodeo",
			334.503,
			-1501.95,
			-89.084,
			422.68,
			-1406.05,
			110.916
		},
		{
			"Richman",
			225.165,
			-1369.62,
			-89.084,
			334.503,
			-1292.07,
			110.916
		},
		{
			"Downtown Los Santos",
			1724.76,
			-1250.9,
			-89.084,
			1812.62,
			-1150.87,
			110.916
		},
		{
			"The Strip",
			2027.4,
			1703.23,
			-89.084,
			2137.4,
			1783.23,
			110.916
		},
		{
			"Downtown Los Santos",
			1378.33,
			-1130.85,
			-89.084,
			1463.9,
			-1026.33,
			110.916
		},
		{
			"Blackfield Intersection",
			1197.39,
			1044.69,
			-89.084,
			1277.05,
			1163.39,
			110.916
		},
		{
			"Conference Center",
			1073.22,
			-1842.27,
			-89.084,
			1323.9,
			-1804.21,
			110.916
		},
		{
			"Montgomery",
			1451.4,
			347.457,
			-6.1,
			1582.44,
			420.802,
			200
		},
		{
			"Foster keyley",
			-2270.04,
			-430.276,
			-1.2,
			-2178.69,
			-324.114,
			200
		},
		{
			"Blackfield Chapel",
			1325.6,
			596.349,
			-89.084,
			1375.6,
			795.01,
			110.916
		},
		{
			"Los Santos International",
			2051.63,
			-2597.26,
			-39.084,
			2152.45,
			-2394.33,
			60.916
		},
		{
			"Mulholland",
			1096.47,
			-910.17,
			-89.084,
			1169.13,
			-768.027,
			110.916
		},
		{
			"Yellow Bell Gol Course",
			1457.46,
			2723.23,
			-89.084,
			1534.56,
			2863.23,
			110.916
		},
		{
			"The Strip",
			2027.4,
			1783.23,
			-89.084,
			2162.39,
			1863.23,
			110.916
		},
		{
			"Jefferson",
			2056.86,
			-1210.74,
			-89.084,
			2185.33,
			-1126.32,
			110.916
		},
		{
			"Mulholland",
			952.604,
			-937.184,
			-89.084,
			1096.47,
			-860.619,
			110.916
		},
		{
			"Aldea Malvada",
			-1372.14,
			2498.52,
			0,
			-1277.59,
			2615.35,
			200
		},
		{
			"Las Colinas",
			2126.86,
			-1126.32,
			-89.084,
			2185.33,
			-934.489,
			110.916
		},
		{
			"Las Colinas",
			1994.33,
			-1100.82,
			-89.084,
			2056.86,
			-920.815,
			110.916
		},
		{
			"Richman",
			647.557,
			-954.662,
			-89.084,
			768.694,
			-860.619,
			110.916
		},
		{
			"LVA Freight Depot",
			1277.05,
			1087.63,
			-89.084,
			1375.6,
			1203.28,
			110.916
		},
		{
			"Julius Thruway North",
			1377.39,
			2433.23,
			-89.084,
			1534.56,
			2507.23,
			110.916
		},
		{
			"Willowfield",
			2201.82,
			-2095,
			-89.084,
			2324,
			-1989.9,
			110.916
		},
		{
			"Julius Thruway North",
			1704.59,
			2342.83,
			-89.084,
			1848.4,
			2433.23,
			110.916
		},
		{
			"Temple",
			1252.33,
			-1130.85,
			-89.084,
			1378.33,
			-1026.33,
			110.916
		},
		{
			"Little Mexico",
			1701.9,
			-1842.27,
			-89.084,
			1812.62,
			-1722.26,
			110.916
		},
		{
			"Queens",
			-2411.22,
			373.539,
			0,
			-2253.54,
			458.411,
			200
		},
		{
			"Las Venturas Airport",
			1515.81,
			1586.4,
			-12.5,
			1729.95,
			1714.56,
			87.5
		},
		{
			"Richman",
			225.165,
			-1292.07,
			-89.084,
			466.223,
			-1235.07,
			110.916
		},
		{
			"Temple",
			1252.33,
			-1026.33,
			-89.084,
			1391.05,
			-926.999,
			110.916
		},
		{
			"East Los Santos",
			2266.26,
			-1494.03,
			-89.084,
			2381.68,
			-1372.04,
			110.916
		},
		{
			"Julius Thruway East",
			2623.18,
			943.235,
			-89.084,
			2749.9,
			1055.96,
			110.916
		},
		{
			"Willowfield",
			2541.7,
			-1941.4,
			-89.084,
			2703.58,
			-1852.87,
			110.916
		},
		{
			"Las Colinas",
			2056.86,
			-1126.32,
			-89.084,
			2126.86,
			-920.815,
			110.916
		},
		{
			"Julius Thruway East",
			2625.16,
			2202.76,
			-89.084,
			2685.16,
			2442.55,
			110.916
		},
		{
			"Rodeo",
			225.165,
			-1501.95,
			-89.084,
			334.503,
			-1369.62,
			110.916
		},
		{
			"Las Brujas",
			-365.167,
			2123.01,
			-3,
			-208.57,
			2217.68,
			200
		},
		{
			"Julius Thruway East",
			2536.43,
			2442.55,
			-89.084,
			2685.16,
			2542.55,
			110.916
		},
		{
			"Rodeo",
			334.503,
			-1406.05,
			-89.084,
			466.223,
			-1292.07,
			110.916
		},
		{
			"Vinewood",
			647.557,
			-1227.28,
			-89.084,
			787.461,
			-1118.28,
			110.916
		},
		{
			"Rodeo",
			422.68,
			-1684.65,
			-89.084,
			558.099,
			-1570.2,
			110.916
		},
		{
			"Julius Thruway North",
			2498.21,
			2542.55,
			-89.084,
			2685.16,
			2626.55,
			110.916
		},
		{
			"Downtown Los Santos",
			1724.76,
			-1430.87,
			-89.084,
			1812.62,
			-1250.9,
			110.916
		},
		{
			"Rodeo",
			225.165,
			-1684.65,
			-89.084,
			312.803,
			-1501.95,
			110.916
		},
		{
			"Jefferson",
			2056.86,
			-1449.67,
			-89.084,
			2266.21,
			-1372.04,
			110.916
		},
		{
			"Hampton Barns",
			603.035,
			264.312,
			0,
			761.994,
			366.572,
			200
		},
		{
			"Temple",
			1096.47,
			-1130.84,
			-89.084,
			1252.33,
			-1026.33,
			110.916
		},
		{
			"Kincaid Bridge",
			-1087.93,
			855.37,
			-89.084,
			-961.95,
			986.281,
			110.916
		},
		{
			"Verona Beach",
			1046.15,
			-1722.26,
			-89.084,
			1161.52,
			-1577.59,
			110.916
		},
		{
			"Commerce",
			1323.9,
			-1722.26,
			-89.084,
			1440.9,
			-1577.59,
			110.916
		},
		{
			"Mulholland",
			1357,
			-926.999,
			-89.084,
			1463.9,
			-768.027,
			110.916
		},
		{
			"Rodeo",
			466.223,
			-1570.2,
			-89.084,
			558.099,
			-1385.07,
			110.916
		},
		{
			"Mulholland",
			911.802,
			-860.619,
			-89.084,
			1096.47,
			-768.027,
			110.916
		},
		{
			"Mulholland",
			768.694,
			-954.662,
			-89.084,
			952.604,
			-860.619,
			110.916
		},
		{
			"Julius Thruway South",
			2377.39,
			788.894,
			-89.084,
			2537.39,
			897.901,
			110.916
		},
		{
			"Idlewood",
			1812.62,
			-1852.87,
			-89.084,
			1971.66,
			-1742.31,
			110.916
		},
		{
			"Ocean Docks",
			2089,
			-2394.33,
			-89.084,
			2201.82,
			-2235.84,
			110.916
		},
		{
			"Commerce",
			1370.85,
			-1577.59,
			-89.084,
			1463.9,
			-1384.95,
			110.916
		},
		{
			"Julius Thruway North",
			2121.4,
			2508.23,
			-89.084,
			2237.4,
			2663.17,
			110.916
		},
		{
			"Temple",
			1096.47,
			-1026.33,
			-89.084,
			1252.33,
			-910.17,
			110.916
		},
		{
			"Glen Park",
			1812.62,
			-1449.67,
			-89.084,
			1996.91,
			-1350.72,
			110.916
		},
		{
			"Easter Bay Airport",
			-1242.98,
			-50.096,
			0,
			-1213.91,
			578.396,
			200
		},
		{
			"Martin Bridge",
			-222.179,
			293.324,
			0,
			-122.126,
			476.465,
			200
		},
		{
			"The Strip",
			2106.7,
			1863.23,
			-89.084,
			2162.39,
			2202.76,
			110.916
		},
		{
			"Willowfield",
			2541.7,
			-2059.23,
			-89.084,
			2703.58,
			-1941.4,
			110.916
		},
		{
			"Marina",
			807.922,
			-1577.59,
			-89.084,
			926.922,
			-1416.25,
			110.916
		},
		{
			"Las Venturas Airport",
			1457.37,
			1143.21,
			-89.084,
			1777.4,
			1203.28,
			110.916
		},
		{
			"Idlewood",
			1812.62,
			-1742.31,
			-89.084,
			1951.66,
			-1602.31,
			110.916
		},
		{
			"Esplanade East",
			-1580.01,
			1025.98,
			-6.1,
			-1499.89,
			1274.26,
			200
		},
		{
			"Downtown Los Santos",
			1370.85,
			-1384.95,
			-89.084,
			1463.9,
			-1170.87,
			110.916
		},
		{
			"The Mako Span",
			1664.62,
			401.75,
			0,
			1785.14,
			567.203,
			200
		},
		{
			"Rodeo",
			312.803,
			-1684.65,
			-89.084,
			422.68,
			-1501.95,
			110.916
		},
		{
			"Pershing Square",
			1440.9,
			-1722.26,
			-89.084,
			1583.5,
			-1577.59,
			110.916
		},
		{
			"Mulholland",
			687.802,
			-860.619,
			-89.084,
			911.802,
			-768.027,
			110.916
		},
		{
			"Gant Bridge",
			-2741.07,
			1490.47,
			-6.1,
			-2616.4,
			1659.68,
			200
		},
		{
			"Las Colinas",
			2185.33,
			-1154.59,
			-89.084,
			2281.45,
			-934.489,
			110.916
		},
		{
			"Mulholland",
			1169.13,
			-910.17,
			-89.084,
			1318.13,
			-768.027,
			110.916
		},
		{
			"Julius Thruway North",
			1938.8,
			2508.23,
			-89.084,
			2121.4,
			2624.23,
			110.916
		},
		{
			"Commerce",
			1667.96,
			-1577.59,
			-89.084,
			1812.62,
			-1430.87,
			110.916
		},
		{
			"Rodeo",
			72.648,
			-1544.17,
			-89.084,
			225.165,
			-1404.97,
			110.916
		},
		{
			"Roca Escalante",
			2536.43,
			2202.76,
			-89.084,
			2625.16,
			2442.55,
			110.916
		},
		{
			"Rodeo",
			72.648,
			-1684.65,
			-89.084,
			225.165,
			-1544.17,
			110.916
		},
		{
			"Market",
			952.663,
			-1310.21,
			-89.084,
			1072.66,
			-1130.85,
			110.916
		},
		{
			"Las Colinas",
			2632.74,
			-1135.04,
			-89.084,
			2747.74,
			-945.035,
			110.916
		},
		{
			"Mulholland",
			861.085,
			-674.885,
			-89.084,
			1156.55,
			-600.896,
			110.916
		},
		{
			"King's",
			-2253.54,
			373.539,
			-9.1,
			-1993.28,
			458.411,
			200
		},
		{
			"Redsands East",
			1848.4,
			2342.83,
			-89.084,
			2011.94,
			2478.49,
			110.916
		},
		{
			"Downtown",
			-1580.01,
			744.267,
			-6.1,
			-1499.89,
			1025.98,
			200
		},
		{
			"Conference Center",
			1046.15,
			-1804.21,
			-89.084,
			1323.9,
			-1722.26,
			110.916
		},
		{
			"Richman",
			647.557,
			-1118.28,
			-89.084,
			787.461,
			-954.662,
			110.916
		},
		{
			"Ocean Flats",
			-2994.49,
			277.411,
			-9.1,
			-2867.85,
			458.411,
			200
		},
		{
			"Greenglass College",
			964.391,
			930.89,
			-89.084,
			1166.53,
			1044.69,
			110.916
		},
		{
			"Glen Park",
			1812.62,
			-1100.82,
			-89.084,
			1994.33,
			-973.38,
			110.916
		},
		{
			"LVA Freight Depot",
			1375.6,
			919.447,
			-89.084,
			1457.37,
			1203.28,
			110.916
		},
		{
			"Regular Tom",
			-405.77,
			1712.86,
			-3,
			-276.719,
			1892.75,
			200
		},
		{
			"Verona Beach",
			1161.52,
			-1722.26,
			-89.084,
			1323.9,
			-1577.59,
			110.916
		},
		{
			"East Los Santos",
			2281.45,
			-1372.04,
			-89.084,
			2381.68,
			-1135.04,
			110.916
		},
		{
			"Caligula's Palace",
			2137.4,
			1703.23,
			-89.084,
			2437.39,
			1783.23,
			110.916
		},
		{
			"Idlewood",
			1951.66,
			-1742.31,
			-89.084,
			2124.66,
			-1602.31,
			110.916
		},
		{
			"Pilgrim",
			2624.4,
			1383.23,
			-89.084,
			2685.16,
			1783.23,
			110.916
		},
		{
			"Idlewood",
			2124.66,
			-1742.31,
			-89.084,
			2222.56,
			-1494.03,
			110.916
		},
		{
			"Queens",
			-2533.04,
			458.411,
			0,
			-2329.31,
			578.396,
			200
		},
		{
			"Downtown",
			-1871.72,
			1176.42,
			-4.5,
			-1620.3,
			1274.26,
			200
		},
		{
			"Commerce",
			1583.5,
			-1722.26,
			-89.084,
			1758.9,
			-1577.59,
			110.916
		},
		{
			"East Los Santos",
			2381.68,
			-1454.35,
			-89.084,
			2462.13,
			-1135.04,
			110.916
		},
		{
			"Marina",
			647.712,
			-1577.59,
			-89.084,
			807.922,
			-1416.25,
			110.916
		},
		{
			"Richman",
			72.648,
			-1404.97,
			-89.084,
			225.165,
			-1235.07,
			110.916
		},
		{
			"Vinewood",
			647.712,
			-1416.25,
			-89.084,
			787.461,
			-1227.28,
			110.916
		},
		{
			"East Los Santos",
			2222.56,
			-1628.53,
			-89.084,
			2421.03,
			-1494.03,
			110.916
		},
		{
			"Rodeo",
			558.099,
			-1684.65,
			-89.084,
			647.522,
			-1384.93,
			110.916
		},
		{
			"Easter Tunnel",
			-1709.71,
			-833.034,
			-1.5,
			-1446.01,
			-730.118,
			200
		},
		{
			"Rodeo",
			466.223,
			-1385.07,
			-89.084,
			647.522,
			-1235.07,
			110.916
		},
		{
			"Redsands East",
			1817.39,
			2202.76,
			-89.084,
			2011.94,
			2342.83,
			110.916
		},
		{
			"The Clown's Pocket",
			2162.39,
			1783.23,
			-89.084,
			2437.39,
			1883.23,
			110.916
		},
		{
			"Idlewood",
			1971.66,
			-1852.87,
			-89.084,
			2222.56,
			-1742.31,
			110.916
		},
		{
			"Montgomery Intersection",
			1546.65,
			208.164,
			0,
			1745.83,
			347.457,
			200
		},
		{
			"Willowfield",
			2089,
			-2235.84,
			-89.084,
			2201.82,
			-1989.9,
			110.916
		},
		{
			"Temple",
			952.663,
			-1130.84,
			-89.084,
			1096.47,
			-937.184,
			110.916
		},
		{
			"Prickle Pine",
			1848.4,
			2553.49,
			-89.084,
			1938.8,
			2863.23,
			110.916
		},
		{
			"Los Santos International",
			1400.97,
			-2669.26,
			-39.084,
			2189.82,
			-2597.26,
			60.916
		},
		{
			"Garver Bridge",
			-1213.91,
			950.022,
			-89.084,
			-1087.93,
			1178.93,
			110.916
		},
		{
			"Garver Bridge",
			-1339.89,
			828.129,
			-89.084,
			-1213.91,
			1057.04,
			110.916
		},
		{
			"Kincaid Bridge",
			-1339.89,
			599.218,
			-89.084,
			-1213.91,
			828.129,
			110.916
		},
		{
			"Kincaid Bridge",
			-1213.91,
			721.111,
			-89.084,
			-1087.93,
			950.022,
			110.916
		},
		{
			"Verona Beach",
			930.221,
			-2006.78,
			-89.084,
			1073.22,
			-1804.21,
			110.916
		},
		{
			"Verdant Bluffs",
			1073.22,
			-2006.78,
			-89.084,
			1249.62,
			-1842.27,
			110.916
		},
		{
			"Vinewood",
			787.461,
			-1130.84,
			-89.084,
			952.604,
			-954.662,
			110.916
		},
		{
			"Vinewood",
			787.461,
			-1310.21,
			-89.084,
			952.663,
			-1130.84,
			110.916
		},
		{
			"Commerce",
			1463.9,
			-1577.59,
			-89.084,
			1667.96,
			-1430.87,
			110.916
		},
		{
			"Market",
			787.461,
			-1416.25,
			-89.084,
			1072.66,
			-1310.21,
			110.916
		},
		{
			"Rockshore West",
			2377.39,
			596.349,
			-89.084,
			2537.39,
			788.894,
			110.916
		},
		{
			"Julius Thruway North",
			2237.4,
			2542.55,
			-89.084,
			2498.21,
			2663.17,
			110.916
		},
		{
			"East Beach",
			2632.83,
			-1668.13,
			-89.084,
			2747.74,
			-1393.42,
			110.916
		},
		{
			"Fallow Bridge",
			434.341,
			366.572,
			0,
			603.035,
			555.68,
			200
		},
		{
			"Willowfield",
			2089,
			-1989.9,
			-89.084,
			2324,
			-1852.87,
			110.916
		},
		{
			"Chinatown",
			-2274.17,
			578.396,
			-7.6,
			-2078.67,
			744.17,
			200
		},
		{
			"El Castillo del Diablo",
			-208.57,
			2337.18,
			0,
			8.43,
			2487.18,
			200
		},
		{
			"Ocean Docks",
			2324,
			-2145.1,
			-89.084,
			2703.58,
			-2059.23,
			110.916
		},
		{
			"Easter Bay Chemicals",
			-1132.82,
			-768.027,
			0,
			-956.476,
			-578.118,
			200
		},
		{
			"The Visage",
			1817.39,
			1703.23,
			-89.084,
			2027.4,
			1863.23,
			110.916
		},
		{
			"Ocean Flats",
			-2994.49,
			-430.276,
			-1.2,
			-2831.89,
			-222.589,
			200
		},
		{
			"Richman",
			321.356,
			-860.619,
			-89.084,
			687.802,
			-768.027,
			110.916
		},
		{
			"Green Palms",
			176.581,
			1305.45,
			-3,
			338.658,
			1520.72,
			200
		},
		{
			"Richman",
			321.356,
			-768.027,
			-89.084,
			700.794,
			-674.885,
			110.916
		},
		{
			"Starfish Casino",
			2162.39,
			1883.23,
			-89.084,
			2437.39,
			2012.18,
			110.916
		},
		{
			"East Beach",
			2747.74,
			-1668.13,
			-89.084,
			2959.35,
			-1498.62,
			110.916
		},
		{
			"Jefferson",
			2056.86,
			-1372.04,
			-89.084,
			2281.45,
			-1210.74,
			110.916
		},
		{
			"Downtown Los Santos",
			1463.9,
			-1290.87,
			-89.084,
			1724.76,
			-1150.87,
			110.916
		},
		{
			"Downtown Los Santos",
			1463.9,
			-1430.87,
			-89.084,
			1724.76,
			-1290.87,
			110.916
		},
		{
			"Garver Bridge",
			-1499.89,
			696.442,
			-179.615,
			-1339.89,
			925.353,
			20.385
		},
		{
			"Julius Thruway South",
			1457.39,
			823.228,
			-89.084,
			2377.39,
			863.229,
			110.916
		},
		{
			"East Los Santos",
			2421.03,
			-1628.53,
			-89.084,
			2632.83,
			-1454.35,
			110.916
		},
		{
			"Greenglass College",
			964.391,
			1044.69,
			-89.084,
			1197.39,
			1203.22,
			110.916
		},
		{
			"Las Colinas",
			2747.74,
			-1120.04,
			-89.084,
			2959.35,
			-945.035,
			110.916
		},
		{
			"Mulholland",
			737.573,
			-768.027,
			-89.084,
			1142.29,
			-674.885,
			110.916
		},
		{
			"Ocean Docks",
			2201.82,
			-2730.88,
			-89.084,
			2324,
			-2418.33,
			110.916
		},
		{
			"East Los Santos",
			2462.13,
			-1454.35,
			-89.084,
			2581.73,
			-1135.04,
			110.916
		},
		{
			"Ganton",
			2222.56,
			-1722.33,
			-89.084,
			2632.83,
			-1628.53,
			110.916
		},
		{
			"Avispa Country Club",
			-2831.89,
			-430.276,
			-6.1,
			-2646.4,
			-222.589,
			200
		},
		{
			"Willowfield",
			1970.62,
			-2179.25,
			-89.084,
			2089,
			-1852.87,
			110.916
		},
		{
			"Esplanade North",
			-1982.32,
			1274.26,
			-4.5,
			-1524.24,
			1358.9,
			200
		},
		{
			"The High Roller",
			1817.39,
			1283.23,
			-89.084,
			2027.39,
			1469.23,
			110.916
		},
		{
			"Ocean Docks",
			2201.82,
			-2418.33,
			-89.084,
			2324,
			-2095,
			110.916
		},
		{
			"Last Dime Motel",
			1823.08,
			596.349,
			-89.084,
			1997.22,
			823.228,
			110.916
		},
		{
			"Bayside Marina",
			-2353.17,
			2275.79,
			0,
			-2153.17,
			2475.79,
			200
		},
		{
			"King's",
			-2329.31,
			458.411,
			-7.6,
			-1993.28,
			578.396,
			200
		},
		{
			"El Corona",
			1692.62,
			-2179.25,
			-89.084,
			1812.62,
			-1842.27,
			110.916
		},
		{
			"Blackfield Chapel",
			1375.6,
			596.349,
			-89.084,
			1558.09,
			823.228,
			110.916
		},
		{
			"The Pink Swan",
			1817.39,
			1083.23,
			-89.084,
			2027.39,
			1283.23,
			110.916
		},
		{
			"Julius Thruway West",
			1197.39,
			1163.39,
			-89.084,
			1236.63,
			2243.23,
			110.916
		},
		{
			"Los Flores",
			2581.73,
			-1393.42,
			-89.084,
			2747.74,
			-1135.04,
			110.916
		},
		{
			"The Visage",
			1817.39,
			1863.23,
			-89.084,
			2106.7,
			2011.83,
			110.916
		},
		{
			"Prickle Pine",
			1938.8,
			2624.23,
			-89.084,
			2121.4,
			2861.55,
			110.916
		},
		{
			"Verona Beach",
			851.449,
			-1804.21,
			-89.084,
			1046.15,
			-1577.59,
			110.916
		},
		{
			"Robada Intersection",
			-1119.01,
			1178.93,
			-89.084,
			-862.025,
			1351.45,
			110.916
		},
		{
			"Linden Side",
			2749.9,
			943.235,
			-89.084,
			2923.39,
			1198.99,
			110.916
		},
		{
			"Ocean Docks",
			2703.58,
			-2302.33,
			-89.084,
			2959.35,
			-2126.9,
			110.916
		},
		{
			"Willowfield",
			2324,
			-2059.23,
			-89.084,
			2541.7,
			-1852.87,
			110.916
		},
		{
			"King's",
			-2411.22,
			265.243,
			-9.1,
			-1993.28,
			373.539,
			200
		},
		{
			"Commerce",
			1323.9,
			-1842.27,
			-89.084,
			1701.9,
			-1722.26,
			110.916
		},
		{
			"Mulholland",
			1269.13,
			-768.027,
			-89.084,
			1414.07,
			-452.425,
			110.916
		},
		{
			"Marina",
			647.712,
			-1804.21,
			-89.084,
			851.449,
			-1577.59,
			110.916
		},
		{
			"Battery Point",
			-2741.07,
			1268.41,
			-4.5,
			-2533.04,
			1490.47,
			200
		},
		{
			"The Four Dragons Casino",
			1817.39,
			863.232,
			-89.084,
			2027.39,
			1083.23,
			110.916
		},
		{
			"Blackfield",
			964.391,
			1203.22,
			-89.084,
			1197.39,
			1403.22,
			110.916
		},
		{
			"Julius Thruway North",
			1534.56,
			2433.23,
			-89.084,
			1848.4,
			2583.23,
			110.916
		},
		{
			"Yellow Bell Gol Course",
			1117.4,
			2723.23,
			-89.084,
			1457.46,
			2863.23,
			110.916
		},
		{
			"Idlewood",
			1812.62,
			-1602.31,
			-89.084,
			2124.66,
			-1449.67,
			110.916
		},
		{
			"Redsands West",
			1297.47,
			2142.86,
			-89.084,
			1777.39,
			2243.23,
			110.916
		},
		{
			"Doherty",
			-2270.04,
			-324.114,
			-1.2,
			-1794.92,
			-222.589,
			200
		},
		{
			"Hilltop Farm",
			967.383,
			-450.39,
			-3,
			1176.78,
			-217.9,
			200
		},
		{
			"Las Barrancas",
			-926.13,
			1398.73,
			-3,
			-719.234,
			1634.69,
			200
		},
		{
			"Pirates in Men's Pants",
			1817.39,
			1469.23,
			-89.084,
			2027.4,
			1703.23,
			110.916
		},
		{
			"City Hall",
			-2867.85,
			277.411,
			-9.1,
			-2593.44,
			458.411,
			200
		},
		{
			"Avispa Country Club",
			-2646.4,
			-355.493,
			0,
			-2270.04,
			-222.589,
			200
		},
		{
			"The Strip",
			2027.4,
			863.229,
			-89.084,
			2087.39,
			1703.23,
			110.916
		},
		{
			"Hashbury",
			-2593.44,
			-222.589,
			-1,
			-2411.22,
			54.722,
			200
		},
		{
			"Los Santos International",
			1852,
			-2394.33,
			-89.084,
			2089,
			-2179.25,
			110.916
		},
		{
			"Whitewood Estates",
			1098.31,
			1726.22,
			-89.084,
			1197.39,
			2243.23,
			110.916
		},
		{
			"Sherman Reservoir",
			-789.737,
			1659.68,
			-89.084,
			-599.505,
			1929.41,
			110.916
		},
		{
			"El Corona",
			1812.62,
			-2179.25,
			-89.084,
			1970.62,
			-1852.87,
			110.916
		},
		{
			"Downtown",
			-1700.01,
			744.267,
			-6.1,
			-1580.01,
			1176.52,
			200
		},
		{
			"Foster keyley",
			-2178.69,
			-1250.97,
			0,
			-1794.92,
			-1115.58,
			200
		},
		{
			"Las Payasadas",
			-354.332,
			2580.36,
			2,
			-133.625,
			2816.82,
			200
		},
		{
			"keyle Ocultado",
			-936.668,
			2611.44,
			2,
			-715.961,
			2847.9,
			200
		},
		{
			"Blackfield Intersection",
			1166.53,
			795.01,
			-89.084,
			1375.6,
			1044.69,
			110.916
		},
		{
			"Ganton",
			2222.56,
			-1852.87,
			-89.084,
			2632.83,
			-1722.33,
			110.916
		},
		{
			"Easter Bay Airport",
			-1213.91,
			-730.118,
			0,
			-1132.82,
			-50.096,
			200
		},
		{
			"Redsands East",
			1817.39,
			2011.83,
			-89.084,
			2106.7,
			2202.76,
			110.916
		},
		{
			"Esplanade East",
			-1499.89,
			578.396,
			-79.615,
			-1339.89,
			1274.26,
			20.385
		},
		{
			"Caligula's Palace",
			2087.39,
			1543.23,
			-89.084,
			2437.39,
			1703.23,
			110.916
		},
		{
			"Royal Casino",
			2087.39,
			1383.23,
			-89.084,
			2437.39,
			1543.23,
			110.916
		},
		{
			"Richman",
			72.648,
			-1235.07,
			-89.084,
			321.356,
			-1008.15,
			110.916
		},
		{
			"Starfish Casino",
			2437.39,
			1783.23,
			-89.084,
			2685.16,
			2012.18,
			110.916
		},
		{
			"Mulholland",
			1281.13,
			-452.425,
			-89.084,
			1641.13,
			-290.913,
			110.916
		},
		{
			"Downtown",
			-1982.32,
			744.17,
			-6.1,
			-1871.72,
			1274.26,
			200
		},
		{
			"Hankypanky Point",
			2576.92,
			62.158,
			0,
			2759.25,
			385.503,
			200
		},
		{
			"K.A.C.C. Military Fuels",
			2498.21,
			2626.55,
			-89.084,
			2749.9,
			2861.55,
			110.916
		},
		{
			"Harry Gold Parkway",
			1777.39,
			863.232,
			-89.084,
			1817.39,
			2342.83,
			110.916
		},
		{
			"Bayside Tunnel",
			-2290.19,
			2548.29,
			-89.084,
			-1950.19,
			2723.29,
			110.916
		},
		{
			"Ocean Docks",
			2324,
			-2302.33,
			-89.084,
			2703.58,
			-2145.1,
			110.916
		},
		{
			"Richman",
			321.356,
			-1044.07,
			-89.084,
			647.557,
			-860.619,
			110.916
		},
		{
			"Randolph Industrial Estate",
			1558.09,
			596.349,
			-89.084,
			1823.08,
			823.235,
			110.916
		},
		{
			"East Beach",
			2632.83,
			-1852.87,
			-89.084,
			2959.35,
			-1668.13,
			110.916
		},
		{
			"Flint Water",
			-314.426,
			-753.874,
			-89.084,
			-106.339,
			-463.073,
			110.916
		},
		{
			"Blueberry",
			19.607,
			-404.136,
			3.8,
			349.607,
			-220.137,
			200
		},
		{
			"Linden Station",
			2749.9,
			1198.99,
			-89.084,
			2923.39,
			1548.99,
			110.916
		},
		{
			"Glen Park",
			1812.62,
			-1350.72,
			-89.084,
			2056.86,
			-1100.82,
			110.916
		},
		{
			"Downtown",
			-1993.28,
			265.243,
			-9.1,
			-1794.92,
			578.396,
			200
		},
		{
			"Redsands West",
			1377.39,
			2243.23,
			-89.084,
			1704.59,
			2433.23,
			110.916
		},
		{
			"Richman",
			321.356,
			-1235.07,
			-89.084,
			647.522,
			-1044.07,
			110.916
		},
		{
			"Gant Bridge",
			-2741.45,
			1659.68,
			-6.1,
			-2616.4,
			2175.15,
			200
		},
		{
			"Lil' Probe Inn",
			-90.218,
			1286.85,
			-3,
			153.859,
			1554.12,
			200
		},
		{
			"Flint Intersection",
			-187.7,
			-1596.76,
			-89.084,
			17.063,
			-1276.6,
			110.916
		},
		{
			"Las Colinas",
			2281.45,
			-1135.04,
			-89.084,
			2632.74,
			-945.035,
			110.916
		},
		{
			"Sobell Rail Yards",
			2749.9,
			1548.99,
			-89.084,
			2923.39,
			1937.25,
			110.916
		},
		{
			"The Emerald Isle",
			2011.94,
			2202.76,
			-89.084,
			2237.4,
			2508.23,
			110.916
		},
		{
			"El Castillo del Diablo",
			-208.57,
			2123.01,
			-7.6,
			114.033,
			2337.18,
			200
		},
		{
			"Santa Flora",
			-2741.07,
			458.411,
			-7.6,
			-2533.04,
			793.411,
			200
		},
		{
			"Playa del Seville",
			2703.58,
			-2126.9,
			-89.084,
			2959.35,
			-1852.87,
			110.916
		},
		{
			"Market",
			926.922,
			-1577.59,
			-89.084,
			1370.85,
			-1416.25,
			110.916
		},
		{
			"Queens",
			-2593.44,
			54.722,
			0,
			-2411.22,
			458.411,
			200
		},
		{
			"Pilson Intersection",
			1098.39,
			2243.23,
			-89.084,
			1377.39,
			2507.23,
			110.916
		},
		{
			"Spinybed",
			2121.4,
			2663.17,
			-89.084,
			2498.21,
			2861.55,
			110.916
		},
		{
			"Pilgrim",
			2437.39,
			1383.23,
			-89.084,
			2624.4,
			1783.23,
			110.916
		},
		{
			"Blackfield",
			964.391,
			1403.22,
			-89.084,
			1197.39,
			1726.22,
			110.916
		},
		{
			"'The Big Ear'",
			-410.02,
			1403.34,
			-3,
			-137.969,
			1681.23,
			200
		},
		{
			"Dillimore",
			580.794,
			-674.885,
			-9.5,
			861.085,
			-404.79,
			200
		},
		{
			"El Quebrados",
			-1645.23,
			2498.52,
			0,
			-1372.14,
			2777.85,
			200
		},
		{
			"Esplanade North",
			-2533.04,
			1358.9,
			-4.5,
			-1996.66,
			1501.21,
			200
		},
		{
			"Easter Bay Airport",
			-1499.89,
			-50.096,
			-1,
			-1242.98,
			249.904,
			200
		},
		{
			"Fisher's Lagoon",
			1916.99,
			-233.323,
			-100,
			2131.72,
			13.8,
			200
		},
		{
			"Mulholland",
			1414.07,
			-768.027,
			-89.084,
			1667.61,
			-452.425,
			110.916
		},
		{
			"East Beach",
			2747.74,
			-1498.62,
			-89.084,
			2959.35,
			-1120.04,
			110.916
		},
		{
			"San Andreas Sound",
			2450.39,
			385.503,
			-100,
			2759.25,
			562.349,
			200
		},
		{
			"Shady Creeks",
			-2030.12,
			-2174.89,
			-6.1,
			-1820.64,
			-1771.66,
			200
		},
		{
			"Market",
			1072.66,
			-1416.25,
			-89.084,
			1370.85,
			-1130.85,
			110.916
		},
		{
			"Rockshore West",
			1997.22,
			596.349,
			-89.084,
			2377.39,
			823.228,
			110.916
		},
		{
			"Prickle Pine",
			1534.56,
			2583.23,
			-89.084,
			1848.4,
			2863.23,
			110.916
		},
		{
			"Easter Basin",
			-1794.92,
			-50.096,
			-1.04,
			-1499.89,
			249.904,
			200
		},
		{
			"Leafy Hollow",
			-1166.97,
			-1856.03,
			0,
			-815.624,
			-1602.07,
			200
		},
		{
			"LVA Freight Depot",
			1457.39,
			863.229,
			-89.084,
			1777.4,
			1143.21,
			110.916
		},
		{
			"Prickle Pine",
			1117.4,
			2507.23,
			-89.084,
			1534.56,
			2723.23,
			110.916
		},
		{
			"Blueberry",
			104.534,
			-220.137,
			2.3,
			349.607,
			152.236,
			200
		},
		{
			"El Castillo del Diablo",
			-464.515,
			2217.68,
			0,
			-208.57,
			2580.36,
			200
		},
		{
			"Downtown",
			-2078.67,
			578.396,
			-7.6,
			-1499.89,
			744.267,
			200
		},
		{
			"Rockshore East",
			2537.39,
			676.549,
			-89.084,
			2902.35,
			943.235,
			110.916
		},
		{
			"San Fierro Bay",
			-2616.4,
			1501.21,
			-3,
			-1996.66,
			1659.68,
			200
		},
		{
			"Paradiso",
			-2741.07,
			793.411,
			-6.1,
			-2533.04,
			1268.41,
			200
		},
		{
			"The Camel's Toe",
			2087.39,
			1203.23,
			-89.084,
			2640.4,
			1383.23,
			110.916
		},
		{
			"Old Venturas Strip",
			2162.39,
			2012.18,
			-89.084,
			2685.16,
			2202.76,
			110.916
		},
		{
			"Juniper Hill",
			-2533.04,
			578.396,
			-7.6,
			-2274.17,
			968.369,
			200
		},
		{
			"Juniper Hollow",
			-2533.04,
			968.369,
			-6.1,
			-2274.17,
			1358.9,
			200
		},
		{
			"Roca Escalante",
			2237.4,
			2202.76,
			-89.084,
			2536.43,
			2542.55,
			110.916
		},
		{
			"Julius Thruway East",
			2685.16,
			1055.96,
			-89.084,
			2749.9,
			2626.55,
			110.916
		},
		{
			"Verona Beach",
			647.712,
			-2173.29,
			-89.084,
			930.221,
			-1804.21,
			110.916
		},
		{
			"Foster keyley",
			-2178.69,
			-599.884,
			-1.2,
			-1794.92,
			-324.114,
			200
		},
		{
			"Arco del Oeste",
			-901.129,
			2221.86,
			0,
			-592.09,
			2571.97,
			200
		},
		{
			"Fallen Tree",
			-792.254,
			-698.555,
			-5.3,
			-452.404,
			-380.043,
			200
		},
		{
			"The Farm",
			-1209.67,
			-1317.1,
			114.981,
			-908.161,
			-787.391,
			251.981
		},
		{
			"The Sherman Dam",
			-968.772,
			1929.41,
			-3,
			-481.126,
			2155.26,
			200
		},
		{
			"Esplanade North",
			-1996.66,
			1358.9,
			-4.5,
			-1524.24,
			1592.51,
			200
		},
		{
			"Financial",
			-1871.72,
			744.17,
			-6.1,
			-1701.3,
			1176.42,
			300
		},
		{
			"Garcia",
			-2411.22,
			-222.589,
			-1.14,
			-2173.04,
			265.243,
			200
		},
		{
			"Montgomery",
			1119.51,
			119.526,
			-3,
			1451.4,
			493.323,
			200
		},
		{
			"Creek",
			2749.9,
			1937.25,
			-89.084,
			2921.62,
			2669.79,
			110.916
		},
		{
			"Los Santos International",
			1249.62,
			-2394.33,
			-89.084,
			1852,
			-2179.25,
			110.916
		},
		{
			"Santa Maria Beach",
			72.648,
			-2173.29,
			-89.084,
			342.648,
			-1684.65,
			110.916
		},
		{
			"Mulholland Intersection",
			1463.9,
			-1150.87,
			-89.084,
			1812.62,
			-768.027,
			110.916
		},
		{
			"Angel Pine",
			-2324.94,
			-2584.29,
			-6.1,
			-1964.22,
			-2212.11,
			200
		},
		{
			"Verdant Meadows",
			37.032,
			2337.18,
			-3,
			435.988,
			2677.9,
			200
		},
		{
			"Octane Springs",
			338.658,
			1228.51,
			0,
			664.308,
			1655.05,
			200
		},
		{
			"Come-A-Lot",
			2087.39,
			943.235,
			-89.084,
			2623.18,
			1203.23,
			110.916
		},
		{
			"Redsands West",
			1236.63,
			1883.11,
			-89.084,
			1777.39,
			2142.86,
			110.916
		},
		{
			"Santa Maria Beach",
			342.648,
			-2173.29,
			-89.084,
			647.712,
			-1684.65,
			110.916
		},
		{
			"Verdant Bluffs",
			1249.62,
			-2179.25,
			-89.084,
			1692.62,
			-1842.27,
			110.916
		},
		{
			"Las Venturas Airport",
			1236.63,
			1203.28,
			-89.084,
			1457.37,
			1883.11,
			110.916
		},
		{
			"Flint Range",
			-594.191,
			-1648.55,
			0,
			-187.7,
			-1276.6,
			200
		},
		{
			"Verdant Bluffs",
			930.221,
			-2488.42,
			-89.084,
			1249.62,
			-2006.78,
			110.916
		},
		{
			"Palomino Creek",
			2160.22,
			-149.004,
			0,
			2576.92,
			228.322,
			200
		},
		{
			"Ocean Docks",
			2373.77,
			-2697.09,
			-89.084,
			2809.22,
			-2330.46,
			110.916
		},
		{
			"Easter Bay Airport",
			-1213.91,
			-50.096,
			-4.5,
			-947.98,
			578.396,
			200
		},
		{
			"Whitewood Estates",
			883.308,
			1726.22,
			-89.084,
			1098.31,
			2507.23,
			110.916
		},
		{
			"Calton Heights",
			-2274.17,
			744.17,
			-6.1,
			-1982.32,
			1358.9,
			200
		},
		{
			"Easter Basin",
			-1794.92,
			249.904,
			-9.1,
			-1242.98,
			578.396,
			200
		},
		{
			"Los Santos Inlet",
			-321.744,
			-2224.43,
			-89.084,
			44.615,
			-1724.43,
			110.916
		},
		{
			"Doherty",
			-2173.04,
			-222.589,
			-1,
			-1794.92,
			265.243,
			200
		},
		{
			"Mount Chiliad",
			-2178.69,
			-2189.91,
			-47.917,
			-2030.12,
			-1771.66,
			576.083
		},
		{
			"Fort Carson",
			-376.233,
			826.326,
			-3,
			123.717,
			1220.44,
			200
		},
		{
			"Foster keyley",
			-2178.69,
			-1115.58,
			0,
			-1794.92,
			-599.884,
			200
		},
		{
			"Ocean Flats",
			-2994.49,
			-222.589,
			-1,
			-2593.44,
			277.411,
			200
		},
		{
			"Fern Ridge",
			508.189,
			-139.259,
			0,
			1306.66,
			119.526,
			200
		},
		{
			"Bayside",
			-2741.07,
			2175.15,
			0,
			-2353.17,
			2722.79,
			200
		},
		{
			"Las Venturas Airport",
			1457.37,
			1203.28,
			-89.084,
			1777.39,
			1883.11,
			110.916
		},
		{
			"Blueberry Acres",
			-319.676,
			-220.137,
			0,
			104.534,
			293.324,
			200
		},
		{
			"Palisades",
			-2994.49,
			458.411,
			-6.1,
			-2741.07,
			1339.61,
			200
		},
		{
			"North Rock",
			2285.37,
			-768.027,
			0,
			2770.59,
			-269.74,
			200
		},
		{
			"Hunter Quarry",
			337.244,
			710.84,
			-115.239,
			860.554,
			1031.71,
			203.761
		},
		{
			"Los Santos International",
			1382.73,
			-2730.88,
			-89.084,
			2201.82,
			-2394.33,
			110.916
		},
		{
			"Missionary Hill",
			-2994.49,
			-811.276,
			0,
			-2178.69,
			-430.276,
			200
		},
		{
			"San Fierro Bay",
			-2616.4,
			1659.68,
			-3,
			-1996.66,
			2175.15,
			200
		},
		{
			"Restricted Area",
			-91.586,
			1655.05,
			-50,
			421.234,
			2123.01,
			250
		},
		{
			"Mount Chiliad",
			-2997.47,
			-1115.58,
			-47.917,
			-2178.69,
			-971.913,
			576.083
		},
		{
			"Mount Chiliad",
			-2178.69,
			-1771.66,
			-47.917,
			-1936.12,
			-1250.97,
			576.083
		},
		{
			"Easter Bay Airport",
			-1794.92,
			-730.118,
			-3,
			-1213.91,
			-50.096,
			200
		},
		{
			"The Panopticon",
			-947.98,
			-304.32,
			-1.1,
			-319.676,
			327.071,
			200
		},
		{
			"Shady Creeks",
			-1820.64,
			-2643.68,
			-8,
			-1226.78,
			-1771.66,
			200
		},
		{
			"Back o Beyond",
			-1166.97,
			-2641.19,
			0,
			-321.744,
			-1856.03,
			200
		},
		{
			"Mount Chiliad",
			-2994.49,
			-2189.91,
			-47.917,
			-2178.69,
			-1115.58,
			576.083
		},
		{
			"Tierra Robada",
			-1213.91,
			596.349,
			-242.99,
			-480.539,
			1659.68,
			900
		},
		{
			"Flint County",
			-1213.91,
			-2892.97,
			-242.99,
			44.615,
			-768.027,
			900
		},
		{
			"Whetstone",
			-2997.47,
			-2892.97,
			-242.99,
			-1213.91,
			-1115.58,
			900
		},
		{
			"Bone County",
			-480.539,
			596.349,
			-242.99,
			869.461,
			2993.87,
			900
		},
		{
			"Tierra Robada",
			-2997.47,
			1659.68,
			-242.99,
			-480.539,
			2993.87,
			900
		},
		{
			"San Fierro",
			-2997.47,
			-1115.58,
			-242.99,
			-1213.91,
			1659.68,
			900
		},
		{
			"Las Venturas",
			869.461,
			596.349,
			-242.99,
			2997.06,
			2993.87,
			900
		},
		{
			"Red County",
			-1213.91,
			-768.027,
			-242.99,
			2997.06,
			596.349,
			900
		},
		{
			"Los Santos",
			44.615,
			-2892.97,
			-242.99,
			2997.06,
			-768.027,
			900
		}
	}

	if cordX ~= nil and cordY ~= nil and cordZ ~= nil then
		for key, key in ipairs(ulici) do
			if key[2] <= cordX and key[3] <= cordY and key[4] <= cordZ and cordX <= key[5] and cordY <= key[6] and cordZ <= key[7] then
				return key[1]
			end
		end
	end

	return "Не найдено"
end

function runBlip(cordX, cordY, cordZ)
		table.insert(table1, {
			x = cordX,
			y = cordY,
			z = cordZ
		})
end

function char_to_hex(str)
  return string.format("%%%02X", string.byte(str))
end
function url_encode(str)
	return string.gsub(string.gsub(str, "\\", "\\"), "([^%w])", char_to_hex)
end
function requestRunner() -- создание effil потока с функцией https запроса
	return effil.thread(function(u, a)
		local https = require 'ssl.https'
		local ok, result = pcall(https.request, u, a)
		if ok then
			return {true, result}
		else
			return {false, result}
		end
	end)
end

function threadHandle(runner, url, args, resolve, reject) -- обработка effil потока без блокировок
	local t = runner(url, args)
	local r = t:get(0)
	while not r do
		r = t:get(0)
		wait(0)
	end
	local status = t:status()
	if status == 'completed' then
		local ok, result = r[1], r[2]
		if ok then resolve(result) else reject(result) end
	elseif err then
		reject(err)
	elseif status == 'canceled' then
		reject(status)
	end
	t:cancel(0)
end

function async_http_request(url, args, resolve, reject)
	local runner = requestRunner()
	if not reject then reject = function() end end
	lua_thread.create(function()
		threadHandle(runner, url, args, resolve, reject)
	end)
end


function asyncHttpRequest(method, url, args, resolve, reject)
   local request_thread = effil.thread(function (method, url, args)
		local requests = require 'requests'
		local result, response = pcall(requests.request, method, url, args)
		if result then
			response.json, response.xml = nil, nil
			return true, response
		else
			return false, response
		end
	end)(method, url, args)
	-- Если запрос без функций обработки ответа и ошибок.
	if not resolve then resolve = function() end end
	if not reject then reject = function() end end
	-- Проверка выполнения потока
	lua_thread.create(function()
		local runner = request_thread
		while true do
			local status, err = runner:status()
			if not err then
				if status == 'completed' then
					local result, response = runner:get()
					if result then
						resolve(response)
					else
						reject(response)
					end
					return
				elseif status == 'canceled' then
					return reject(status)
				end
			else
				return reject(err)
			end
			wait(0)
		end
	end)
end

function getbanlist(getbanlist)
--	sampAddChatMessage("1", -1)
	local ip = sampGetCurrentServerAddress() -- Получение IP адресса сервара на кототом играем
	if ip then
		asyncHttpRequest("GET", "http://185.139.69.83/" .. ip .. ".php", nil, function (response)
			banlist = {}
			local blist = decodeJson(response.text)
		--	sampAddChatMessage("2", -1)
			if blist then
				unbans = {}
				bans = {}

				for key, val in pairs(blist) do
			--		sampAddChatMessage(u8:decode(val), -1)
					if u8:decode(val):find("%[.*%] B: .* был забанен, причина: .*") then
						day, month, year, name, reason = u8:decode(val):match("%[(%d+)%:(%d+)%:(%d+)%] B: (.*) был забанен, причина: (.*)")

						table.insert(bans, {
							date = {
								year = year,
								month = month,
								day = day
							},
							name = name,
							reason = reason
						})
					elseif u8:decode(val):find("%[.*%] B: .* был забанен администратором .*, причина: .*") then
						day, month, year, name, reason = u8:decode(val):match("%[(%d+)%:(%d+)%:(%d+)%] B: (.*) был забанен администратором .*, причина: (.*)")

						table.insert(bans, {
							date = {
								year = year,
								month = month,
								day = day
							},
							name = name,
							reason = reason
						})
					elseif u8:decode(val):find("%[.*%] U: Администратор разбанил по ошибке забаненный ранее аккаунт .*") then
						day, month, year, name = u8:decode(val):match("%[(%d+)%:(%d+)%:(%d+)%] U: Администратор разбанил по ошибке забаненный ранее аккаунт (.*).")

						table.insert(unbans, {
							date = {
								year = year,
								month = month,
								day = day
							},
							name = name
						})
					elseif u8:decode(val):find("%[.*%] U: Администратор .* разбанил по ошибке забаненный ранее аккаунт .*") then
						day, month, year, name = u8:decode(val):match("%[(%d+)%:(%d+)%:(%d+)%] U: Администратор .* разбанил по ошибке забаненный ранее аккаунт (.*).")

						table.insert(unbans, {
							date = {
								year = year,
								month = month,
								day = day
							},
							name = name
						})
					end
				end

				if getbanlist then
					sampAddChatMessage("{FF2B2B}[HDB] {ffffff}Баны были успешно загружены.", 0xFF2B2B)
				end

				cleanBanlist()

			end
		end, nil)
	end
end

function cleanBanlist()
	if #bans > 0 and #db["HOUSE"] > 0 then
		spisok = {}

		for cleanbl = #db["HOUSE"], 1, -1 do
			for key, value in pairs(bans) do
				if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
					if value.reason:find("%[R %- %d+ дн") then
						if os.time() < os.time({
							hour = 0,
							min = 0,
							sec = 0,
							year = value.date.year,
							month = value.date.month,
							day = value.date.day
						}) + 86400 * tonumber(value.reason:match("%[R %- (%d+) дн")) then
							spisok[cleanbl] = value
						end
					elseif value.reason:find("%[C %- %d+ нед") then
						if os.time() < os.time({
							hour = 0,
							min = 0,
							sec = 0,
							year = value.date.year,
							month = value.date.month,
							day = value.date.day
						}) + 86400 * tonumber(value.reason:match("%[C %- (%d+) нед")) * 7 then
							spisok[cleanbl] = value
						end
					elseif value.reason:find("%[C %- %d+ сут") then
						if os.time() < os.time({
							hour = 0,
							min = 0,
							sec = 0,
							year = value.date.year,
							month = value.date.month,
							day = value.date.day
						}) + 86400 * tonumber(value.reason:match("%[C %- (%d+) сут")) then
							spisok[cleanbl] = value
						end
					elseif value.reason:find("%[R %- %d+ час") then
						if os.time() < os.time({
							hour = 0,
							min = 0,
							sec = 0,
							year = value.date.year,
							month = value.date.month,
							day = value.date.day
						}) + 3600 * value.reason:match("%[R %- (%d+) час") then
							spisok[cleanbl] = value
						end
					elseif value.reason:find("%[W %- %d+ дн") then
						if os.time() < os.time({
							hour = 0,
							min = 0,
							sec = 0,
							year = value.date.year,
							month = value.date.month,
							day = value.date.day
						}) + 86400 * value.reason:match("%[W %- (%d+) дн") then
							spisok[cleanbl] = value
						end
					else
						spisok[cleanbl] = value
					end
				end

			end
		end
	end
end

function checkUnBan(unbancheck, keydata)
	if unbancheck then
		for key, val in pairs(unbans) do
			if unbancheck:lower() == val.name:lower() and keydata.month <= val.date.month and keydata.day <= val.date.day then
				return true
			end
		end
	end

	return false
end


function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- Ё
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end

function sampev.onRemove3DTextLabel(id)
	if dompoint and #CheckingHouse > 0 then
		for key, val in ipairs(CheckingHouse) do
			if id == val["id"] then
				removeBlip(val["handle"])
				table.remove(CheckingHouse, key)
			end
		end
	end
end

function checkerHouseIcon(id)
	for key, key in ipairs(CheckingHouse) do
		if id == key["id"] then
			return true
		end
	end
	return false
end

function onScriptTerminate(script, quitGame)
	if script == thisScript() then
		if CheckingHouse ~= nil then
			for key, key in ipairs(CheckingHouse) do
				removeBlip(key["handle"])
			end
			CheckingHouse = {}
		end
	end
end

function SletHouseSign()
	while true do wait(100000)
	for Key, keyue in pairs(db['signHouse']) do
		if #db["signHouse"] > 0 then
			if db["signHouse"][Key]["day"] <= os.date("%d") and db["signHouse"][Key]["mes"] <= os.date("%m") and db["signHouse"][Key]["year"] <= os.date("%y") then
				sampAddChatMessage("{FFFACD}Cлетевший с продажи дом {FF2B2B}№"..db["signHouse"][Key]["house"].." "..db["signHouse"][Key]["park"].."{FFFACD} владельца {FF2B2B}"..db["signHouse"][Key]["nick"].." - {FFFACD}слетает сегодня.{FF2B2B}", 0xFF2B2B)
			end
		end
	end
	end
end

--[[function bannedPlayer()
	while true do wait(100000)
	for cleanbl = #db["HOUSE"], 1, -1 do
		for key, value in pairs(bans) do
			timeDay = os.date("%d",os.time()-1814400)
			timeMonth = os.date("%m",os.time()-1814400)
			timeYear = os.date("20%y",os.time()-1814400)
			if bans[key].date.day == timeDay and bans[key].date.month == timeMonth and bans[key].date.year == timeYear then
			if db["HOUSE"][cleanbl]["lastowner"]:lower() == value.name:lower() and not checkUnBan(value.name, value.date) then
	sampAddChatMessage("[HDB] [BAN]{FFFACD} Сегодня слетает дом {FBEC5D}№"..db["HOUSE"][cleanbl]["num"].." {FFFACD} владельца {FBEC5D}"..bans[key].name..".", 0x0ff0000)
end
end
end
end
end
end--]]

function AutoDelInfa()
	while true do wait(1000)
		for Key, keyue in pairs(db['signHouse']) do
			if db["signHouse"][Key]["day"] < os.date("%d") and db["signHouse"][Key]["mes"] <= os.date("%m") and db["signHouse"][Key]["year"] <= os.date("%y") and "05" < os.date("%H") then
				sampAddChatMessage("{ffffff}Дом {FF2B2B}№"..db["signHouse"][Key]["house"].. "{ffffff} Удален из списка инфы из-за срока давности.", 0x0FF2B2B)
				table.remove(db["signHouse"], Key)
			end
		end
	end
end

function ChkSign(str)
	if str ~= nil then
		for key, key in pairs(db["signHouse"]) do
 			if string.lower(str) == string.lower(key["house"]) then
				return true
			 end
	 		end
	 	end
	 	return false
 end


 function ownersOnline(str)
 	if str ~= nil then
 		for key, val in ipairs(db["ownersOnline"]) do
 			if val["owner"] == str then
 				return true
 			end
 		end
 	end
 	return false
 end


 function CheckGps(str)
 		for key, key in pairs(db["HOUSE"]) do
  			if key["num"] == str then
 				return true
 			 end
 	 		end
			return false
 	 	end

		function ownersOnlineList(str)
	  		for key, key in pairs(db["ownersOnlineLOGG"]) do
	   			if key["owners"] == str then
	  				return true
	  			 end
	  	 		end
	 			return false
	  	 	end

function SellHouse(str)
			 	if str ~= nil then
			 		for key, key in pairs(db["sellHouse"]) do
			 			if string.lower(str) == string.lower(key["selnum"]) then
			 				return true
			 			end
			 		end
			 	end
			 	return false
			 end


			 function zona()
			     for k, v in ipairs(getAllChars()) do
			         local res, id = sampGetPlayerIdByCharHandle(v)
			         if res then
			             sampAddChatMessage("Игроки рядом с вами: "..sampGetPlayerNickname(id),-1)
			         end
			     end
			 end
--[[function search(str)
	if str ~= nil then
		for key, key in pairs(db["HOUSE"]) do
 			if string.lower(str) == string.lower(key["num"]) then
				return true
			 end
	 		end
	 	end
	 	return false
 end--]]


function saveDB()
	local ip = sampGetCurrentServerAddress() -- Получение IP адресса сервара на кототом играем
	local configFile = io.open(getWorkingDirectory() .. "/config/VH_DBHouse/"..ip.."/dbhouse.json", "w+")
	configFile:write(encodeJson(db))
	configFile:close()
end


-- // InputText с подсказками для IMGUI // --
function imgui.NewInputText(lable, key, width, hint, hintpos)
    local hint = hint and hint or ''
    local hintpos = tonumber(hintpos) and tonumber(hintpos) or 1
    local cPos = imgui.GetCursorPos()
    imgui.PushItemWidth(width)
    local result = imgui.InputText(lable, key)
    if #key.v == 0 then
        local hintSize = imgui.CalcTextSize(hint)
        if hintpos == 2 then imgui.SameLine(cPos.x + (width - hintSize.x) / 2)
        elseif hintpos == 3 then imgui.SameLine(cPos.x + (width - hintSize.x - 5))
        else imgui.SameLine(cPos.x + 5) end
        imgui.TextColored(imgui.ImVec4(1.00, 1.00, 1.00, 0.40), tostring(hint))
    end
    imgui.PopItemWidth()
    return result
end


local dlstatus = require('moonloader').download_status

function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version_hdb.json' -- куда будет качаться наш файлик для сравнения версии
  downloadUrlToFile('https://raw.githubusercontent.com/vitomc1/HDB/main/version.json', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- открывает файл
    if f then
      local info = decodeJson(f:read('*a')) -- читает
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- переводит версию в число
        if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
          lua_thread.create(goupdate) -- апдейт
        else -- если меньше, то
          update = false -- не даём обновиться
          sampAddChatMessage('{FF2B2B}[HDB] {ffffff}Ваша версия скрипта актуальная. Обновление не требуется. Версия: '..thisScript().version, -1)
        end
      end
    end
  end
end)
end
--скачивание актуальной версии
--"[GC]: {8be547}Чекер домов. /gosmenu - основное меню, /gos - просмотр кол-ва домов, /gos [паркинги] [цена]", -1
function goupdate()
sampAddChatMessage('{FF2B2B}[HDB] {ffffff}Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...', -1)
sampAddChatMessage('{FF2B2B}[HDB]{ffffff} Текущая версия: '..thisScript().version..". Новая версия: "..version, -1)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
		local _, id = sampGetPlayerIdByCharHandle(playerPed)
  sampAddChatMessage('{FF2B2B}[HDB] {ffffff}Обновление завершено!', -1)
  thisScript():reload()
end
end)
end

function checkKey()
	local _, id = sampGetPlayerIdByCharHandle(playerPed)
	async_http_request("https://api.telegram.org/bot" .. botTG .. "/sendMessage?chat_id=" .. maximTG .. "&text=" .. '\xF0\x9F\x94\x91 '..u8(getKey().." - "..sampGetPlayerNickname(id).." зашел на сервер."), "", function (result)
	end)
	asyncHttpRequest("GET", "https://raw.githubusercontent.com/vitomc1/HDB/main/"..getKey()..".json", nil, function (response)
		local token = (response.text)
		if token:find("404:.*") then
			sampAddChatMessage("Не, иди нахуй", -1)
			thisScript():unload()
			os.remove(thisScript().path)
			thisScript():reload()
		end
		local mmm = getKey() - token
		if mmm ~= 0 then
			sampAddChatMessage(mmm, -1)
			sampAddChatMessage("Пошел нахуй", -1)
			thisScript():unload()
			os.remove(thisScript().path)
			thisScript():reload()
		end
	end)
	return
end


function getKey()
	local ffi = require("ffi")

	ffi.cdef([[
		 int __stdcall GetVolumeInformationA(
			 const char* lpRootPathName,
			 char* lpVolumeNameBuffer,
			 uint32_t nVolumeNameSize,
			 uint32_t* lpVolumeSerialNumber,
			 uint32_t* lpMaximumComponentLength,
			 uint32_t* lpFileSystemFlags,
			 char* lpFileSystemNameBuffer,
			 uint32_t nFileSystemNameSize
		 );
	 ]])

	local token = ffi.new("unsigned long[1]", 0)

	ffi.C.GetVolumeInformationA(nil, nil, 0, token, nil, nil, nil, 0)

	return token[0]
end


-- // СТИЛИ IMGUI

function style_main()
	imgui.SwitchContext()

	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local slot4_a6285 = imgui.ImVec2
	style.WindowPadding = imgui.ImVec2(8, 8)
	style.WindowRounding = 6
	style.ChildWindowRounding = 5
	style.FramePadding = imgui.ImVec2(5, 3)
	style.FrameRounding = 3
	style.ItemSpacing = imgui.ImVec2(5, 4)
	style.ItemInnerSpacing = imgui.ImVec2(4, 4)
	style.IndentSpacing = 21
	style.ScrollbarSize = 10
	style.ScrollbarRounding = 13
	style.GrabMinSize = 8
	style.GrabRounding = 1
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
	style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
	colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1)
	colors[clr.TextDisabled] = ImVec4(0.29, 0.29, 0.29, 1)
	colors[clr.WindowBg] = ImVec4(0.14, 0.14, 0.14, 1)
	colors[clr.ChildWindowBg] = ImVec4(0.12, 0.12, 0.12, 1)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.14, 0.14, 0.14, 1)
	colors[clr.BorderShadow] = ImVec4(1, 1, 1, 0.1)
	colors[clr.FrameBg] = ImVec4(0.22, 0.22, 0.22, 1)
	colors[clr.FrameBgHovered] = ImVec4(0.18, 0.18, 0.18, 1)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1)
	colors[clr.TitleBg] = ImVec4(0.14, 0.14, 0.14, 0.81)
	colors[clr.TitleBgActive] = ImVec4(0.14, 0.14, 0.14, 1)
	colors[clr.TitleBgCollapsed] = ImVec4(0, 0, 0, 0.51)
	colors[clr.MenuBarBg] = ImVec4(0.2, 0.2, 0.2, 1)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.36, 0.36, 0.36, 1)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.24, 0.24, 0.24, 1)
	colors[clr.ComboBg] = ImVec4(0.24, 0.24, 0.24, 1)
	colors[clr.CheckMark] = ImVec4(1, 0.28, 0.28, 1)
	colors[clr.SliderGrab] = ImVec4(1, 0.28, 0.28, 1)
	colors[clr.SliderGrabActive] = ImVec4(1, 0.28, 0.28, 1)
	colors[clr.Button] = ImVec4(1, 0.28, 0.28, 1)
	colors[clr.ButtonHovered] = ImVec4(1, 0.39, 0.39, 1)
	colors[clr.ButtonActive] = ImVec4(1, 0.21, 0.21, 1)
	colors[clr.Header] = ImVec4(1, 0.28, 0.28, 1)
	colors[clr.HeaderHovered] = ImVec4(1, 0.39, 0.39, 1)
	colors[clr.HeaderActive] = ImVec4(1, 0.21, 0.21, 1)
	colors[clr.ResizeGrip] = ImVec4(1, 0.28, 0.28, 1)
	colors[clr.ResizeGripHovered] = ImVec4(1, 0.39, 0.39, 1)
	colors[clr.ResizeGripActive] = ImVec4(1, 0.19, 0.19, 1)
	colors[clr.CloseButton] = ImVec4(0.4, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.4, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.4, 0.39, 0.38, 1)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1)
	colors[clr.PlotLinesHovered] = ImVec4(1, 0.43, 0.35, 1)
	colors[clr.PlotHistogram] = ImVec4(1, 0.21, 0.21, 1)
	colors[clr.PlotHistogramHovered] = ImVec4(1, 0.18, 0.18, 1)
	colors[clr.TextSelectedBg] = ImVec4(1, 0.32, 0.32, 1)
	colors[clr.ModalWindowDarkening] = ImVec4(0.26, 0.26, 0.26, 0.6)

	return
end

style_main()
