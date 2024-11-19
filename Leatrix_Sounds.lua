
	----------------------------------------------------------------------
	-- Leatrix Sounds 4.0.35.alpha.6 (18th November 2024)
	----------------------------------------------------------------------

	--  Create global table
	_G.LeaSoundsDB = _G.LeaSoundsDB or {}

	-- Create local tables
	local LeaSoundsLC, LeaSoundsCB = {}, {}

	-- Version
	LeaSoundsLC["AddonVer"] = "4.0.35.alpha.6"

	-- Get locale table
	local void, Leatrix_Sounds = ...
	local L = Leatrix_Sounds.L

	-- Check Wow version is valid
	do
		local gameversion, gamebuild, gamedate, gametocversion = GetBuildInfo()
		if gametocversion and gametocversion < 40000 or gametocversion > 49999 then
			-- Game client is not Wow Classic
			C_Timer.After(2, function()
				print(L["LEATRIX SOUNDS: WRONG VERSION INSTALLED!"])
			end)
			return
		end
		if gametocversion and gametocversion == 40401 then
			LeaSoundsLC.NewPatch = true
		end
	end

	-- Set bindings translations
	_G.BINDING_NAME_LEATRIX_SOUNDS_GLOBAL_TOGGLE = L["Toggle panel"]

	----------------------------------------------------------------------
	--	L00: Leatrix Sounds
	----------------------------------------------------------------------

	-- Initialise variables
	local frameWidth = 800

	----------------------------------------------------------------------
	-- L10: Functions
	----------------------------------------------------------------------

	-- Print text
	function LeaSoundsLC:Print(text)
		DEFAULT_CHAT_FRAME:AddMessage(L[text], 1.0, 0.85, 0.0)
	end

	-- Load a numeric variable and set it to default if it's not within a given range
	function LeaSoundsLC:LoadVarNum(var, def, valmin, valmax)
		if LeaSoundsDB[var] and type(LeaSoundsDB[var]) == "number" and LeaSoundsDB[var] >= valmin and LeaSoundsDB[var] <= valmax then
			LeaSoundsLC[var] = LeaSoundsDB[var]
		else
			LeaSoundsLC[var] = def
			LeaSoundsDB[var] = def
		end
	end

	-- Load an anchor point variable and set it to default if the anchor point is invalid
	function LeaSoundsLC:LoadVarAnc(var, def)
		if LeaSoundsDB[var] and type(LeaSoundsDB[var]) == "string" and LeaSoundsDB[var] == "CENTER" or LeaSoundsDB[var] == "TOP" or LeaSoundsDB[var] == "BOTTOM" or LeaSoundsDB[var] == "LEFT" or LeaSoundsDB[var] == "RIGHT" or LeaSoundsDB[var] == "TOPLEFT" or LeaSoundsDB[var] == "TOPRIGHT" or LeaSoundsDB[var] == "BOTTOMLEFT" or LeaSoundsDB[var] == "BOTTOMRIGHT" then
			LeaSoundsLC[var] = LeaSoundsDB[var]
		else
			LeaSoundsLC[var] = def
			LeaSoundsDB[var] = def
		end
	end

	-- Load a string variable or set it to default if it's not set to "On" or "Off"
	function LeaSoundsLC:LoadVarChk(var, def)
		if LeaSoundsDB[var] and type(LeaSoundsDB[var]) == "string" and LeaSoundsDB[var] == "On" or LeaSoundsDB[var] == "Off" then
			LeaSoundsLC[var] = LeaSoundsDB[var]
		else
			LeaSoundsLC[var] = def
			LeaSoundsDB[var] = def
		end
	end

	-- Show tooltips for buttons
	function LeaSoundsLC:TipSee()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = self:GetParent()
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (parent:GetRight() * pscale))
		if gap < (250 * tscale) then
			GameTooltip:SetPoint("TOPRIGHT", parent, "TOPLEFT", 0, 0)
		else
			GameTooltip:SetPoint("TOPLEFT", parent, "TOPRIGHT", 0, 0)
		end
		GameTooltip:SetText(self.tiptext, nil, nil, nil, nil, true)
	end

	-- Lock and unlock an item
	function LeaSoundsLC:LockItem(item, lock)
		if lock then
			item:Disable()
			item:SetAlpha(0.3)
		else
			item:Enable()
			item:SetAlpha(1.0)
		end
	end

	-- Create an editbox
	function LeaSoundsLC:CreateEditBox(frame, parent, width, maxchars, anchor, x, y)

		-- Create editbox
		local eb = CreateFrame("EditBox", nil, parent, "InputBoxTemplate")
		eb:SetPoint(anchor, x, y)
		eb:SetWidth(width)
		eb:SetHeight(24)
		eb:SetFontObject("GameFontNormal")
		eb:SetTextColor(1.0, 1.0, 1.0)
		eb:SetAutoFocus(false)
		eb:SetMaxLetters(maxchars)
		eb:SetScript("OnEscapePressed", eb.ClearFocus)
		eb:SetScript("OnEnterPressed", eb.ClearFocus)

		-- Add editbox border and backdrop
		eb.f = CreateFrame("FRAME", nil, eb, "BackdropTemplate")
		eb.f:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = false, tileSize = 16, edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 }})
		eb.f:SetPoint("LEFT", -6, 0)
		eb.f:SetWidth(eb:GetWidth()+6)
		eb.f:SetHeight(eb:GetHeight())
		eb.f:SetBackdropColor(1.0, 1.0, 1.0, 0.3)

		return eb

	end

	-- Create a button
	function LeaSoundsLC:CreateButton(name, frame, label, anchor, x, y, height, tip)
		local mbtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
		LeaSoundsCB[name] = mbtn
		mbtn:SetHeight(height)
		mbtn:SetPoint(anchor, x, y)
		mbtn:SetHitRectInsets(0, 0, 0, 0)
		mbtn:SetText(L[label])

		-- Tooltip handler
		if tip then
			mbtn.tiptext = L[tip]
			mbtn:SetScript("OnEnter", LeaSoundsLC.TipSee)
			mbtn:SetScript("OnLeave", GameTooltip_Hide)
		end

		-- Create fontstring and set button width based on it
		mbtn.f = mbtn:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
		mbtn.f:SetText(L[label])
		mbtn:SetWidth(mbtn.f:GetStringWidth() + 20)

		-- Set skinned button textures
		mbtn:SetNormalTexture("Interface\\AddOns\\Leatrix_Sounds\\Leatrix_Sounds.blp")
		mbtn:GetNormalTexture():SetTexCoord(0.5, 1, 0, 1)
		mbtn:SetHighlightTexture("Interface\\AddOns\\Leatrix_Sounds\\Leatrix_Sounds.blp")
		mbtn:GetHighlightTexture():SetTexCoord(0, 0.5, 0, 1)

		-- Hide the default textures
		mbtn:HookScript("OnShow", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnEnable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnDisable", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnMouseDown", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)
		mbtn:HookScript("OnMouseUp", function() mbtn.Left:Hide(); mbtn.Middle:Hide(); mbtn.Right:Hide() end)

		return mbtn
	end

	-- Create a subheading
	function LeaSoundsLC:MakeTx(frame, title, x, y)
		local text = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetPoint("TOPLEFT", x, y)
		text:SetText(L[title])
		return text
	end

	-- Create a checkbox
	function LeaSoundsLC:MakeCB(field, caption, x, y, tip)

		-- Create the checkbox
		local Cbox = CreateFrame("CheckButton", nil, LeaSoundsLC["PageF"], "ChatConfigCheckButtonTemplate")
		LeaSoundsCB[field] = Cbox
		Cbox:SetPoint("TOPLEFT",x, y)
		Cbox:SetScript("OnEnter", LeaSoundsLC.TipSee)
		Cbox:SetScript("OnLeave", GameTooltip_Hide)

		-- Add label and tooltip
		Cbox.f = Cbox:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight')
		Cbox.f:SetPoint('LEFT', 20, 0)
		Cbox.f:SetText(L[caption])
		Cbox.tiptext = L[tip]

		-- Set label parameters
		Cbox.f:SetJustifyH("LEFT")
		Cbox.f:SetWordWrap(false)

		-- Set maximum label width
		if Cbox.f:GetWidth() > 60 then
			Cbox.f:SetWidth(60)
		end

		-- Set checkbox click width
		if Cbox.f:GetStringWidth() > 60 then
			Cbox:SetHitRectInsets(0, -50, 0, 0)
		else
			Cbox:SetHitRectInsets(0, -Cbox.f:GetStringWidth() + 4, 0, 0)
		end

		-- Set default checkbox state
		Cbox:SetScript('OnShow', function(self)
			if LeaSoundsLC[field] == "On" then
				self:SetChecked(true)
			else
				self:SetChecked(false)
			end
		end)

		-- Process clicks
		Cbox:SetScript('OnClick', function()
			if Cbox:GetChecked() then
				LeaSoundsLC[field] = "On"
			else
				LeaSoundsLC[field] = "Off"
			end
		end)
	end

	----------------------------------------------------------------------
	-- L20: Player
	----------------------------------------------------------------------

	function LeaSoundsLC:Player()

		-- Create music table
		Leatrix_Sounds["Listing"] = {}

		-- Create panel
		local PageF = CreateFrame("Frame", nil, UIParent)

		-- Make it a system frame
		_G["LeaSoundsGlobalPanel"] = PageF
		table.insert(UISpecialFrames, "LeaSoundsGlobalPanel")

		-- Set frame parameters
		LeaSoundsLC["PageF"] = PageF
		PageF:SetSize(frameWidth, 308)
		PageF:SetScale(1.1)
		PageF:Hide()
		PageF:SetFrameStrata("FULLSCREEN_DIALOG")
		PageF:SetFrameLevel(40)
		PageF:SetClampedToScreen(true)
		PageF:SetClampRectInsets(550, -550, -200, 200)
		PageF:ClearAllPoints()
		PageF:SetPoint("CENTER", 0, 0)
		PageF:EnableMouse(true)
		PageF:SetMovable(true)
		PageF:RegisterForDrag("LeftButton")
		PageF:SetScript("OnDragStart", PageF.StartMoving)
		PageF:SetScript("OnDragStop", function()
			PageF:StopMovingOrSizing()
			PageF:SetUserPlaced(false)
			-- Save panel position
			LeaSoundsLC["MainPanelA"], void, LeaSoundsLC["MainPanelR"], LeaSoundsLC["MainPanelX"], LeaSoundsLC["MainPanelY"] = PageF:GetPoint()
		end)

		-- Add background color
		PageF.t = PageF:CreateTexture(nil, "BACKGROUND")
		PageF.t:SetAllPoints()
		PageF.t:SetColorTexture(0.05, 0.05, 0.05, 0.9)

		-- Add textures
		PageF.mainTex = PageF:CreateTexture(nil, "BORDER")
		PageF.mainTex:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		PageF.mainTex:SetSize(frameWidth, 273)
		PageF.mainTex:SetPoint("TOPRIGHT")
		PageF.mainTex:SetVertexColor(0.7, 0.7, 0.7, 0.7)
		PageF.mainTex:SetTexCoord(0.09, 1, 0, 1)

		PageF.footTex = PageF:CreateTexture(nil, "BORDER")
		PageF.footTex:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated.png")
		PageF.footTex:SetSize(frameWidth, 48)
		PageF.footTex:SetPoint("BOTTOM")
		PageF.footTex:SetVertexColor(0.5, 0.5, 0.5, 1.0)

		-- Add close Button
		PageF.cb = CreateFrame("Button", nil, PageF, "UIPanelCloseButton")
		PageF.cb:SetSize(30, 30)
		PageF.cb:SetPoint("TOPRIGHT", 0, 0)

		-- Set panel position when shown
		PageF:SetScript("OnShow", function()
			PageF:ClearAllPoints()
			PageF:SetPoint(LeaSoundsLC["MainPanelA"], UIParent, LeaSoundsLC["MainPanelR"], LeaSoundsLC["MainPanelX"], LeaSoundsLC["MainPanelY"])
		end)

		-- Create help button
		local helpBtn = LeaSoundsLC:CreateButton("HelpButton", LeaSoundsLC["PageF"], "Help", "BOTTOMRIGHT", -10, 10, 25, "Searches can consist of up to 10 keywords.  Keywords prefixed with ! are excluded from search results.|n|nWhile a track is selected, you can press W and S to play the previous and next track, E to replay the currently selected track or Q to stop playback.|n|nHold SHIFT and click to print (left-click) or insert (right-click) the selected track details in chat.|n|nHold CONTROL and click to print (left-click) or insert (right-click) the selected track ID in chat.")
		helpBtn:SetPushedTextOffset(0, 0)

		-- Create checkboxes
		LeaSoundsLC:MakeCB("SoundMusic", "Music", 416, -276, "If checked, music will be shown in the listing.")
		LeaSoundsLC:MakeCB("SoundSFX", "SFX", 486, -276, "If checked, sound effects will be shown in the listing.")
		LeaSoundsLC:MakeCB("SoundUnknown", "Unknown", 486, -276, "If checked, unknown sound files will be shown in the listing.|n|nThese are typically newer sound files which do not have names yet.|n|nNote that some unknown sound files may not be currently playable.")

		-- Position checkboxes
		LeaSoundsCB["SoundUnknown"]:ClearAllPoints()
		LeaSoundsCB["SoundUnknown"]:SetPoint("RIGHT", LeaSoundsCB["HelpButton"], "LEFT", -76, 0)
		LeaSoundsCB["SoundSFX"]:ClearAllPoints()
		LeaSoundsCB["SoundSFX"]:SetPoint("RIGHT", LeaSoundsCB["SoundUnknown"], "LEFT", -35, 0)
		LeaSoundsCB["SoundMusic"]:ClearAllPoints()
		LeaSoundsCB["SoundMusic"]:SetPoint("RIGHT", LeaSoundsCB["SoundSFX"], "LEFT", -50, 0)

		-- Create locals
		local ListData, searchTable = {}, {}
		local scrollFrame, musicHandle, lastPlayed, playScroll, void
		local numButtons = 15

		-- Show list items
		local function UpdateList()
			-- Add headers to ListData if needed
			if not strfind(ListData[1], "|c") then
				tinsert(ListData, 1, "|cffffd800" .. L["Leatrix Sounds"] .. " " .. LeaSoundsLC["AddonVer"])
				tinsert(ListData, 2, "|cffffffaa{" .. #Leatrix_Sounds["Listing"] - 1 .. " " .. L["results"] .. "}")
				tinsert(ListData, 3, "|cffffffff")
				tinsert(ListData, 4, "|cffffd800" .. L["Sound Files"])
			end
			-- Update buttons
			local offset = max(0, floor(scrollFrame:GetVerticalScroll() + 0.5))
			for i, button in ipairs(scrollFrame.buttons) do
				local index = offset + i
				if index <= #ListData then
					-- Show track listing
					button:SetText(ListData[index])
					-- Set width of highlight texture
					if button:GetTextWidth() > frameWidth - 60 then
						button.t:SetSize(frameWidth - 60, 16)
					else
						button.t:SetSize(button:GetTextWidth(), 16)
					end
					-- Show the button
					button:Show()
					-- Hide highlight bar texture by default
					button.s:Hide()
					-- Hide highlight bar if the button is a heading
					if strfind(button:GetText(), "|c") then button.t:Hide() end
					-- Show last played track highlight bar texture
					if lastPlayed == button:GetText() then
						button.s:Show()
					end
					-- Set width of highlight bar
					if button:GetTextWidth() > frameWidth - 60 then
						button.s:SetSize(frameWidth - 60, 16)
					else
						button.s:SetSize(button:GetTextWidth(), 16)
					end
					-- Limit click to label width
					local bWidth = button:GetFontString():GetStringWidth() or 0
					if bWidth > frameWidth - 60 then bWidth = frameWidth - 60 end
					button:SetHitRectInsets(0, 454 - bWidth, 0, 0)
					-- Disable label click movement
					button:SetPushedTextOffset(0, 0)
					-- Disable word wrap and set width
					button:GetFontString():SetWidth(frameWidth - 60)
					button:GetFontString():SetWordWrap(false)
				else
					button:Hide()
				end
			end
			scrollFrame.child:SetSize(200, #ListData + (14*15) - 1) --++ LeaSoundsLC.NewPatch
		end

		-- Create scroll frame
		scrollFrame = CreateFrame("ScrollFrame", nil, LeaSoundsLC["PageF"], "ScrollFrameTemplate")
		scrollFrame:SetPoint("TOPLEFT", 0, -32)
		scrollFrame:SetPoint("BOTTOMRIGHT", -30, 52)
		scrollFrame:SetPanExtent(1)
		scrollFrame:SetScript("OnVerticalScroll", UpdateList)

		-- Create the scroll child
		scrollFrame.child = CreateFrame("Frame", nil, scrollFrame)
		scrollFrame:SetScrollChild(scrollFrame.child)

		-- Give scroll frame file level scope
		LeaSoundsLC.scrollFrame = scrollFrame

		-- Add stop button
		local stopBtn = LeaSoundsLC:CreateButton("StopPlaybackButton", LeaSoundsLC["PageF"], "Stop", "BOTTOMRIGHT", -16, 12, 25)
		stopBtn:Hide(); stopBtn:Show()
		LeaSoundsLC:LockItem(stopBtn, true)
		stopBtn:SetScript("OnClick", function()
			-- Close chat editbox
			local eBox = ChatEdit_ChooseBoxForSend()
			eBox:ClearFocus()
			-- Stop currently playing track
			if musicHandle then
				StopSound(musicHandle)
				musicHandle = nil
				playScroll = nil
			end
			-- Hide highlight bars
			lastPlayed = ""
			UpdateList()
			-- Lock button
			LeaSoundsLC:LockItem(stopBtn, true)
			-- Disable keyboard navigation
			PageF:EnableKeyboard(false)
		end)

		-- Create editbox for search
		local searchLabel = LeaSoundsLC:MakeTx(LeaSoundsLC["PageF"], "Search", 16, -278)
		searchLabel:ClearAllPoints()
		searchLabel:SetPoint("BOTTOMLEFT", 16, 17)

		local sBox = LeaSoundsLC:CreateEditBox("SearchBox", LeaSoundsLC["PageF"], 354, 100, "TOPLEFT", 101, -272)
		LeaSoundsCB["sBox"] = sBox
		sBox:ClearAllPoints()
		sBox:SetPoint("LEFT", searchLabel, "RIGHT", 16, 0)

		-- Reposition stop button so its next to the search box
		stopBtn:ClearAllPoints()
		stopBtn:SetPoint("LEFT", sBox, "RIGHT", 10, 0)

		-- Function to show search results
		local function ShowSearchResults()

			playScroll = nil

			-- Get unescaped editbox text
			local searchText = gsub(strlower(sBox:GetText()), '(['..("%^$().[]*+-?"):gsub("(.)", "%%%1")..'])', "%%%1")
			local trackCount = #Leatrix_Sounds["Listing"]

			-- Wipe the track listing
			wipe(ListData)

			-- Set headings
			ListData[1] = "|cffffd800" .. L["Leatrix Sounds"] .. " " .. LeaSoundsLC["AddonVer"]
			if searchText == "" then
				ListData = Leatrix_Sounds["Listing"]
				UpdateList()
			else
				ListData[2] = ""
			end
			ListData[3] = "|cffffffff"
			ListData[4] = "|cffffd800" .. L["Sound Files"]

			-- Traverse music listing and populate ListData
			if searchText ~= "" then
				local word1, word2, word3, word4, word5, word6, word7, word8, word9, word10 = strsplit(" ", (strtrim(searchText):gsub("%s+", " ")))
				local word1sub, word2sub, word3sub, word4sub, word5sub, word6sub, word7sub, word8sub, word9sub, word10sub = word1 and word1:sub(1,1), word2 and word2:sub(1,1), word3 and word3:sub(1,1), word4 and word4:sub(1,1), word5 and word5:sub(1,1), word6 and word6:sub(1,1), word7 and word7:sub(1,1), word8 and word8:sub(1,1), word9 and word9:sub(1,1), word10 and word10:sub(1,1)
				for k = 1, trackCount do
					local v = strlower(Leatrix_Sounds["Listing"][k])
					if strfind(v, "#") then
						if word1 == "!" or word1 ~= "" and (word1sub ~= "!" and strfind(v, word1)) or (word1sub == "!" and not strfind(v, word1:sub(2))) then
							if not word2 or word2 == "!" or word2 ~= "" and (word2sub ~= "!" and strfind(v, word2)) or (word2sub == "!" and not strfind(v, word2:sub(2))) then
								if not word3 or word3 == "!" or word3 ~= "" and (word3sub ~= "!" and strfind(v, word3)) or (word3sub == "!" and not strfind(v, word3:sub(2))) then
									if not word4 or word4 == "!" or word4 ~= "" and (word4sub ~= "!" and strfind(v, word4)) or (word4sub == "!" and not strfind(v, word4:sub(2))) then
										if not word5 or word5 == "!" or word5 ~= "" and (word5sub ~= "!" and strfind(v, word5)) or (word5sub == "!" and not strfind(v, word5:sub(2))) then
											if not word6 or word6 == "!" or word6 ~= "" and (word6sub ~= "!" and strfind(v, word6)) or (word6sub == "!" and not strfind(v, word6:sub(2))) then
												if not word7 or word7 == "!" or word7 ~= "" and (word7sub ~= "!" and strfind(v, word7)) or (word7sub == "!" and not strfind(v, word7:sub(2))) then
													if not word8 or word8 == "!" or word8 ~= "" and (word8sub ~= "!" and strfind(v, word8)) or (word8sub == "!" and not strfind(v, word8:sub(2))) then
														if not word9 or word9 == "!" or word9 ~= "" and (word9sub ~= "!" and strfind(v, word9)) or (word9sub == "!" and not strfind(v, word9:sub(2))) then
															if not word10 or word10 == "!" or word10 ~= "" and (word10sub ~= "!" and strfind(v, word10)) or (word10sub == "!" and not strfind(v, word10:sub(2))) then
																-- Show track
																tinsert(ListData, Leatrix_Sounds["Listing"][k])
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
				-- Set results tag
				if #ListData == 5 then
					ListData[2] = "|cffffffaa{" .. #ListData - 4 .. " " .. L["result"] .. "}"
				else
					ListData[2] = "|cffffffaa{" .. #ListData - 4 .. " " .. L["results"] .. "}"
				end
			end
			-- Show message if no results found
			if #ListData == 4 then
				ListData[4] = "|cffffd800" .. L["No search results found"]
				ListData[5] = "|cffffffff" .. L["So I guess there's nothing to see here."]
			end
			-- Show message if no sound categories are checked
			if LeaSoundsLC["SoundMusic"] == "Off" and LeaSoundsLC["SoundSFX"] == "Off" and LeaSoundsLC["SoundUnknown"] == "Off" then
				ListData[4] = "|cffffd800" .. L["Oops!"]
				ListData[5] = "|cffffffff" .. L["You need to select at least one sound category."]
			end
			-- Refresh the track listing
			UpdateList()
			-- Set track listing to top
			scrollFrame:SetVerticalScroll(0)
		end

		-- When editbox is changed by user, show search results
		sBox:HookScript("OnTextChanged", function(self, userInput)
			if userInput then
				if LeaSoundsLC.Timer then LeaSoundsLC.Timer:Cancel() end
				LeaSoundsLC.Timer = C_Timer.NewTimer(0.5, function()
					ListData = searchTable
					ShowSearchResults()
				end)
			end
		end)

		-- When enter key is pressed, show search results
		sBox:HookScript("OnEnterPressed", function()
			ListData = searchTable
			ShowSearchResults()
		end)

		-- Function to show sound listing
		local function SetListingFunc()

			wipe(Leatrix_Sounds["Listing"])

			-- Populate sound table
			if LeaSoundsLC["SoundMusic"] == "On" then
				for i = 1, #Leatrix_Sounds["MP3"] do
					tinsert(Leatrix_Sounds["Listing"], Leatrix_Sounds["MP3"][i])
				end
			end
			if LeaSoundsLC["SoundSFX"] == "On" then
				for i = 1, #Leatrix_Sounds["OGG"] do
					tinsert(Leatrix_Sounds["Listing"], Leatrix_Sounds["OGG"][i])
				end
			end

			-- Sort the table
			table.sort(Leatrix_Sounds["Listing"])

			-- Add the unknown table (done after the sort because it is already sorted)
			if LeaSoundsLC["SoundUnknown"] == "On" then
				for i = 1, #Leatrix_Sounds["EXT"] do
					tinsert(Leatrix_Sounds["Listing"], Leatrix_Sounds["EXT"][i])
				end
			end

			-- Show headings if needed
			if LeaSoundsLC["SoundMusic"] == "Off" and LeaSoundsLC["SoundSFX"] == "Off" and LeaSoundsLC["SoundUnknown"] == "Off" then
				tinsert(Leatrix_Sounds["Listing"], "|cffffd800" .. L["Leatrix Sounds"] .. " " .. LeaSoundsLC["AddonVer"])
				tinsert(Leatrix_Sounds["Listing"], "|cffffffaa{" .. #Leatrix_Sounds["Listing"] - 1 .. " " .. L["results"] .. "}")
				tinsert(Leatrix_Sounds["Listing"], "|cffffffff")
				tinsert(Leatrix_Sounds["Listing"], "|cffffd800" .. L["Oops!"])
				tinsert(Leatrix_Sounds["Listing"], "|cffffffff" .. L["You need to select at least one sound category."])
			end

			-- If editbox is not empty, show search results
			if LeaSoundsCB["sBox"]:GetText() ~= "" then
				ListData = searchTable
				ShowSearchResults()
			end

			-- Clear editbox focus
			sBox:ClearFocus()

			-- Update listing buttons
			UpdateList()

			-- Set list to top and stop any playing track
			scrollFrame:SetVerticalScroll(0)
			stopBtn:Click()

		end

		LeaSoundsCB["SoundMusic"]:HookScript("OnClick", function() playScroll = nil; C_Timer.After(0.001, SetListingFunc) end)
		LeaSoundsCB["SoundSFX"]:HookScript("OnClick", function() playScroll = nil; C_Timer.After(0.001, SetListingFunc) end)
		LeaSoundsCB["SoundUnknown"]:HookScript("OnClick", function() playScroll = nil; C_Timer.After(0.001, SetListingFunc) end)

		-- Create list items
		scrollFrame.buttons = {}
		for i = 1, numButtons do
			scrollFrame.buttons[i] = CreateFrame("Button", nil, LeaSoundsLC["PageF"])
			local button = scrollFrame.buttons[i]

			button:SetSize(470 - 14, 16)
			button:SetNormalFontObject("GameFontHighlightLeft")
			button:SetPoint("TOPLEFT", 16, -6+ -(i - 1) * 16 - 8)

			-- Create highlight bar texture
			button.t = button:CreateTexture(nil, "BACKGROUND")
			button.t:SetPoint("TOPLEFT", button, 0, 0)
			button.t:SetSize(516, 16)

			button.t:SetColorTexture(0.3, 0.3, 0.0, 0.8)
			button.t:SetAlpha(0.7)
			button.t:Hide()

			-- Create last playing highlight bar texture
			button.s = button:CreateTexture(nil, "BACKGROUND")
			button.s:SetPoint("TOPLEFT", button, 0, 0)
			button.s:SetSize(516, 16)

			button.s:SetColorTexture(0.3, 0.4, 0.00, 0.6)
			button.s:Hide()

			button:SetScript("OnEnter", function()
				-- Highlight links only
				if not string.match(button:GetText() or "", "|c") then
					button.t:Show()
				end
			end)

			button:SetScript("OnLeave", function()
				button.t:Hide()
			end)

			button:RegisterForClicks("LeftButtonUp", "RightButtonUp")

			-- Click handler for track
			button:SetScript("OnClick", function(self, btn)
				if btn == "LeftButton" then
					-- Remove focus from search box
					sBox:ClearFocus()
					-- Get clicked track text
					local item = self:GetText()
					-- Do nothing if its a blank line or informational heading
					if not item or strfind(item, "|c") then return end
					if strfind(item, "#") then
						-- Print track name in chat if shift is held
						if IsShiftKeyDown() and not IsControlKeyDown() then
							PageF:EnableKeyboard(false)
							DEFAULT_CHAT_FRAME:AddMessage(item)
							return
						end
						-- Print ID in chat if control is held
						if IsControlKeyDown() and not IsShiftKeyDown() then
							local file, soundID = item:match("([^,]+)%#([^,]+)")
							if soundID then
								PageF:EnableKeyboard(false)
								DEFAULT_CHAT_FRAME:AddMessage(soundID)
								return
							end
						end
						-- Close editbox
						local eBox = ChatEdit_ChooseBoxForSend()
						eBox:ClearFocus()
						-- Enable sound if required
						if GetCVar("Sound_EnableAllSound") == "0" then SetCVar("Sound_EnableAllSound", "1") end
						-- Disable music if it's currently enabled
						if GetCVar("Sound_EnableMusic") == "1" then	SetCVar("Sound_EnableMusic", "0") end
						-- Enable the stop button
						LeaSoundsLC:LockItem(stopBtn, false)
						-- Store the track we are about to play
						lastPlayed = item
						-- Stop currently playing track if there is one
						if musicHandle then StopSound(musicHandle) end
						-- Play track
						local file, soundID = item:match("([^,]+)%#([^,]+)")
						if strfind(file, ".mp3") or strfind(file, ".ogg") then
							-- Play sound file
							void, musicHandle = PlaySoundFile(soundID, "Master")
						end
						-- Remember scroll frame position
						playScroll = LeaSoundsLC.scrollFrame.ScrollBar:GetScrollPercentage()
						-- Show static highlight bar
						for index = 1, numButtons do
							local button = scrollFrame.buttons[index]
							local scanItem = button:GetText()
							if scanItem and scanItem == item then
								button.s:Show()
							else
								button.s:Hide()
							end
						end
						-- Enable keyboard navigation
						PageF:EnableKeyboard(true)
					end
				elseif btn == "RightButton" then
					-- Build sound ID search criteria in editbox
					if IsShiftKeyDown() and IsControlKeyDown() then
						local item = self:GetText()
						-- Do nothing if its a blank line or informational heading
						if not item or strfind(item, "|c") then return end
						if strfind(item, "#") then
							PageF:EnableKeyboard(false)
							local file, soundID = item:match("([^,]+)%#([^,]+)")
							local eBox = ChatEdit_ChooseBoxForSend()
							ChatEdit_ActivateChat(eBox)
							eBox:SetCursorPosition(strlen(eBox:GetText()) - 1)
							if eBox:GetText() == "" or not strfind(eBox:GetText(), "|;") then
								eBox:SetText("#" .. soundID .. "\"|;")
							else
								eBox:Insert("#" .. soundID .. "\"|")
							end
						end
						return
					end
					-- Print track name or ID in editbox
					if IsShiftKeyDown() or IsControlKeyDown() then
						-- Remove focus from search box
						sBox:ClearFocus()
						-- Get clicked track text
						local item = self:GetText()
						-- Do nothing if its a blank line or informational heading
						if not item or strfind(item, "|c") then return end
						if strfind(item, "#") then
							if IsShiftKeyDown() and not IsControlKeyDown() then
								-- Print track name in chat editbox and highlight it
								PageF:EnableKeyboard(false)
								local eBox = ChatEdit_ChooseBoxForSend()
								ChatEdit_ActivateChat(eBox)
								eBox:SetText(item)
								eBox:HighlightText()
							end
							if IsControlKeyDown() and not IsShiftKeyDown() then
								-- Print track name in chat editbox and highlight it
								local file, soundID = item:match("([^,]+)%#([^,]+)")
								if soundID then
									PageF:EnableKeyboard(false)
									local eBox = ChatEdit_ChooseBoxForSend()
									ChatEdit_ActivateChat(eBox)
									eBox:SetText(soundID)
									eBox:HighlightText()
								end
							end
						end
						return
					end
				end
			end)
		end

		-- Manage events
		LeaSoundsLC["PageF"]:RegisterEvent("PLAYER_LOGOUT")
		LeaSoundsLC["PageF"]:RegisterEvent("UI_SCALE_CHANGED")
		LeaSoundsLC["PageF"]:SetScript("OnEvent", function(self, event)
			if event == "PLAYER_LOGOUT" then
				-- Stop playing at reload or logout
				if musicHandle then
					StopSound(musicHandle)
				end
			elseif event == "UI_SCALE_CHANGED" then
				-- Refresh list
				UpdateList()
			end
		end)

		-- Show sound listing on startup
		ListData = Leatrix_Sounds["Listing"]
		SetListingFunc()

		-- Keyboard input
		-- hooksecurefunc("ChatEdit_ActivateChat", function()
			-- Disable hotkeys when chat editbox is activated
			-- PageF:EnableKeyboard(false)
		-- end)

		-- hooksecurefunc("ChatEdit_DeactivateChat", function()
			-- Enable hotkeys when chat editbox is deactivated
			-- PageF:EnableKeyboard(true)
		-- end)

		local jumpList = 15 -- Number of tracks for next and previous page
		PageF:EnableKeyboard(true)
		PageF:SetScript("OnKeyUp", function(self, key)

			-- Do nothing if CTRL,SHIFT or ALT is down
			if IsModifierKeyDown() then return end

			-- Close addon panel key
			if key == "ESCAPE" then
				PageF.cb:Click()
			end

			-- Stop playback key
			if key == "Q" then
				stopBtn:Click()
			end

			-- Set scroll frame to last played position
			if not playScroll then return end

			-- Get currently selected track
			local playingTrack = 0
			for i = 1, numButtons do
				if scrollFrame.buttons[i].s:IsShown() then
					playingTrack = i
				end
			end

			-- If playing track exists but is not visible, jump to playing track
			if playingTrack == 0 then
				scrollFrame.ScrollBar:SetScrollPercentage(playScroll)
				for i = 1, numButtons do
					if scrollFrame.buttons[i].s:IsShown() then
						playingTrack = i
					end
				end
			end

			-- Playback keys
			if playingTrack and playingTrack > 0 then

				if key == "E" then
					-- Replay currently selected track
					scrollFrame.buttons[playingTrack]:Click("LeftButton")
				end

				if key == "S" then
					-- If last track is selected, do nothing
					if scrollFrame.buttons[playingTrack]:GetText() == ListData[#ListData] then return end
					-- Play next track
					if playingTrack == 15 then
						-- To jump entire page (15 rows), use this and set StepInDirection and playingTrack to diff
						-- local diff = #ListData - (15 + max(0, floor(scrollFrame:GetVerticalScroll() + 0.5)))
						-- if diff > 15 then diff = 15 end
						LeaSoundsLC.scrollFrame.ScrollBar:ScrollStepInDirection(1)
						playingTrack = playingTrack - 1
						scrollFrame.buttons[playingTrack + 1]:Click("LeftButton")
					else
						scrollFrame.buttons[playingTrack + 1]:Click("LeftButton")
					end
				end

				if key == "W" then
					-- Play previous track
					if playingTrack == 1 then
						-- To jump entire page (15 rows), use this and set StepInDirection and playingTrack to diff
						-- local diff = (max(0, floor(scrollFrame:GetVerticalScroll() + 0.5)))
						-- if diff > 15 then diff = 15 end
						LeaSoundsLC.scrollFrame.ScrollBar:ScrollStepInDirection(-1)
						playingTrack = playingTrack + 1
						scrollFrame.buttons[playingTrack - 1]:Click("LeftButton")
					else
						scrollFrame.buttons[playingTrack - 1]:Click("LeftButton")
					end
				end

			end

		end)
		PageF:EnableKeyboard(false)

		-- Release memory
		LeaSoundsLC.Player = nil

	end

	----------------------------------------------------------------------
	-- L30: Events
	----------------------------------------------------------------------

	-- Create event frame
	local eventFrame = CreateFrame("FRAME")
	eventFrame:RegisterEvent("ADDON_LOADED")
	eventFrame:RegisterEvent("PLAYER_LOGIN")
	eventFrame:RegisterEvent("PLAYER_LOGOUT")
	eventFrame:SetScript("OnEvent", function(self, event, arg1)

		if event == "ADDON_LOADED" and arg1 == "Leatrix_Sounds" then
			-- Load settings or set defaults
			LeaSoundsLC:LoadVarAnc("MainPanelA", "CENTER")
			LeaSoundsLC:LoadVarAnc("MainPanelR", "CENTER")
			LeaSoundsLC:LoadVarNum("MainPanelX", 0, -5000, 5000)
			LeaSoundsLC:LoadVarNum("MainPanelY", 0, -5000, 5000)
			LeaSoundsLC:LoadVarChk("SoundMusic", "On")
			LeaSoundsLC:LoadVarChk("SoundSFX", "On")
			LeaSoundsLC:LoadVarChk("SoundUnknown", "On")

		elseif event == "PLAYER_LOGIN" then
			-- Run main function
			LeaSoundsLC:Player()

		elseif event == "PLAYER_LOGOUT" then
			-- Save settings
			LeaSoundsDB["MainPanelA"] = LeaSoundsLC["MainPanelA"]
			LeaSoundsDB["MainPanelR"] = LeaSoundsLC["MainPanelR"]
			LeaSoundsDB["MainPanelX"] = LeaSoundsLC["MainPanelX"]
			LeaSoundsDB["MainPanelY"] = LeaSoundsLC["MainPanelY"]
			LeaSoundsDB["SoundMusic"] = LeaSoundsLC["SoundMusic"]
			LeaSoundsDB["SoundSFX"] = LeaSoundsLC["SoundSFX"]
			LeaSoundsDB["SoundUnknown"] = LeaSoundsLC["SoundUnknown"]

		end

	end)

	----------------------------------------------------------------------
	-- L40: Commands
	----------------------------------------------------------------------

	-- Slash command function
	local function SlashFunc(str)
		local str = string.lower(str)
		if str and str ~= "" then
			-- Traverse parameters
			if str == "ver" then
				-- Print addon version
				LeaSoundsLC:Print("Leatrix Sounds " .. LeaSoundsLC["AddonVer"])
				return
			elseif str == "rsnd" then
				-- Restart the sound system
				if LeaSoundsCB["StopPlaybackButton"] then LeaSoundsCB["StopPlaybackButton"]:Click() end
				Sound_GameSystem_RestartSoundSystem()
				LeaSoundsLC:Print("Sound system restarted.")
				return
			elseif str == "reset" then
				-- Reset layout
				LeaSoundsLC["MainPanelA"], LeaSoundsLC["MainPanelR"], LeaSoundsLC["MainPanelX"], LeaSoundsLC["MainPanelY"] = "CENTER", "CENTER", 0, 0
				LeaSoundsLC["PageF"]:ClearAllPoints()
				LeaSoundsLC["PageF"]:SetPoint(LeaSoundsLC["MainPanelA"], UIParent, LeaSoundsLC["MainPanelR"], LeaSoundsLC["MainPanelX"], LeaSoundsLC["MainPanelY"])
				return
			elseif str == "wipe" then
				-- Wipe settings
				wipe(LeaSoundsDB)
				eventFrame:UnregisterAllEvents()
				ReloadUI()
			else
				-- Invalid command entered
				LeaSoundsLC:Print("Invalid command.")
				return
			end
		else
			-- Prevent panel from showing if a game options panel is showing
			if LeaSoundsLC.NewPatch then
				if ChatConfigFrame:IsShown() then return end
			else
				if InterfaceOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end
			end
			-- Prevent panel from showing if Blizzard Store is showing
			if StoreFrame and StoreFrame:GetAttribute("isshown") then return end
			-- Toggle the main panel
			if LeaSoundsLC["PageF"]:IsShown() then
				LeaSoundsLC["PageF"]:Hide()
			else
				LeaSoundsLC["PageF"]:Show()
			end
		end
	end

	-- Add slash commands
	_G.SLASH_Leatrix_Sounds1 = "/lts"
	_G.SLASH_Leatrix_Sounds2 = "/leasounds"

	SlashCmdList["Leatrix_Sounds"] = function(self)
		-- Run slash command function
		SlashFunc(self)
		-- Redirect tainted variables
		RunScript('ACTIVE_CHAT_EDIT_BOX = ACTIVE_CHAT_EDIT_BOX')
		RunScript('LAST_ACTIVE_CHAT_EDIT_BOX = LAST_ACTIVE_CHAT_EDIT_BOX')
	end

	----------------------------------------------------------------------
	-- Create panel in game options panel
	----------------------------------------------------------------------

	if LeaSoundsLC.NewPatch then

		local interPanel = CreateFrame("FRAME")
		interPanel.name = "Leatrix Sounds"

		local maintitle = LeaSoundsLC:MakeTx(interPanel, "Leatrix Sounds", 0, 0)
		maintitle:SetFont(maintitle:GetFont(), 72)
		maintitle:ClearAllPoints()
		maintitle:SetPoint("TOP", 0, -72)

		local expTitle = LeaSoundsLC:MakeTx(interPanel, "Cataclysm Classic", 0, 0)
		expTitle:SetFont(expTitle:GetFont(), 32)
		expTitle:ClearAllPoints()
		expTitle:SetPoint("TOP", 0, -152)

		local subTitle = LeaSoundsLC:MakeTx(interPanel, "www.leatrix.com", 0, 0)
		subTitle:SetFont(subTitle:GetFont(), 20)
		subTitle:ClearAllPoints()
		subTitle:SetPoint("BOTTOM", 0, 72)

		local slashTitle = LeaSoundsLC:MakeTx(interPanel, "/lts", 0, 0)
		slashTitle:SetFont(slashTitle:GetFont(), 72)
		slashTitle:ClearAllPoints()
		slashTitle:SetPoint("BOTTOM", subTitle, "TOP", 0, 40)
		slashTitle:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" then
				SlashCmdList["Leatrix_Sounds"]("")
			end
		end)
		slashTitle:SetScript("OnEnter", function()
			slashTitle.r,  slashTitle.g, slashTitle.b = slashTitle:GetTextColor()
			slashTitle:SetTextColor(1, 1, 0)
		end)
		slashTitle:SetScript("OnLeave", function()
			slashTitle:SetTextColor(slashTitle.r, slashTitle.g, slashTitle.b)
		end)

		local pTex = interPanel:CreateTexture(nil, "BACKGROUND")
		pTex:SetAllPoints()
		pTex:SetTexture("Interface\\GLUES\\Models\\UI_MainMenu\\swordgradient2")
		pTex:SetAlpha(0.2)
		pTex:SetTexCoord(0, 1, 1, 0)

		local category = Settings.RegisterCanvasLayoutCategory(interPanel, "Leatrix Sounds")
		Settings.RegisterAddOnCategory(category)

	else

		local interPanel = CreateFrame("FRAME")
		interPanel.name = "Leatrix Sounds"

		local maintitle = LeaSoundsLC:MakeTx(interPanel, "Leatrix Sounds", 0, 0)
		maintitle:SetFont(maintitle:GetFont(), 72)
		maintitle:ClearAllPoints()
		maintitle:SetPoint("TOP", 0, -72)

		local expTitle = LeaSoundsLC:MakeTx(interPanel, "Cataclysm Classic", 0, 0)
		expTitle:SetFont(expTitle:GetFont(), 32)
		expTitle:ClearAllPoints()
		expTitle:SetPoint("TOP", 0, -152)

		local subTitle = LeaSoundsLC:MakeTx(interPanel, "www.leatrix.com", 0, 0)
		subTitle:SetFont(subTitle:GetFont(), 20)
		subTitle:ClearAllPoints()
		subTitle:SetPoint("BOTTOM", 0, 72)

		local slashTitle = LeaSoundsLC:MakeTx(interPanel, "/lts", 0, 0)
		slashTitle:SetFont(slashTitle:GetFont(), 72)
		slashTitle:ClearAllPoints()
		slashTitle:SetPoint("BOTTOM", subTitle, "TOP", 0, 40)
		slashTitle:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" then
				SlashCmdList["Leatrix_Sounds"]("")
			end
		end)
		slashTitle:SetScript("OnEnter", function()
			slashTitle.r,  slashTitle.g, slashTitle.b = slashTitle:GetTextColor()
			slashTitle:SetTextColor(1, 1, 0)
		end)
		slashTitle:SetScript("OnLeave", function()
			slashTitle:SetTextColor(slashTitle.r, slashTitle.g, slashTitle.b)
		end)

		local pTex = interPanel:CreateTexture(nil, "BACKGROUND")
		pTex:SetAllPoints()
		pTex:SetTexture("Interface\\GLUES\\Models\\UI_MainMenu\\swordgradient2")
		pTex:SetAlpha(0.2)
		pTex:SetTexCoord(0, 1, 1, 0)

		InterfaceOptions_AddCategory(interPanel)

	end
