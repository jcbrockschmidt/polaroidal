highscores = {}

highscores.saveFile = "highscores.dat"
highscores.scoreCount = 10
highscores.data = {}
highscores.data["Challenge"] = {}
highscores.data["1 minute"] = {}
highscores.data["5 minutes"] = {}
highscores.data["15 minutes"] = {}
highscores.data["Casual"] = {}

function highscores.insert(section, score)
   if not highscores.data[section] then
      print("ERROR: cannot record highscores for '"..section.."'")
      return false
   end
   for k, num in ipairs(highscores.data[section]) do
      if score > num then
	 table.insert(highscores.data[section], k, score)
	 -- Avoid overflow
	 highscores.data[section][highscores.scoreCount+1] = nil
	 return
      end
   end
   if #highscores.data[section] < highscores.scoreCount then
      table.insert(highscores.data[section], score)
      print(section, #highscores.data[section])
   end
end

function highscores.printData()
   for sect, scores in pairs(highscores.data) do
      print(sect..":")
      for k, num in ipairs(scores) do
	 print("\t"..k..": ", num)
      end
   end
end

function highscores.readData()
   if not love.filesystem.exists(highscores.saveFile) then
      print("Inexistent")
      return false
   end
   local file, err = love.filesystem.newFile(highscores.saveFile, "r")
   if not file then
      print(err)
      return false
   end
   local dataStr = file:read()
   file:close()
   
   local newData = {}
   local curHeader
   for line in dataStr:gmatch("[^\n]+") do
      local first = line:sub(1,1)
      if first == ":" then
	 if #line == 1 then
	    print("ERROR: highscores file is corrupt")
	    return false
	 end
	 curHeader = line:sub(2)
	 newData[curHeader] = {}
      elseif not curHeader then
	 print("ERROR: highscores file is corrupt")
	 return false
      else
	 local num = tonumber(line)
	 if not num then
	    print("ERROR: highscores file is corrupt")
	    return false
	 end
	 table.insert(newData[curHeader], num)
      end
   end
   highscores.data = newData
   return true
end

function highscores.writeData()
   local data = ""
   for section_k, section_data in pairs(highscores.data) do
      data = data .. ':' .. section_k .. "\n"
      for _, score in ipairs(section_data) do
	 data = data .. score .. "\n"
      end
   end
   local file = love.filesystem.newFile(highscores.saveFile, "w")
   if not file then
      return false
   end
   file:write(data)
   file:close()
   return true
end
