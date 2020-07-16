testing_mode = true

whiteCounter_GUID = '407499'
whiteZone_GUID = '07bdc8'
greenCounter_GUID = '2570cb'
greenZone_GUID = '6c6cc9'
orangeCounter_GUID = 'e43cdb'
purpleCounter_GUID = '31429e'
purpleZone_GUID = '1adb96'
blueCounter_GUID = 'cb071d'
blueZone_GUID = '2f147f'
redCounter_GUID = '602429'
redZone_GUID = 'ff181b'
dealerToken_GUID = '1542ed'
tableCenterZone_GUID = '6ebea5'
tableZone_GUID = '7f1827'
cardDeck_GUID = '226b4e'

-- card7D_GUID = '51bc9f'
-- card8D_GUID = '3c82bf'
-- card9D_GUID = 'e22c59'
-- card10D_GUID = 'f22bfd'
-- cardJD_GUID = 'cf86ff'
-- cardQD_GUID = '9bd4aa'
-- cardKD_GUID = '358ff1'
-- cardAD_GUID = '54d245'
-- card7H_GUID = 'feb5a6'
-- card8H_GUID = '333a9b'
-- card9H_GUID = 'd793c3'
-- card10H_GUID = '08d307'
-- cardJH_GUID = 'f42d50'
-- cardQH_GUID = '156443'
-- cardKH_GUID = 'cdce58'
-- cardAH_GUID = '0c6b3e'
-- card7S_GUID = '01a149'
-- card8S_GUID = '5f6f9d'
-- card9S_GUID = '7c988b'
-- card10S_GUID = '5f5460'
-- cardJS_GUID = 'fe6df4'
-- cardQS_GUID = 'ac1fa3'
-- cardKS_GUID = 'd1bd4f'
-- cardAS_GUID = '16e86f'
-- card7C_GUID = 'c4999e'
-- card8C_GUID = 'bd7664'
-- card9C_GUID = '1ecb87'
-- card10C_GUID = '0ce5e9'
-- cardJC_GUID = '54454f'
-- cardQC_GUID = 'de367c'
-- cardKC_GUID = 'af6671'
-- cardAC_GUID = '9d49ee'
--
-- allDiamonds = {card7D_GUID, card8D_GUID, card9D_GUID, card10D_GUID, cardJD_GUID, cardQD_GUID, cardKD_GUID, cardAD_GUID}
-- allHearts = {card7H_GUID, card8H_GUID, card9H_GUID, card10H_GUID, cardJH_GUID, cardQH_GUID, cardKH_GUID, cardAH_GUID}
-- allSpades = {card7S_GUID, card8S_GUID, card9S_GUID, card10S_GUID, cardJS_GUID, cardQS_GUID, cardKS_GUID, cardAS_GUID}
-- allClubs = {card7C_GUID, card8C_GUID, card9C_GUID, card10C_GUID, cardJC_GUID, cardQC_GUID, cardKC_GUID, cardAC_GUID}
-- deckArray = {allDiamonds, allHearts, allSpades, allClubs}

function testing(str)
    if testing_mode then
        broadcastToAll(str)
    end
end

dealingScheme = {3, 2, 3}
clockwiseOrder = {
    White = {"Red", "Orange", "Green", "Blue", "Purple", "White"},
    Red = {"Orange", "Green", "Blue", "Purple", "White", "Red"},
    Orange = {"Green", "Blue", "Purple", "White", "Red", "Orange"},
    Green = {"Blue", "Purple", "White", "Red", "Orange", "Green"},
    Blue = {"Purple", "White", "Red", "Orange", "Green", "Blue"},
    Purple =  {"White", "Red", "Orange", "Green", "Blue", "Purple"} }
dealOrder = {}

bidValues = {"0", "2", "4", "10", "4", "6", "12", "24"}
bidNames = {"Pass", "Froque", "Froque Is", "Bettle", "Wedding", "Solo", "Solo Is", "SoloDu"}
callsMade = {}
colorsBid = {}

