--[[

Babbler is random name generator with simple phonetic rules 


  --self.pool = loadfile('data/cumbria_fells.lua')
  --self.pool = self.name_pool()



]]

class 'Babbler'

-------------------------------------------------------------------------------

function Babbler:__init(pool)
  print("Babbler:__init")
  print("pool",pool)
  rprint(pool)
  
  -- table, pool of words 
  self.pool = pool
  
  -- table, generated names (to avoid duplicates)  
  self.generated_names = {}
  
end

-------------------------------------------------------------------------------
-- @return string (generated word)
--  or boolean,string if a problem occurred 

function Babbler:generate()
  print("Babbler:generate()",self)
  
  if (table.is_empty(self.pool)) then 
    return false, "No word pool has been defined"
  end
  
  return self:_generate()
  
end  

-------------------------------------------------------------------------------

function Babbler:reset()
  
  self.generated_names = {}
  
end

-------------------------------------------------------------------------------

function Babbler:_generate(str,iters,idx,once)

  local vowels = {"a","e","i","o","u","y"}

  if not str then
    str = ""
  end

  local function enough_iters()
    if once then
      return true
    else
      return ((iters > 1) and (iters < 4)) and true or false
    end
  end

  -- perhaps add a vowel at end? 
  local function maybe_repeat(str)
    if once then
      return str
    else
      once = true
      return (#str > 5) and str or str .. " " .. self:_generate(nil,nil,nil,once)
    end
  end

  -- perhaps add a vowel at end? 
  local function maybe_vowel(str)
    local dice = math.random(1,#vowels)
    if (math.random(0,1) == 0) then
      str = str .. vowels[dice]
    end
    return str
  end


  local function finalize(str)
    return maybe_repeat(maybe_vowel(str))
  end

  --Pick a random word
  local choice_idx = math.random(1,#self.pool)
  local choice = self.pool[choice_idx]

  -- Continue from index, or set to beginning
  if not idx or (idx > #choice) then
    idx = 1
  end

  --One character at a time
  local grab_consonants = false
  for k = idx,#choice do
    local chr = string.sub(choice,k,k)
    -- 1.continue until vowel
    local is_vowel = table.find(table.values(vowels),chr)
    if not is_vowel then
      str = ("%s%s"):format(str,chr)
    else -- is vowel  
      if grab_consonants then          
        -- 3. done grabbing consonants - switch or finish
        if not iters then
          iters = 1
        elseif enough_iters() then
          --print("*** 3. done grabbing consonants - finish",str)
          return finalize(str)
        end
        iters = iters + 1
        --print("*** 3. done grabbing consonants - switch",str,iters,k)
        return self:_generate(str,iters,k,once)
      end

      str = ("%s%s"):format(str,chr)
      -- 2. grab succeeding consonants 
      grab_consonants = true
      --print("*** 2. grab succeeding consonants ")
    end

  end

  if not iters then
    iters = 1
  end

  if enough_iters() then
    if table.find(self.generated_names,str) then
      -- avoid duplicate names (start over)
      --print("*** 5. duplicate name - start over")
      return self:_generate(nil,nil,nil,once)
    end
    --print("*** 4. done",str)
    table.insert(self.generated_names,str)
    return finalize(str)
  else
    if once then
      return str
    else
      --print("*** 4. not done yet - ",str,iters)
      return str .. self:_generate(str,iters,nil,once)
    end
  end

end
