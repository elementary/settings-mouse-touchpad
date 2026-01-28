/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 * SPDX-FileCopyrightText: 2011-2026 elementary, Inc. (https://elementary.io)
 */

public class MouseTouchpad.ClickingView : Switchboard.SettingsPage {
    public ClickingView () {
        Object (
            header: _("Behavior"),
            icon: new ThemedIcon ("mouse-touchpad-clicking"),
            title: _("Clicking")
        );
    }

    construct {
        show_end_title_buttons = true;

        var mouse_left = new Gtk.CheckButton () {
            child = new Gtk.Image.from_icon_name ("mouse-left-symbolic") {
                pixel_size = 32
            },
            /// TRANSLATORS: Used as "Primary Button: Left"
            tooltip_text = NC_("mouse-button", "Left")
        };
        mouse_left.add_css_class ("image-button");

        var mouse_right = new Gtk.CheckButton () {
            child = new Gtk.Image.from_icon_name ("mouse-right-symbolic") {
                pixel_size = 32
            },
            group = mouse_left,
            /// TRANSLATORS: Used as "Primary Button: Right";
            tooltip_text = NC_("mouse-button", "Right")
        };
        mouse_right.add_css_class ("image-button");

        var primary_button_switcher = new Granite.Box (HORIZONTAL, DOUBLE) {
            halign = START,
            margin_bottom = 12
        };

        if (Gtk.StateFlags.DIR_LTR in get_state_flags ()) {
            primary_button_switcher.append (mouse_left);
            primary_button_switcher.append (mouse_right);
        } else {
            primary_button_switcher.append (mouse_right);
            primary_button_switcher.append (mouse_left);
        }

        var primary_button_label = new Granite.HeaderLabel (_("Primary Button")) {
            mnemonic_widget = primary_button_switcher
        };

        var hold_switch = new Gtk.Switch () {
            halign = END,
            valign = CENTER
        };

        var hold_header = new Granite.HeaderLabel (_("Long-press Secondary Click")) {
            mnemonic_widget = hold_switch,
            secondary_text = _("Long-press and release the primary button to secondary click")
        };

        var hold_scale_adjustment = new Gtk.Adjustment (0, 0.5, 3, 0.1, 0.1, 0.1);

        var hold_scale = new Gtk.Scale (HORIZONTAL, hold_scale_adjustment) {
            draw_value = false,
            hexpand = true
        };
        hold_scale.add_mark (1.2, BOTTOM, null);

        var hold_spinbutton = new Gtk.SpinButton (hold_scale_adjustment, 1, 1) {
            width_chars = 10,
            valign = START
        };

        var hold_spin_box = new Gtk.Box (HORIZONTAL, 12) {
            margin_bottom = 12
        };
        hold_spin_box.append (hold_scale);
        hold_spin_box.append (hold_spinbutton);

        var double_click_speed_adjustment = new Gtk.Adjustment (400, 100, 1000, 0.1, 0.1, 0.1);

        var double_click_speed_scale = new Gtk.Scale (HORIZONTAL, double_click_speed_adjustment) {
            draw_value = false
        };
        double_click_speed_scale.add_mark (400, BOTTOM, null);

        var double_click_header = new Granite.HeaderLabel (_("Double-click Speed")) {
            mnemonic_widget = double_click_speed_scale,
            secondary_text = _("How quickly two clicks in a row will be treated as a double-click")
        };

        var dwell_click_switch = new Gtk.Switch () {
            halign = END,
            valign = CENTER
        };

        var dwell_click_header = new Granite.HeaderLabel (_("Dwell Click")) {
            mnemonic_widget = dwell_click_switch,
            secondary_text = _("Hold the pointer still to automatically click")
        };

        var dwell_click_adjustment = new Gtk.Adjustment (0, 0.5, 3, 0.1, 0.1, 0.1);

        var dwell_click_delay_scale = new Gtk.Scale (HORIZONTAL, dwell_click_adjustment) {
            draw_value = false,
            hexpand = true
        };
        dwell_click_delay_scale.add_mark (1.2, BOTTOM, null);

        var dwell_click_spinbutton = new Gtk.SpinButton (dwell_click_adjustment, 1, 1) {
            width_chars = 10,
            valign = START
        };

        var dwell_click_spin_box = new Gtk.Box (HORIZONTAL, 12) {
            margin_bottom = 12
        };
        dwell_click_spin_box.append (dwell_click_delay_scale);
        dwell_click_spin_box.append (dwell_click_spinbutton);

        var primary_paste_switch = new Gtk.Switch () {
            action_name = "clicking.gtk-enable-primary-paste",
            halign = END,
            valign = CENTER
        };

        var primary_paste_header = new Granite.HeaderLabel (_("Middle Click Paste")) {
            mnemonic_widget = primary_paste_switch,
            secondary_text = _("Middle or three-finger click on an input to paste selected text")
        };

        var content_area = new Gtk.Grid () {
            row_spacing = 6
        };

        content_area.attach (primary_button_label, 0, 0, 2);
        content_area.attach (primary_button_switcher, 0, 1, 2);

        content_area.attach (double_click_header, 0, 2, 2);
        content_area.attach (double_click_speed_scale, 0, 3, 2);

        content_area.attach (dwell_click_header, 0, 4);
        content_area.attach (dwell_click_switch, 1, 4);
        content_area.attach (dwell_click_spin_box, 0, 5, 2);

        content_area.attach (hold_header, 0, 6);
        content_area.attach (hold_switch, 1, 6);
        content_area.attach (hold_spin_box, 0, 7, 2);

        content_area.attach (primary_paste_header, 0, 8);
        content_area.attach (primary_paste_switch, 1, 8);

        child = content_area;

        var action_group = new SimpleActionGroup ();
        action_group.add_action (new GLib.Settings ("org.gnome.desktop.interface").create_action ("gtk-enable-primary-paste"));

        insert_action_group ("clicking", action_group);

        var a11y_mouse_settings = new GLib.Settings ("org.gnome.desktop.a11y.mouse");
        a11y_mouse_settings.bind (
            "secondary-click-enabled",
            hold_switch,
            "active",
            GLib.SettingsBindFlags.DEFAULT
        );
        a11y_mouse_settings.bind (
            "secondary-click-time",
            hold_scale_adjustment,
            "value",
            GLib.SettingsBindFlags.DEFAULT
        );

        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_delay_scale, "sensitive", SettingsBindFlags.GET);
        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_spin_box, "sensitive", SettingsBindFlags.GET);
        a11y_mouse_settings.bind ("dwell-click-enabled", dwell_click_switch, "active", SettingsBindFlags.DEFAULT);
        a11y_mouse_settings.bind ("dwell-time", dwell_click_adjustment, "value", SettingsBindFlags.DEFAULT);

        hold_switch.bind_property ("active", hold_scale, "sensitive", BindingFlags.SYNC_CREATE);
        hold_switch.bind_property ("active", hold_spin_box, "sensitive", BindingFlags.SYNC_CREATE);

        var mouse_settings = new GLib.Settings ("org.gnome.desktop.peripherals.mouse");
        mouse_settings.bind ("double-click", double_click_speed_adjustment, "value", SettingsBindFlags.DEFAULT);

        if (mouse_settings.get_boolean ("left-handed")) {
            mouse_right.active = true;
        } else {
            mouse_left.active = true;
        }

        mouse_left.toggled.connect (() => {
            if (mouse_left.active) {
                mouse_settings.set_boolean ("left-handed", false);
            }
        });

        mouse_right.toggled.connect (() => {
            if (mouse_right.active) {
                mouse_settings.set_boolean ("left-handed", true);
            }
        });

        dwell_click_spinbutton.output.connect (() => {
            dwell_click_spinbutton.text = _("%.1f seconds").printf (dwell_click_adjustment.value);
            return true;
        });

        hold_spinbutton.output.connect (() => {
            hold_spinbutton.text = _("%.1f seconds").printf (hold_scale_adjustment.value);
            return true;
        });
    }
}