function onload(save_data_json)
    math.randomseed(os.time())
    cardDeck = getObjectFromGUID(cardDeck_GUID)
    tableCenterZone = getObjectFromGUID(tableCenterZone_GUID)
    tableZone = getObjectFromGUID(tableZone_GUID)
    dealerToken = getObjectFromGUID(dealerToken_GUID)
    whiteCounter = getObjectFromGUID(whiteCounter_GUID)
    whiteZone = getObjectFromGUID(whiteZone_GUID)
    greenCounter = getObjectFromGUID(greenCounter_GUID)
    greenZone = getObjectFromGUID(greenZone_GUID)
    orangeCounter = getObjectFromGUID(orangeCounter_GUID)
    orangeZone = getObjectFromGUID(orangeZone_GUID)
    purpleCounter = getObjectFromGUID(purpleCounter_GUID)
    purpleZone = getObjectFromGUID(purpleZone_GUID)
    blueCounter = getObjectFromGUID(blueCounter_GUID)
    blueZone = getObjectFromGUID(blueZone_GUID)
    redCounter = getObjectFromGUID(redCounter_GUID)
    redZone = getObjectFromGUID(redZone_GUID)

    addHotkey("Take Trick", takeTrickHotkeyEvent)
    addHotkey("Gather & Deal", gatherAndDealHotkeyEvent)
    addHotkey("Pass", makePassHotkeyEvent)
    addHotkey("Bid", makeBidHotkeyEvent)
    addHotkey("Froque", makeFroqueHotkeyEvent)
    addHotkey("FroqueIs", makeFroqueIsHotkeyEvent)
    addHotkey("Bettle", makeBettleHotkeyEvent)
    addHotkey("Wedding", makeWeddingHotkeyEvent)
    addHotkey("Solo", makeSoloHotkeyEvent)
    addHotkey("SoloIs", makeSoloIsHotkeyEvent)
    addHotkey("SoloDu", makeSoloDuHotkeyEvent)
    addHotkey("Call Spades", callSpadesHotkeyEvent)
    addHotkey("Call Hearts", callHeartsHotkeyEvent)
    addHotkey("Call Diamonds", callDiamondsHotkeyEvent)
    addHotkey("Call Clubs", callClubsHotkeyEvent)

    -- if save_data_json ~= "" then
    --     local save_data = JSON.decode(save_data_json)
    --     whiteScore = save_data.whiteScore
    --     greenScore = save_data.greenScore
    --     purpleScore = save_data.purpleScore
    --     orangeScore = save_data.orangeScore
    --     blueScore = save_data.blueScore
    --     redScore = save_data.redScore
    --     trickNumber = save_data.trickNumber
    --     biddingPlayerColor = save_data.biddingPlayerColor
    --     bid = save_data.bid
    --     bidValue = save_data.bidValue
    --     currentBidValue = save_data.currentBidValue
    --     partner = save_data.partner
    --     trumpSuit = save_data.trumpSuit
    -- else
        whiteScore = 0
        greenScore = 0
        purpleScore = 0
        orangeScore = 0
        blueScore = 0
        redScore = 0
        trickNumber = 0
        biddingPlayerColor = nil
        bid = nil
        bidValue = 0
        currentBidValue = nil
        currentBid = nil
        partner = nil
        trumpSuit = nil
    -- end

    whiteCounter.setValue(whiteScore)
    greenCounter.setValue(greenScore)
    purpleCounter.setValue(purpleScore)
    orangeCounter.setValue(orangeScore)
    blueCounter.setValue(blueScore)
    redCounter.setValue(redScore)

    -- hideButtons()
    -- suitsUIHide()
    -- callsUIHide()
    -- partnerUIHide()
end

