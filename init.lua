-- A variable for the Hyper Mode
local k = hs.hotkey.modal.new({}, 'F17')

local cmd_opt_ctrl_shift_keys = {
	['c'] = true,
	['d'] = true,
	['f'] = true,
	['g'] = true,
	['m'] = true,
	['n'] = true,
	['s'] = true,
	['t'] = true,
	['v'] = true,
	['z'] = true,
	['space'] = true,
  ['delete'] = true,
}

local get_direction = {
	['h'] = 'left',
	['j'] = 'down',
	['k'] = 'up',
	['l'] = 'right'
}

local cmd_shift_keys = {
	['a'] = true,
	['['] = true,
	[']'] = true,
}

-- sends a key event with all modifiers
-- bool -> string -> void -> side effect
local hyper = function(isdown)
  return function(key, mods)
    return function()
      k.triggered = true
      local event
		  if get_direction[key] ~= nil then
        event = hs.eventtap.event.newKeyEvent( mods, get_direction[key], isdown)
      elseif cmd_shift_keys[key] then
        event = hs.eventtap.event.newKeyEvent( {'cmd', 'shift'}, key, isdown)
      elseif key == 'delete' then
        event = hs.eventtap.event.newKeyEvent( {'alt'}, 'delete', isdown)
      else
        event = hs.eventtap.event.newKeyEvent( {'cmd', 'alt', 'shift', 'ctrl'}, key, isdown)
      end
      event:post()
    end
  end
end

local hyperDown = hyper(true)
local hyperUp = hyper(false)

-- actually bind a key
local hyperBind = function(key)
  k:bind({}, key, msg, hyperDown(key, {}), hyperUp(key, {}), nil)
  if get_direction[key] ~= nil then
    local modifier_types = {{'alt'}, {'shift'}, {'cmd'}, {'alt','shift'}, {'cmd','shift'}}
    for i, mods in ipairs(modifier_types) do k:bind(mods, key, msg, hyperDown(key, mods), hyperUp(key, mods), nil) end
  end
end

-- bind all the keys in the huge keys table
local combined_keys = {}
for k,v in pairs(cmd_opt_ctrl_shift_keys) do table.insert(combined_keys, k) end
for k,v in pairs(cmd_shift_keys) do table.insert(combined_keys, k) end
for k,v in pairs(get_direction) do table.insert(combined_keys, k) end

for index, key in pairs(combined_keys) do hyperBind(key) end

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
local pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
local releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
local f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
