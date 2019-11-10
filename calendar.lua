--[[

  Copyright 2017 Stefano Mazzucco <stefano AT curso DOT re>

  This program is free software: you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free Software
  Foundation, either version 3 of the License, or (at your option) any later
  version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public License along with
  this program.  If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.

]]

--[[ A simple tooltip that shows the calendar that can be attached to a widget.

  Supported Awesome Version >= 4.2

  Remember to `require` the widget **after** `beautiful.init` to ensure that
  the widget's style matches the theme.  ]]

local os = os
local string = string
local tonumber = tonumber

local awesome = awesome -- luacheck: ignore
local awful = require("awful")

local calendar

calendar = awful.widget.calendar_popup.month({position="tr"})

function calendar:register(widget)
  widget:connect_signal(
    "mouse::enter",
    function ()
      self:toggle()
  end)
  widget:connect_signal(
    "mouse::leave",
    function ()
      self:toggle()
  end)
  widget:buttons(awful.util.table.join(
                   awful.button({}, 1, function ()
                       self:call_calendar(-1)
                   end),
                   awful.button({}, 4, function ()
                       self:call_calendar(-1)
                   end),
                   awful.button({}, 2, function ()
                       self:call_calendar(0)
                   end),
                   awful.button({}, 3, function ()
                       self:call_calendar(1)
                   end),
                   awful.button({}, 5, function ()
                       self:call_calendar(1)
                   end)
  ))
end

return calendar
