# A Calendar Widget for the Awesome Window Manager

A simple widget that can be attached to the `textclock` to show a monthly
calendar.

This widget is a simple wrapper around:

- the `cal` utility if you are using **4.0** <= Awesome < **4.2**
- `awful.widget.calendar_popup` if you are using Awesome >= **4.2**

Once the widget is attached to the `textclock` (or any other widget really),
moving the mouse over the `textclock` will show a monthly calendar. The mouse
scroll down/up and left/right buttons will show the previous/next month
respectively.

Note that when using the `cal` utility, the widget has a very simple look, but
is quite quick to load.

# Installation

0. If you are using Awesome **4.x** less than **4.2**, ensure that the `cal`
   utility from `util-linux` is available.
1. Copy `calendar.lua` in your `~/.config/awesome/` folder (e.g. by cloning
   this repository)
3. Restart Awesome (e.g. press `modkey + Control` or run `awesome-client
   "awesome.restart()"` from a terminal).

# Usage

For **Awesome 4.x**, add the following to your `~/.config/awesome/rc.lua`:

``` lua
-- If you just copied the file in ~/.config/awesome
local calendar = require("calendar")

-- If you cloned the repo as a submodule in
-- ~/.config/awesome/external/calendar
-- local calendar = require("external.calendar")

-- more configuration here

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()
calendar:register(mytextclock)

-- more configuration follows
```

# Contributing

If you have ideas about how to make this better, feel free to open an issue or
submit a pull request.
