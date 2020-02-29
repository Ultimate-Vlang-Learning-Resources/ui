// Copyright (c) 2020 Alexander Medvednikov. All rights reserved.
// Use of this source code is governed by a GPL license
// that can be found in the LICENSE file.
module ui

import gx

const (
	sw_height = 20
	sw_width = 40
	sw_dot_size = 16
	sw_open_bg_color = gx.rgb(19, 206, 102)
	sw_close_bg_color = gx.rgb(220, 223, 230)
)

type SwitchClickFn fn(voidptr, voidptr)

pub struct Switch {
pub mut:
	idx        int
	height     int
	width      int
	x          int
	y          int
	parent     ILayouter
	is_focused bool
	open bool
	ui         &UI
	onclick    SwitchClickFn
}

pub struct SwitchConfig {
	onclick SwitchClickFn
	open bool
}

fn (s mut Switch) init(parent ILayouter){
	s.parent = parent
	ui := parent.get_ui()
	s.ui = ui
	mut subscriber := parent.get_subscriber()
	subscriber.subscribe_method(events.on_click, sw_click, s)
}

pub fn switcher(c SwitchConfig) &Switch {
	mut sw := &Switch{
		height: sw_height
		width: sw_width
		open:c.open
		onclick: c.onclick
	}
	return sw
}

fn (b mut Switch) set_pos(x, y int) {
	b.x = x
	b.y = y
}

fn (b mut Switch) size() (int, int) {
	return b.width, b.height
}

fn (b mut Switch) propose_size(w, h int) (int, int) {
	return b.width, b.height
}

fn (b mut Switch) draw() {
	padding := (b.height-sw_dot_size)/2
	if b.open {
	    b.ui.gg.draw_rect(b.x, b.y, b.width, b.height, sw_open_bg_color)
		b.ui.gg.draw_rect(b.x - padding + b.width - sw_dot_size , b.y + padding, sw_dot_size, sw_dot_size, gx.white)
	}else{
	    b.ui.gg.draw_rect(b.x, b.y, b.width, b.height, sw_close_bg_color)
	    b.ui.gg.draw_rect(b.x + padding, b.y + padding, sw_dot_size, sw_dot_size, gx.white)
	}
}

fn (t &Switch) point_inside(x, y f64) bool {
	return x >= t.x && x <= t.x + t.width && y >= t.y && y <= t.y + t.height
}

fn sw_click(b mut Switch, e &MouseEvent, w &ui.Window) {
	if e.action == 0 {
		b.open = !b.open
		if b.onclick != 0 {
			b.onclick(w.user_ptr, b)
		}
	}
}

fn (b mut Switch) focus() {
	b.is_focused = true
}

fn (b mut Switch) unfocus() {
	b.is_focused = false
}

fn (t &Switch) is_focused() bool {
	return t.is_focused
}
