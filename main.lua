--
-- @file
-- Porting comming php functions into lua.
--

PHP = {}

--
-- Round a number to the precision specified.
--
-- @see http://php.net/manual/en/function.round.php
--
function PHP.round(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

--
-- count()
--
function PHP.count(table)
  local count = 0
  if type(table) == "table" then
    for _ in pairs(table) do count = count + 1 end
  end
  return count
end

--
-- print_r()
--
-- The returned table (array) will be 1 based, not 0 based.
--
-- @see http://php.net/manual/en/function.print-r.php
--
function PHP.print_r(t, return_t)
  local tableList = {}
  function table_r (t, name, indent, full)
    local id = not full and name
        or type(name)~="number" and tostring(name) or '['..name..']'
    local tag = indent .. id .. ' = '
    local out = {}	-- result
    if type(t) == "table" then
      if tableList[t] ~= nil then table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')
      else
        tableList[t]= full and (full .. '.' .. id) or id
        if next(t) then -- Table not empty
          table.insert(out, tag .. '{')
          for key,value in pairs(t) do
            table.insert(out,table_r(value,key,indent .. '    ',tableList[t]))
          end
          table.insert(out,indent .. '}')
        else table.insert(out,tag .. '{}') end
      end
    else
      local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)
      table.insert(out, tag .. val)
    end
    return table.concat(out, '\n')
  end
  local result = table_r(t,name or 'Value',indent or '')
  if (return_t) then
    return result
  end
  print(result)
end

--
-- explode()
--
-- @see http://php.net/manual/en/function.explode.php
-- @see http://richard.warburton.it
--
function PHP.explode(div, str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end
