
	----------------------------------------------------------------------
	-- Leatrix Sounds 9.0.15 (9th February 2021)
	----------------------------------------------------------------------

	--  Create global table
	_G.LeaSoundsDB = _G.LeaSoundsDB or {}

	-- Create local tables
	local LeaSoundsLC, LeaSoundsCB, LeaDropList = {}, {}, {}

	-- Version
	LeaSoundsLC["AddonVer"] = "9.0.15"

	-- Get locale table
	local void, Leatrix_Sounds = ...
	local L = Leatrix_Sounds.L

	-- Check Wow version is valid
	do
		local gameversion, gamebuild, gamedate, gametocversion = GetBuildInfo()
		if gametocversion and gametocversion < 19999 then
			-- Game client is Wow Classic
			C_Timer.After(2, function()
				print(L["LEATRIX SOUNDS: WRONG VERSION INSTALLED!"])
			end)
			return
		end
		if gametocversion and gametocversion > 90000 then
			LeaSoundsLC.SL = true
			LeaSoundsLC.BackdropTemplate = "BackdropTemplate"
		end
	end

	----------------------------------------------------------------------
	--	L00: Leatrix SOUNDS
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

	-- Show tooltips for configuration buttons and dropdown menus
	function LeaSoundsLC:ShowTooltip()
		GameTooltip:SetOwner(self, "ANCHOR_NONE")
		local parent = LeaSoundsLC["PageF"]
		local pscale = parent:GetEffectiveScale()
		local gscale = UIParent:GetEffectiveScale()
		local tscale = GameTooltip:GetEffectiveScale()
		local gap = ((UIParent:GetRight() * gscale) - (LeaSoundsLC["PageF"]:GetRight() * pscale))
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
		eb.f = CreateFrame("FRAME", nil, eb, LeaSoundsLC.BackdropTemplate)
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
		if Cbox.f:GetWidth() > 50 then
			Cbox.f:SetWidth(50)
		end

		-- Set checkbox click width
		if Cbox.f:GetStringWidth() > 50 then
			Cbox:SetHitRectInsets(0, -40, 0, 0)
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

	-- Create a dropdown menu (using custom function to avoid taint)
	function LeaSoundsLC:CreateDropDown(ddname, label, parent, width, anchor, x, y, items, tip)

		-- Add the dropdown name to a table
		tinsert(LeaDropList, ddname)

		-- Populate variable with item list
		LeaSoundsLC[ddname.."Table"] = items

		-- Create outer frame
		local frame = CreateFrame("FRAME", nil, parent); frame:SetWidth(width); frame:SetHeight(42); frame:SetPoint("BOTTOMLEFT", parent, anchor, x, y);

		-- Create dropdown inside outer frame
		local dd = CreateFrame("Frame", nil, frame); dd:SetPoint("BOTTOMLEFT", -16, -8); dd:SetPoint("BOTTOMRIGHT", 15, -4); dd:SetHeight(32);

		-- Create dropdown textures
		local lt = dd:CreateTexture(nil, "ARTWORK"); lt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); lt:SetTexCoord(0, 0.1953125, 0, 1); lt:SetPoint("TOPLEFT", dd, 0, 17); lt:SetWidth(25); lt:SetHeight(64); 
		local rt = dd:CreateTexture(nil, "BORDER"); rt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); rt:SetTexCoord(0.8046875, 1, 0, 1); rt:SetPoint("TOPRIGHT", dd, 0, 17); rt:SetWidth(25); rt:SetHeight(64); 
		local mt = dd:CreateTexture(nil, "BORDER"); mt:SetTexture("Interface\\Glues\\CharacterCreate\\CharacterCreate-LabelFrame"); mt:SetTexCoord(0.1953125, 0.8046875, 0, 1); mt:SetPoint("LEFT", lt, "RIGHT"); mt:SetPoint("RIGHT", rt, "LEFT"); mt:SetHeight(64);

		-- Create dropdown label
		local lf = dd:CreateFontString(nil, "OVERLAY", "GameFontNormal"); lf:SetPoint("TOPLEFT", frame, 0, 0); lf:SetPoint("TOPRIGHT", frame, -5, 0); lf:SetJustifyH("LEFT"); lf:SetText(L[label])
	
		-- Create dropdown placeholder for value (set it using OnShow)
		local value = dd:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		LeaSoundsLC[ddname.."Value"] = value
		value:SetPoint("LEFT", lt, 26, 2); value:SetPoint("RIGHT", rt, -43, 0); value:SetJustifyH("LEFT")
		dd:SetScript("OnShow", function() value:SetText(LeaSoundsLC[ddname.."Table"][LeaSoundsLC[ddname]]) end)

		-- Create dropdown button (clicking it opens the dropdown list)
		local dbtn = CreateFrame("Button", nil, dd)
		LeaSoundsCB["ListButton"..ddname] = dbtn
		dbtn:SetPoint("TOPRIGHT", rt, -16, -18); dbtn:SetWidth(24); dbtn:SetHeight(24)
		dbtn:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up"); dbtn:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down"); dbtn:SetDisabledTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled"); dbtn:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight"); dbtn:GetHighlightTexture():SetBlendMode("ADD")
		dbtn.tiptext = tip; dbtn:SetScript("OnEnter", LeaSoundsLC.ShowTooltip)
		dbtn:SetScript("OnLeave", GameTooltip_Hide)

		-- Create dropdown list
		local ddlist =  CreateFrame("Frame", nil, frame, LeaSoundsLC.BackdropTemplate)
		LeaSoundsCB["ListFrame"..ddname] = ddlist
		ddlist:SetPoint("TOP",0, -42)
		ddlist:SetWidth(frame:GetWidth())
		ddlist:SetHeight((#items * 17) + 17 + 17)
		ddlist:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", tile = false, tileSize = 0, edgeSize = 32, insets = { left = 4, right = 4, top = 4, bottom = 4}})
		ddlist:Hide()

		-- Hide list if parent is closed
		parent:HookScript("OnHide", function() ddlist:Hide() end)

		-- Create checkmark (it marks the currently selected item)
		local ddlistchk = CreateFrame("FRAME", nil, ddlist)
		ddlistchk:SetHeight(16); ddlistchk:SetWidth(16);
		ddlistchk.t = ddlistchk:CreateTexture(nil, "ARTWORK"); ddlistchk.t:SetAllPoints(); ddlistchk.t:SetTexture("Interface\\Common\\UI-DropDownRadioChecks"); ddlistchk.t:SetTexCoord(0, 0.5, 0.5, 1.0);

		-- Create dropdown list items
		for k, v in pairs(items) do

			local dditem = CreateFrame("Button", nil, LeaSoundsCB["ListFrame"..ddname])
			LeaSoundsCB["Drop"..ddname..k] = dditem;
			dditem:Show();
			dditem:SetWidth(ddlist:GetWidth()-22)
			dditem:SetHeight(20)
			dditem:SetPoint("TOPLEFT", 12, -k*16)

			dditem.f = dditem:CreateFontString(nil, 'ARTWORK', 'GameFontHighlight'); 
			dditem.f:SetPoint('LEFT', 16, 0)
			dditem.f:SetText(items[k])

			dditem.t = dditem:CreateTexture(nil, "BACKGROUND")
			dditem.t:SetAllPoints()
			dditem.t:SetColorTexture(0.3, 0.3, 0.00, 0.8)
			dditem.t:Hide();

			dditem:SetScript("OnEnter", function() dditem.t:Show() end)
			dditem:SetScript("OnLeave", function() dditem.t:Hide() end)
			dditem:SetScript("OnClick", function()
				LeaSoundsLC[ddname] = k
				value:SetText(LeaSoundsLC[ddname.."Table"][k])
				ddlist:Hide(); -- Must be last in click handler as other functions hook it
			end)

			-- Show list when button is clicked
			dbtn:SetScript("OnClick", function()
				-- Show the dropdown
				if ddlist:IsShown() then ddlist:Hide() else 
					ddlist:Show();
					ddlistchk:SetPoint("TOPLEFT",10,select(5,LeaSoundsCB["Drop"..ddname..LeaSoundsLC[ddname]]:GetPoint()))
					ddlistchk:Show();
				end;
				-- Hide all other dropdowns except the one we're dealing with
				for void,v in pairs(LeaDropList) do
					if v ~= ddname then
						LeaSoundsCB["ListFrame"..v]:Hide();
					end
				end
			end)

			-- Expand the clickable area of the button to include the entire menu width
			dbtn:SetHitRectInsets(-width+28, 0, 0, 0);

		end

		return frame
		
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
		local helpBtn = LeaSoundsLC:CreateButton("HelpButton", LeaSoundsLC["PageF"], "Help", "BOTTOMRIGHT", -10, 10, 25, "Searches can consist of up to 10 keywords.  Keywords prefixed with ! are excluded from search results.|n|nWhile a track is selected, you can press W and S to play the previous and next track, E to replay the currently selected track or Q to stop playback.|n|nHold SHIFT and click to print (left-click) or insert (right-click) the selected track details in chat.|n|nHold CTRL and click to print (left-click) or insert (right-click) a WoW.tools link for the selected track in chat.")
		helpBtn:SetPushedTextOffset(0, 0)

		-- Create checkboxes
		LeaSoundsLC:MakeCB("SoundMusic", "Music", 416, -276, "If checked, music will be shown in the listing.")
		LeaSoundsLC:MakeCB("SoundSFX", "SFX", 486, -276, "If checked, sound effects will be shown in the listing.")

		-- Position checkboxes
		LeaSoundsCB["SoundSFX"]:ClearAllPoints()
		LeaSoundsCB["SoundSFX"]:SetPoint("RIGHT", LeaSoundsCB["HelpButton"], "LEFT", -50, 0)
		LeaSoundsCB["SoundMusic"]:ClearAllPoints()
		LeaSoundsCB["SoundMusic"]:SetPoint("RIGHT", LeaSoundsCB["SoundSFX"], "LEFT", -50, 0)

		-- Create dropdown menu for sound source
		LeaSoundsLC:CreateDropDown("SoundSource", "", PageF, 146, "TOPLEFT", 426, -296, {L["Sound Files"], L["Sound Kits"]}, "You can choose to show sound files or sound kits in the listing.|n|nSound files are MP3 and OGG files.  Sound kits are containers for one or more sound files.|n|nIf you are looking for a file ID to be used with MuteSoundFile, choose Sound Files.|n|nYou can right-click the dropdown menu to toggle between Sound Files and Sound Kits.")

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
				if LeaSoundsLC["SoundSource"] == 1 then
					tinsert(ListData, 4, "|cffffd800" .. L["Sound Files"])
				else
					tinsert(ListData, 4, "|cffffd800" .. L["Sound Kits"])
				end
			end
			-- Update buttons
			FauxScrollFrame_Update(scrollFrame, #ListData, numButtons, 16)
			for index = 1, numButtons do
				local offset = index + FauxScrollFrame_GetOffset(scrollFrame)
				local button = scrollFrame.buttons[index]
				button.index = offset
				if offset <= #ListData then
					-- Show track listing
					button:SetText(ListData[offset])
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
		end

		-- Create scroll frame
		scrollFrame = CreateFrame("ScrollFrame", "LeaSoundsScrollFrame", LeaSoundsLC["PageF"], "FauxScrollFrameTemplate")
		scrollFrame:SetPoint("TOPLEFT", 0, -32)
		scrollFrame:SetPoint("BOTTOMRIGHT", -30, 52)
		scrollFrame:SetScript("OnVerticalScroll", function(self, offset)
			FauxScrollFrame_OnVerticalScroll(self, offset, 16, UpdateList)
		end)

		-- Give scroll frame file level scope
		LeaSoundsLC.scrollFrame = scrollFrame

		-- Add stop button
		local stopBtn = LeaSoundsLC:CreateButton("StopPlaybackButton", LeaSoundsLC["PageF"], "Stop", "BOTTOMRIGHT", -16, 12, 25)
		stopBtn:Hide(); stopBtn:Show()
		LeaSoundsLC:LockItem(stopBtn, true)
		stopBtn:SetScript("OnClick", function()
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
		end)

		-- Create editbox for search
		local searchLabel = LeaSoundsLC:MakeTx(LeaSoundsLC["PageF"], "Search", 16, -278)
		searchLabel:ClearAllPoints()
		searchLabel:SetPoint("BOTTOMLEFT", 16, 17)

		local sBox = LeaSoundsLC:CreateEditBox("SearchBox", LeaSoundsLC["PageF"], 266, 10, "TOPLEFT", 101, -272)
		LeaSoundsCB["sBox"] = sBox
		sBox:SetMaxLetters(100)
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
			if LeaSoundsLC["SoundSource"] == 1 then
				ListData[4] = "|cffffd800" .. L["Sound Files"]
			else
				ListData[4] = "|cffffd800" .. L["Sound Kits"]
			end

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
			if LeaSoundsLC["SoundMusic"] == "Off" and LeaSoundsLC["SoundSFX"] == "Off" then
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
			if LeaSoundsLC["SoundSource"] == 1 then
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
			elseif LeaSoundsLC["SoundSource"] == 2 then
				if LeaSoundsLC["SoundMusic"] == "On" then
					for i = 1, #Leatrix_Sounds["Music"] do
						tinsert(Leatrix_Sounds["Listing"], Leatrix_Sounds["Music"][i])
					end
				end
				if LeaSoundsLC["SoundSFX"] == "On" then
					for i = 1, #Leatrix_Sounds["SFX"] do
						tinsert(Leatrix_Sounds["Listing"], Leatrix_Sounds["SFX"][i])
					end
				end
			end
			-- Sort the table
			table.sort(Leatrix_Sounds["Listing"])
			-- Show headings if needed
			if LeaSoundsLC["SoundMusic"] == "Off" and LeaSoundsLC["SoundSFX"] == "Off" then
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
		end

		LeaSoundsCB["SoundMusic"]:HookScript("OnClick", function() playScroll = nil; C_Timer.After(0.001, SetListingFunc) end)
		LeaSoundsCB["SoundSFX"]:HookScript("OnClick", function() playScroll = nil; C_Timer.After(0.001, SetListingFunc) end)
		LeaSoundsCB["ListFrameSoundSource"]:HookScript("OnHide", function() playScroll = nil; C_Timer.After(0.001, SetListingFunc) end)
		LeaSoundsCB["ListButtonSoundSource"]:HookScript("OnMouseDown", function(self, btn)
			if btn == "RightButton" then
				if LeaSoundsLC["SoundSource"] == 1 then
					LeaSoundsLC["SoundSource"] = 2
					LeaSoundsLC["SoundSourceValue"]:SetText(L["Sound Kits"])
				else
					LeaSoundsLC["SoundSource"] = 1
					LeaSoundsLC["SoundSourceValue"]:SetText(L["Sound Files"])
				end
				LeaSoundsCB["ListFrameSoundSource"]:Show()
				LeaSoundsCB["ListFrameSoundSource"]:Hide()
			end
		end)

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
							DEFAULT_CHAT_FRAME:AddMessage(item)
							return
						end
						-- Print WoW.tools link in chat if control is held
						if IsControlKeyDown() and not IsShiftKeyDown() then
							local file, soundID = item:match("([^,]+)%#([^,]+)")
							if strfind(file, ".mp3") or strfind(file, ".ogg") then
								DEFAULT_CHAT_FRAME:AddMessage("https://wow.tools/files/#search=^" .. soundID .. "$")
							else
								DEFAULT_CHAT_FRAME:AddMessage("https://wow.tools/files/#search=skit:" .. soundID)
							end
							return
						end
						-- Enable sound if required
						if GetCVar("Sound_EnableAllSound") == "0" then SetCVar("Sound_EnableAllSound", "1") end
						-- Enable dialog sounds if required
						if GetCVar("Sound_EnableDialog") == "0" then SetCVar("Sound_EnableDialog", "1") end
						-- Set dialog sound to maximum if required
						if GetCVar("Sound_DialogVolume") ~= "1" then SetCVar("Sound_DialogVolume", "1") end
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
							void, musicHandle = PlaySoundFile(soundID, "Master")
						else
							void, musicHandle = PlaySound(soundID, "Master", false, true)
						end
						-- Remember scroll frame position
						playScroll = LeaSoundsLC.scrollFrame:GetVerticalScroll()
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
					end
				elseif btn == "RightButton" then
					-- Print track name in editbox
					if IsShiftKeyDown() and not IsControlKeyDown() then
						-- Remove focus from search box
						sBox:ClearFocus()
						-- Get clicked track text
						local item = self:GetText()
						-- Do nothing if its a blank line or informational heading
						if not item or strfind(item, "|c") then return end
						if strfind(item, "#") then
							-- Print track name in chat editbox and highlight it
							local eBox = ChatEdit_ChooseBoxForSend()
							ChatEdit_ActivateChat(eBox)
							eBox:SetText(item)
							eBox:HighlightText()
						end
					end
					-- Print wow.tools link in editbox
					if IsControlKeyDown() and not IsShiftKeyDown() then
						-- Remove focus from search box
						sBox:ClearFocus()
						-- Get clicked track text
						local item = self:GetText()
						-- Do nothing if its a blank line or informational heading
						if not item or strfind(item, "|c") then return end
						if strfind(item, "#") then
							-- Print track name in chat editbox and highlight it
							local file, soundID = item:match("([^,]+)%#([^,]+)")
							local eBox = ChatEdit_ChooseBoxForSend()
							ChatEdit_ActivateChat(eBox)
							if strfind(file, ".mp3") or strfind(file, ".ogg") then
								eBox:SetText("https://wow.tools/files/#search=^" .. soundID .. "$")
							else
								eBox:SetText("https://wow.tools/files/#search=skit:" .. soundID)
							end
							eBox:HighlightText()
						end
					end
				end
			end)
		end

		-- Delete the global scroll frame pointer
		_G.LeaSoundsScrollFrame = nil

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
		hooksecurefunc("ChatEdit_ActivateChat", function()
			-- Disable hotkeys when chat editbox is activated
			PageF:EnableKeyboard(false)
		end)

		hooksecurefunc("ChatEdit_DeactivateChat", function()
			-- Enable hotkeys when chat editbox is deactivated
			PageF:EnableKeyboard(true)
		end)

		PageF:EnableKeyboard(true)
		PageF:SetScript("OnKeyUp", function(self, key) 

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
			scrollFrame:SetVerticalScroll(playScroll)

			-- Get currently selected sound kit
			local playingTrack = 0
			for i = 1, numButtons do
				if scrollFrame.buttons[i].s:IsShown() then
					playingTrack = i
				end
			end

			-- Sound kit playback keys
			if playingTrack and playingTrack > 0 then

				if key == "E" then
					-- Replay currently selected sound kit
					scrollFrame.buttons[playingTrack]:Click("LeftButton")
				end

				if key == "S" then
					-- If last track is selected, do nothing
					if scrollFrame.buttons[playingTrack]:GetText() == ListData[#ListData] then return end

					-- Scroll forwards if last visible track is selected with more tracks available
					if playingTrack == 15 and #ListData > numButtons then
						LeaSoundsScrollFrameScrollBarScrollDownButton:Click()
						playingTrack = playingTrack - 6
					end

					-- Play next sound kit
					scrollFrame.buttons[playingTrack + 1]:Click("LeftButton")
				end

				if key == "W" then
					-- Play previous sound kit
					if playingTrack == 1 then
						LeaSoundsScrollFrameScrollBarScrollUpButton:Click()
						playingTrack = playingTrack + 6
					end
					scrollFrame.buttons[playingTrack - 1]:Click("LeftButton")
				end

			end

		end)

		-- Set keyboard when stop button status changes and on startup
		stopBtn:HookScript("OnEnable", function() PageF:SetPropagateKeyboardInput(false) end)
		stopBtn:HookScript("OnDisable", function() PageF:SetPropagateKeyboardInput(true) end)
		PageF:SetPropagateKeyboardInput(true)

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
			LeaSoundsLC:LoadVarNum("SoundSource", 1, 1, 2)

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
			LeaSoundsDB["SoundSource"] = LeaSoundsLC["SoundSource"]

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
			if InterfaceOptionsFrame:IsShown() or VideoOptionsFrame:IsShown() or ChatConfigFrame:IsShown() then return end
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

	do

		local interPanel = CreateFrame("FRAME")
		interPanel.name = "Leatrix Sounds"

		local maintitle = LeaSoundsLC:MakeTx(interPanel, "Leatrix Sounds", 0, 0)
		maintitle:SetFont(maintitle:GetFont(), 72)
		maintitle:ClearAllPoints()
		maintitle:SetPoint("TOP", 0, -72)

		local subTitle = LeaSoundsLC:MakeTx(interPanel, "curseforge.com/wow/addons/leatrix-sounds", 0, 0)
		subTitle:SetFont(subTitle:GetFont(), 20)
		subTitle:ClearAllPoints()
		subTitle:SetPoint("BOTTOM", 0, 72)

		local slashTitle = LeaSoundsLC:MakeTx(interPanel, "/lts", 0, 0)
		slashTitle:SetFont(slashTitle:GetFont(), 72)
		slashTitle:ClearAllPoints()
		slashTitle:SetPoint("BOTTOM", subTitle, "TOP", 0, 40)

		local pTex = interPanel:CreateTexture(nil, "BACKGROUND")
		pTex:SetAllPoints()
		pTex:SetTexture("Interface\\GLUES\\Models\\UI_MainMenu\\swordgradient2")
		pTex:SetAlpha(0.2)
		pTex:SetTexCoord(0, 1, 1, 0)

		InterfaceOptions_AddCategory(interPanel)

	end
