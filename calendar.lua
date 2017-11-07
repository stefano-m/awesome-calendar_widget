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

  Supported Awesome Version: 4.x

  If used with Awesome Version < 4.2 it requires the `cal` program from
  `util-linux`, otherwise it will use the nicer awful.widget.calendar_popup
  Remember to `require` the widget **after** `beautiful.init` to ensure that
  the widget's style matches the theme.  ]]

local os = os
local string = string
local tonumber = tonumber

local awesome = awesome -- luacheck: ignore
local awful = require("awful")

local calendar

if awful.widget.calendar_popup then
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

else

  calendar = awful.tooltip({})

  local cached_date = {
    day = tonumber(os.date("%d")),
    month = tonumber(os.date("%m")),
    year = tonumber(os.date("%Y"))
  }

  function calendar:update()
    local cmd = string.format(
      "cal --color=never -m %s %s %s",
      cached_date.day, cached_date.month, cached_date.year)

    awful.spawn.easy_async(
      cmd,
      function (stdout, stderr, _, exitcode)
        if exitcode == 0  then
          self:set_markup(
            string.format(
              '<span font_desc="monospace">%s</span>',
              stdout))
        else
          self:set_text(
            string.format(
              'An error occurred while calling "%s":\n\n%s',
              cmd,
              stderr))
        end
    end)

  end

  local function this_month(cal)
    cached_date = {day = tonumber(os.date("%d")),
                   month = tonumber(os.date("%m")),
                   year = tonumber(os.date("%Y"))}
    cal:update()
  end

  local function next_month(cal)
    local nm = cached_date.month + 1
    if nm > 12 then
      cached_date.month = 1
      cached_date.year = cached_date.year + 1
    else
      cached_date.month = nm
    end
    cal:update()
  end

  local function prev_month(cal)
    local nm = cached_date.month - 1
    if nm == 0 then
      cached_date.month = 12
      cached_date.year = cached_date.year - 1
    else
      cached_date.month = nm
    end
    cal:update()
  end

  function calendar:register(widget)
    self:add_to_object(widget)
    widget:connect_signal(
      "mouse::enter",
      function ()
        this_month(self)
    end)
    widget:buttons(awful.util.table.join(
                     awful.button({}, 1, function ()
                         next_month(self)
                     end),
                     awful.button({}, 4, function ()
                         next_month(self)
                     end),
                     awful.button({}, 2, function ()
                         this_month(self)
                     end),
                     awful.button({}, 3, function ()
                         prev_month(self)
                     end),
                     awful.button({}, 5, function ()
                         prev_month(self)
                     end)
    ))
  end

end

return calendar