-- function onUpdate()
--     if whiteScore ~= whiteCounter.getValue() then
--         whiteScore = whiteCounter.getValue()
--     elseif redScore ~= redCounter.getValue() then
--         redScore = redCounter.getValue()
--     elseif orangeScore ~= orangeCounter.getValue() then
--         orangeScore = orangeCounter.getValue()
--     elseif greenScore ~= greenCounter.getValue() then
--         greenScore = greenCounter.getValue()
--     elseif blueScore ~= blueCounter.getValue() then
--         blueScore = blueCounter.getValue()
--     elseif purpleScore ~= purpleCounter.getValue() then
--         purpleScore = purpleCounter.getValue()
--     else
--     end
-- end
--
-- function onSave()
--     local save_data = {
--         whiteScore = whiteScore, redScore = redScore,
--         purpleScore = purpleScore, greenScore = greenScore,
--         blueScore = blueScore, orangeScore = orangeScore,
--         trickNumber = trickNumber, trumpSuit = trumpSuit, biddingPlayerColor = biddingPlayerColor,
--         bid = bid, bidValue = bidValue, currentBidValue = currentBidValue,
--         partner = partner }
--     local save_data_json = JSON.encode(save_data)
--     -- save_data_json = "" -- Clear save data before publishing
--     return save_data_json
-- end

function moveDealerToken(playerColor)
    if playerColor == "White" then
        rotation = {0, 270, 0}
        position = {25, 1.00, -15}
        dealerToken.setName("Dealer is " .. playerColor)
    elseif playerColor == "Green" then
        rotation = {0, 90, 0}
        position = {-25, 1, 15}
        dealerToken.setName("Dealer is " .. playerColor)
    elseif playerColor == "Orange" then
        rotation = {0, 0, 0}
        position = {-25, 1, -9}
        dealerToken.setName("Dealer is " .. playerColor)
    elseif playerColor == "Purple" then
        rotation = {0, 180, 0}
        position = {25, 1, 9}
        dealerToken.setName("Dealer is " .. playerColor)
    elseif playerColor == "Blue" then
        rotation = {0, 90, 0}
        position = {5, 1, 15}
        dealerToken.setName("Dealer is " .. playerColor)
    elseif playerColor == "Red" then
        rotation = {0,270,0}
        position = {-5, 1, -15}
        dealerToken.setName("Dealer is " .. playerColor)
    else
        return nil
    end
    dealerToken.setRotationSmooth(rotation, false, false)
    dealerToken.setPositionSmooth(position, false, false)
end

function gatherAndDealHotkeyEvent(playerColor)
    gatherAndDealEvent(playerObjectFromColor(playerColor))
end

function gatherAndDealEvent(player)
    local seatedPlayers = getSeatedPlayers()
    if dealingPlayer ~= nil then
        printToColor(dealingPlayer.steam_name .. " is already dealing!", player.color, stringColorToRGB(player.color))
        return
    elseif #seatedPlayers < 4 and not testing_mode then
        broadcastToAll("Not enough players, need at least 4 to play.", player.color, stringColorToRGB(player.color))
    else
        broadcastToAll(player.steam_name .. " is dealing.", stringColorToRGB(player.color))
        dealingPlayer = player
        startLuaCoroutine(Global, "gatherAndDeal")
    end
end



function gatherAndDeal()
    biddingPlayerNumber = 0
    biddingPlayerColor = nil
    trickNumber = 1
    trickTakingPlayer = nil
    biddingPlayer = nil
    biddingPlayerColor = nil
    currentBidValue = nil
    callsMade = {}
    colorsBid = {}
    dealOrder = {}
    moveDealerToken(dealingPlayer.color)
    for index, obj in pairs(tableZone.getObjects()) do
        if (obj.tag == "Deck" or obj.tag == "Card") then
            obj.setRotation({0,math.random(0,359),0})
            obj.setPosition({math.random(-18,18),3,math.random(-13,13)})
            wait(0.05)
        end
    end
    endiddingPlayerNumber = 0
    biddingPlayerColor = nil
    trickNumber = 1
    trickTakingPlayer = nil
    biddingPlayer = nil
    biddingPlayerColor = nil
    currentBidValue = nil
    callsMade = {}
    colorsBid = {}
    dealOrder = {}
    moveDealerToken(dealingPlayer.color)

    wait(0.25)
    deck =group(tableZone.getObjects())
    wait(0.25)
    testing("cards grouped")
    --deck = nil
    deck = getDeck(tableZone)
    wait(0.25)
    if deck == nil then
      broadcastToAll("An error occurred. Deal again.")
      dealingPlayer = nil
      return 1
    end
    testing("deck found")
    deck.flip()
    testing("cards flipped")
    deck.shuffle()
    deck.shuffle()
    deck.shuffle()
    deck.shuffle()
    --shuffle(deck)
    testing("deck shuffled")
    dealOrder = determineDealOrder(dealingPlayer.color)
    testing(#dealOrder)
    testing("order determined")
    testing(#dealingScheme)
    for i=1,#dealingScheme do
        for v=1,#dealOrder do
            numCards = dealingScheme[i]
            testing("dealing " .. numCards .. " to " ..dealOrder[v])
            deck.deal(numCards, dealOrder[v])
            wait(0.15)
        end
    end
    dealingPlayer = nil
    return 1
end

function determineDealOrder()
    for i=1,#clockwiseOrder[dealingPlayer.color] do
        if #dealOrder == 4 then break end
        if testing_mode or Player[clockwiseOrder[dealingPlayer.color][i]].seated then
            dealOrder[#dealOrder+1]=clockwiseOrder[dealingPlayer.color][i]
            wait(0.15)
        end
    end
    return dealOrder
end

function getDeck(zone)
    for index, obj in pairs(zone.getObjects()) do
        if (obj.tag == "Deck" )  then
            return obj
        end
    end
    return nil
end

function sweepCards(zone)
  looseCards = {}
  for index, obj in ipairs(zone.getObjects()) do
      if (obj.tag == "Deck" or obj.tag == "Card") then
          looseCards[#looseCards+1] = obj
      end
  end
  testing("Sweeping cards complete")
  return looseCards
end

function takeTrickHotkeyEvent(playerColor)
    takeTrickEvent(playerObjectFromColor(playerColor))
end
function takeTrickEvent(player)
    if suitsUIVisible then return end
    if callsUIVisible then return end
    if trickTakingPlayer ~= nil then return end
    trickTakingPlayer = player
    if trickNumber == 0 then
        broadcastToColor("Cannot take tricks before dealing.", trickTakingPlayer.color, stringColorToRGB(player.color))
    elseif trickNumber > 8 then
        broadcastToAll("There have already been 8 tricks this hand.", trickTakingPlayer.color, stringColorToRGB(player.color))
    else
        looseCards = sweepCards(tableCenterZone)
        if #looseCards ~= 4 then
            broadcastToColor("Are you sure this is a trick? I found " .. #looseCards .. " card(s).", trickTakingPlayer.color, stringColorToRGB(player.color))
            trickTakingPlayer = nil
            return 1
        end
        startLuaCoroutine(Global, "takeTrick")
    end
end

function takeTrick()
    local playerColor = trickTakingPlayer.color
    looseCards = sweepCards(tableCenterZone)
    broadcastToAll(trickTakingPlayer.steam_name .. " takes the trick.", stringColorToRGB(trickTakingPlayer.color))
    group(looseCards)
    wait(0.5)
    local trick = getDeck(tableCenterZone)
    local positionOffset = trickNumber * 2.25
    if playerColor == "White" then
        rotation = {0, 0, 180}
        position = {24.5 - positionOffset, 1, -16}
    elseif playerColor == "Green" then
        rotation = {0, 180, 180}
        position = {-24.5 + positionOffset, 1, 16}
    elseif playerColor == "Orange" then
        rotation = {0, 90, 180}
        position = {-26, 1, -8 + positionOffset}
    elseif playerColor == "Purple" then
        rotation = {0, 270, 180}
        position = {26, 1, 8 - positionOffset}
    elseif playerColor == "Blue" then
        rotation = {0, 180, 180}
        position = {5.5 + positionOffset, 1, 16}
    elseif playerColor == "Red" then
        rotation = {0, 0, 180}
        position = {-5.5 - positionOffset, 1, -16}
    end
    trick.setRotationSmooth(rotation, false, false)
    trick.setPositionSmooth(position, false, false)
    trickNumber = trickNumber + 1
    trickTakingPlayer = nil
    return 1
end

function makeBidHotkeyEvent(playerColor)
    makeBidEvent(playerObjectFromColor(playerColor))
end

function makeBidEvent(player)
    if suitsUIVisible then return end
    if callsUIVisible then return end
    if partnerUIVisible then return end
    if biddingPlayerColor ~= nil then return end
    if trickNumber == 0 then
        broadcastToColor("Cannot pass or bid before dealing.", player.color, stringColorToRGB(player.color))
        biddingPlayerColor = nil
        return
    elseif trickNumber > 8 then
        broadcastToColor("There have already been 8 tricks this hand.", biddingPlayerColor, stringColorToRGB(player.color))
        biddingPlayerColor = nil
        return
    else
        -- checkValid(player)
        -- for v=1,1 do
         --     pass=bidNames[v]
        -- end
        -- if currentBidValue == pass then
            -- checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
        -- else
        -- if valid then
             -- callsUIShow(biddingPlayerColor)
             -- callsUISetAttribute("visibility", biddingPlayerColor)
        -- end
             -- checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
        -- end
        -- if bidIsValid == true then
        --     callsUIShow(biddingPlayerColor)
        --     callsUISetAttribute("visibility", biddingPlayerColor)
        -- end
        --     return
        -- end
        -- if currentBidValue ~= nil then
        --     currentBidValue = currentBidValue
            -- checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
        -- else
            -- getBid(checkCalls(currentBidValue))
            -- checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
        -- end
--
    end
    -- biddingPlayerColor = nil
    -- biddingPlayerName = nil
    -- currentBidValue = nil
    -- callsUIHide()
end
function checkValid(player)
    if #colorsBid == 0 then
        -- broadcastToAll(biddingPlayerName .. " calls " .. currentBidValue .. ".", stringColorToRGB(biddingPlayerColor))
        -- colorsBid[#colorsBid+1]=biddingPlayerColor
        -- callsMade[#callsMade+1]=currentBidValue
        -- biddingPlayerColor = nil
        -- biddingPlayerName = nil
        -- currentBidValue = nil
        -- callsUIHide()
        return true
    else
        -- determine if player has already bid
        found = false
        for i=1,#colorsBid do
            if biddingPlayerColor == colorsBid[i] then
                broadcastToColor(biddingPlayerName .. ", you have already recorded a bid.", biddingPlayerColor, stringColorToRGB(biddingPlayerColor))
                 -- biddingPlayerColor = nil
                 -- biddingPlayerName = nil
                 -- currentBidValue = nil
                 -- callsUIHide()
                found = true
                return false
            end
        end
        -- if found ~= true then
            -- player has not bid
            -- if bid is a pass, add it to the bids
            -- if currentBidValue == pass then
            --     broadcastToAll(biddingPlayerName .. " calls " .. currentBidValue .. ".", stringColorToRGB(biddingPlayerColor))
            --     colorsBid[#colorsBid+1]=biddingPlayerColor
            --     callsMade[#callsMade+1]=currentBidValue
            --     biddingPlayerColor = nil
            --     biddingPlayerName = nil
            --     currentBidValue = nil
            --     callsUIHide()
            --     return
            -- end
            -- otherwise, check if the bid is higher than all other bids
        --     bidValue = bidIndex(currentBidValue)
        --     for i=1,#callsMade do
        --         bid = bidIndex(callsMade[i])
        --         if bidValue <= bid then
        --             broadcastToColor(biddingPlayerName .. ", you must bid higher.", biddingPlayerColor, stringColorToRGB(biddingPlayerColor))
        --             biddingPlayerColor = nil
        --             biddingPlayerName = nil
        --             currentBidValue = nil
        --             callsUIHide()
        --             return
        --         end
        --     end
        --
        -- -- The bid is valid. Store it.
        -- broadcastToAll(biddingPlayerName .. " calls " .. currentBidValue .. ".", stringColorToRGB(biddingPlayerColor))
        -- colorsBid[#colorsBid+1]=biddingPlayerColor
        -- callsMade[#callsMade+1]=currentBidValue
        -- biddingPlayerColor = nil
        -- biddingPlayerName = nil
        -- currentBidValue = nil
        -- callsUIHide()
        -- end
    end
end

function checkCalls(player)
    for v=1,1 do
        pass=bidNames[v]
    end
    currentBid = bidnames[currentBidValue]
    printToAll("currentBid = " .. currentBid)
    if #colorsBid == 0 then
        broadcastToAll(biddingPlayerName .. " calls " .. currentBid .. ".", stringColorToRGB(biddingPlayerColor))
        colorsBid[#colorsBid+1]=biddingPlayerColor
        callsMade[#callsMade+1]=currentBid
        biddingPlayerColor = nil
        biddingPlayerName = nil
        currentBidValue = nil
        currentBid = nil
        callsUIHide()
        return true
    else
        -- determine if player has already bid
        found = false
        for i=1,#colorsBid do
             if biddingPlayerColor == colorsBid[i] then
                 broadcastToColor(biddingPlayerName .. ", you have already recorded a bid.", biddingPlayerColor, stringColorToRGB(biddingPlayerColor))
                 biddingPlayerColor = nil
                 biddingPlayerName = nil
                 currentBidValue = nil
                 currentBid = nil
                 callsUIHide()
                 found = true
                 return
             end
        end
        if found ~= true then
            -- player has not bid
            -- if bid is a pass, add it to the bids
            if currentBidValue == pass then
                broadcastToAll(biddingPlayerName .. " calls " .. currentBid .. ".", stringColorToRGB(biddingPlayerColor))
                colorsBid[#colorsBid+1]=biddingPlayerColor
                callsMade[#callsMade+1]=currentBid
                biddingPlayerColor = nil
                biddingPlayerName = nil
                currentBidValue = nil
                currentBid = nil
                callsUIHide()
                return
            end
            -- otherwise, check if the bid is higher than all other bids
            bidValue = bidIndex(currentBidValue)
            for i=1,#callsMade do
                bid = bidIndex(callsMade[i])
                if bidValue <= bid then
                    broadcastToColor(biddingPlayerName .. ", you must bid higher.", biddingPlayerColor, stringColorToRGB(biddingPlayerColor))
                    biddingPlayerColor = nil
                    biddingPlayerName = nil
                    currentBidValue = nil
                    currentBid = nil
                    callsUIHide()
                    return
                end
            end
                    -- The bid is valid. Store it.
        broadcastToAll(biddingPlayerName .. " calls " .. currentBid .. ".", stringColorToRGB(biddingPlayerColor))
        colorsBid[#colorsBid+1]=biddingPlayerColor
         callsMade[#callsMade+1]=currentBidValue
        biddingPlayerColor = nil
        biddingPlayerName = nil
        currentBidValue = nil
        currentBid = nil
        callsUIHide()
        end
    end
end

function bidIndex(value)
   for i=1,#bidNames,1 do
       if value == bidNames[i] then
          return i
       end
   end
   return nil -- this case should not happen
end

function callsUISetAttribute(attribute, value)
    UI.setAttribute("Froque", attribute, value)
    UI.setAttribute("FroqueIs", attribute, value)
    UI.setAttribute("Solo", attribute, value)
    UI.setAttribute("SoloIs", attribute, value)
    UI.setAttribute("Wedding", attribute, value)
    UI.setAttribute("Bettle", attribute, value)
    UI.setAttribute("SoloDu", attribute, value)
end
function callsUIShow(biddingPlayerColor)
    UI.show("Calls", biddingPlayerColor)
    UI.show("Froque", biddingPlayerColor)
    UI.show("FroqueIs", biddingPlayerColor)
    UI.show("Bettle", biddingPlayerColor)
    UI.show("Wedding", biddingPlayerColor)
    UI.show("Solo", biddingPlayerColor)
    UI.show("SoloIs", biddingPlayerColor)
    UI.show("SoloDu", biddingPlayerColor)
    callsUIVisible = true
end

function callsUIHide(biddingPlayerColor)
    UI.hide("Calls", biddingPlayerColor)
    UI.hide("Froque", biddingPlayerColor)
    UI.hide("FroqueIs", biddingPlayerColor)
    UI.hide("Bettle", biddingPlayerColor)
    UI.hide("Wedding", biddingPlayerColor)
    UI.hide("Solo", biddingPlayerColor)
    UI.hide("SoloIs", biddingPlayerColor)
    UI.hide("SoloDu", biddingPlayerColor)
    callsUIVisible = false
end

function makePassHotkeyEvent(playerColor)
    makePassEvent(playerObjectFromColor(playerColor))
end
function makePassEvent(player)
    if trickNumber == 0 then
        broadcastToColor("Cannot pass or bid before dealing.", player.color, stringColorToRGB(player.color))
        return
    elseif trickNumber > 8 then
       broadcastToColor("There have already been 8 tricks this hand.", biddingPlayerColor, stringColorToRGB(player.color))
       return
    else
        biddingPlayerColor = player.color
        biddingPlayerName = player.steam_name
        currentBidValue = 1
        UI.hide("Calls", biddingPlayerColor)
        checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
    end
    -- makeBidEvent(player, currentBidValue)
end

function makeFroqueHotkeyEvent(playerColor)
   makeFroqueEvent(playerObjectFromColor(playerColor))
end

function makeFroqueEvent(player)
    biddingPlayerColor = player.color
    biddingPlayerName = player.steam_name
    currentBidValue = 2
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
end

function makeFroqueIsHotkeyEvent(playerColor)
    makeFroqueIsEvent(playerObjectFromColor(playerColor))
end
function makeFroqueIsEvent(player)
    biddingPlayerColor = player.color
    biddingPlayerName = player.steam_name
    currentBidValue = 3
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
end
function makeBettleHotkeyEvent(playerColor)
    makeBettleEvent(playerObjectFromColor(playerColor))
end
function makeBettleEvent(player)
    biddingPlayerColor = player.color
    biddingPlayerName = player.steam_name
    currentBidValue = 4
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
end

function makeWeddingHotkeyEvent(playerColor)
     makeWeddingEvent(playerObjectFromColor(playerColor))
end

function makeWeddingEvent(player)
    biddingPlayerColor = player.color
    biddingPlayerName = player.steam_name
    currentBidValue = 5
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
end
function makeSoloHotkeyEvent(playerColor)
    makeSoloEvent(playerObjectFromColor(playerColor))
end

function makeSoloEvent(player)
    biddingPlayerColor = player.color
    biddingPlayerName = player.steam_name
    currentBidValue = 6
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
end
function makeSoloIsHotkeyEvent(playerColor)
    makeSoloIsEvent(playerObjectFromColor(playerColor))
end
function makeSoloIsEvent(player)
    biddingPlayerColor = player.color
    biddingPlayerName = player.steam_name
    currentBidValue = 7
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
end
function makeSoloDuHotkeyEvent(playerColor)
    makeSoloDuEvent(playerObjectFromColor(playerColor))
end
function makeSoloDuEvent(player)
    biddingPlayerColor = player.color
    biddingPlayerName = player.steam_name
    currentBidValue = 8
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
end
function callBid(player, currentBidValue)
    printToAll("callBid function")
    for i=1,#bidValues,currentBidValue do
        printToAll(currentBidValue .. " before")
        currentBidValue = bidValues[i]
        printToAll(currentBidValue .. " after")
    end
    checkCalls(biddingPlayerColor, biddingPlayerName, currentBidValue)
    --callsUIShow()
    -- showTrumpSuit(player.color, bid)
end

-- function partnerUISetAttribute(attribute, value)
--     UI.setAttribute("Ace", attribute, value)
--     UI.setAttribute("King", attribute, value)
-- end
-- function partnerUIShow()
--     UI.show("Partner")
--     partnerUIVisible = true
-- end
-- function partnerUIHide()
--     UI.hide("Partner")
--     partnerUIVisible = false
-- end

function callSuit(player, suit)
    broadcastToAll(player.steam_name .. " calls " .. suit .. ".", stringColorToRGB(player.color))
    suitsUIHide()
    showTrumpSuit(player.color, suit)
end
function callSpadesHotkeyEvent(playerColor)
    callSpadesEvent(playerObjectFromColor(playerColor))
end
function callHeartsHotkeyEvent(playerColor)
    callHeartsEvent(playerObjectFromColor(playerColor))
end
function callDiamondsHotkeyEvent(playerColor)
    callDiamondsEvent(playerObjectFromColor(playerColor))
end
function callClubsHotkeyEvent(playerColor)
    callClubsEvent(playerObjectFromColor(playerColor))
end

function callSpadesEvent(player)
     if suitsUIVisible == false then return end
     if biddingPlayerColor ~= player.color then return end
     callSuit(player, "Spades")
end
function callHeartsEvent(player)
     if suitsUIVisible == false then return end
     if biddingPlayerColor ~= player.color then return end
     callSuit(player, "Hearts")
end
function callDiamondsEvent(player)
     if suitsUIVisible == false then return end
     if biddingPlayerColor ~= player.color then return end
     callSuit(player, "Diamonds")
end
function callClubsEvent(player)
     if suitsUIVisible == false then return end
     if biddingPlayerColor ~= player.color then return end
     callSuit(player, "Clubs")
end

function showTrumpSuit(playerColor, suit)
     -- local buttonColor = colorTableToRGBAString(stringColorToRGB(playerColor))
     -- UI.setAttribute("TrumpSuit", "colors", buttonColor.."|"..buttonColor.."|"..buttonColor)
     -- UI.setAttribute("TrumpSuitImage", "image", suit)
     -- if suit == "heart" or suit == "diamond" then
     --     UI.setAttribute("TrumpSuitImage", "outline", "#000000FF")
     -- else
     --     UI.setAttribute("TrumpSuitImage", "outline", "#00000000")
     -- end
     -- UI.show("TrumpSuit")
     printToAll(showTrumpSuit)
end
function suitsUISetAttribute(attribute, value)
     UI.setAttribute("CallSpades", attribute, value)
     UI.setAttribute("CallHearts", attribute, value)
     UI.setAttribute("CallDiamonds", attribute, value)
     UI.setAttribute("CallClubs", attribute, value)
end
function suitsUIShow()
     UI.show("CallSpades")
     UI.show("CallHearts")
     UI.show("CallDiamonds")
     UI.show("CallClubs")
     suitsUIVisible = true
end
function suitsUIHide()
     UI.hide("CallSpades")
     UI.hide("CallHearts")
     UI.hide("CallDiamonds")
     UI.hide("CallClubs")
     suitsUIVisible = false
end

function addScoreEvent(zone)
     printToAll("addscore")
end

function getHandLocation(color)
     if color == "Green" then
         return handLocations_REF.green
     elseif color == "Blue" then
         return handLocations_REF.blue
     elseif color == "Purple" then
         return handLocations_REF.purple
     elseif color == "White" then
         return handLocations_REF.white
     elseif color == "Red" then
         return handLocations_REF.red
     elseif color == "Orange" then
         return handLocations_REF.orange
     end
end

function getColorValueFromPlayer(player_color)
     if player_color == "Green" then
         return {0.129,0.701,0.168}
     elseif player_color == "Blue" then
         return {0.118, 0.53, 1}
     elseif player_color == "Purple" then
         return {0.627, 0.125, 0.941}
     elseif player_color == "White" then
         return {1, 1, 1}
     elseif player_color == "Red" then
         return {0.856, 0.1, 0.094}
     elseif player_color == "Orange" then
         return {0.956, 0.392, 0.113}
     end
end

function hideButtons()
     UI.setAttribute("Pass", "visibility", "Black")
     UI.setAttribute("Bid", "visibility", "Black")
     UI.setAttribute("TakeTrick", "visibility", "Black")
end

function checkHand(player)
    local playerColor = player.color
    for i=1,#dealOrder do
        if playerColor == dealOrder[i] then return true end
    end
end

function colorTableToRGBAString(colorTable)
    local rgba = colorTable
    return "rgba("..rgba.r..","..rgba.g..","..rgba.b..","..rgba.a..")"
end

function flipCards(cards)
    for index, card in pairs(cards) do
        if not card.is_face_down then
           card.flip()
        end
    end
end

function shuffle(deck)
    for index=1,4 do
        deck.shuffle()
        wait(0.5)
    end
end

function wait(time)
  local start = os.time()
  repeat coroutine.yield(0) until os.time() > start + time
end
