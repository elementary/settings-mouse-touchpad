/*
 * SPDX-License-Identifier: GPL-2.0-or-later
 * SPDX-FileCopyrightText: 2026 elementary, Inc. (https://elementary.io)
 */

public class MouseTouchpad.PointingStickView : Switchboard.SettingsPage {
    public PointingStickView () {
        Object (
            header: _("Devices"),
            icon: new ThemedIcon ("mouse-touchpad-pointingstick"),
            title: _("Pointing Stick")
        );
    }

    construct {
        show_end_title_buttons = true;

        var speed_adjustment = new Gtk.Adjustment (0, -1, 1, 0.1, 0, 0);

        var speed_scale = new Gtk.Scale (HORIZONTAL, speed_adjustment) {
            hexpand = true
        };
        speed_scale.add_mark (-1, BOTTOM, _("Slower"));
        speed_scale.add_mark (0, BOTTOM, null);
        speed_scale.add_mark (1, BOTTOM, _("Faster"));

        var speed_header = new Granite.HeaderLabel (_("Pointer Speed")) {
            mnemonic_widget = speed_scale
        };

        var accel_profile_default = new Gtk.CheckButton.with_label (_("Hardware default")) {
            action_name = "pointingstick.accel-profile",
            action_target = new Variant.string ("default")
        };

        var accel_profile_flat = new Gtk.CheckButton.with_label (_("None")) {
            action_name = "pointingstick.accel-profile",
            action_target = new Variant.string ("flat")
        };

        var accel_profile_adaptive = new Gtk.CheckButton.with_label (_("Adaptive")) {
            action_name = "pointingstick.accel-profile",
            action_target = new Variant.string ("adaptive")
        };

        var accel_profile_box = new Granite.Box (VERTICAL, HALF) {
            accessible_role = LIST
        };
        accel_profile_box.append (accel_profile_default);
        accel_profile_box.append (accel_profile_flat);
        accel_profile_box.append (accel_profile_adaptive);

        var accel_profile_header = new Granite.HeaderLabel (_("Pointer Acceleration")) {
            mnemonic_widget = accel_profile_box
        };

        var scroll_method_default = new Gtk.CheckButton.with_label (_("Hardware default")) {
            action_name = "pointingstick.scroll-method",
            action_target = new Variant.string ("default")
        };

        var scroll_method_none = new Gtk.CheckButton.with_label (_("None")) {
            action_name = "pointingstick.scroll-method",
            action_target = new Variant.string ("none")
        };

        var scroll_method_buttondown = new Gtk.CheckButton.with_label (_("While the middle button is held down")) {
            action_name = "pointingstick.scroll-method",
            action_target = new Variant.string ("on-button-down")
        };

        var scroll_method_box = new Granite.Box (VERTICAL, HALF) {
            accessible_role = LIST
        };
        scroll_method_box.append (scroll_method_default);
        scroll_method_box.append (scroll_method_none);
        scroll_method_box.append (scroll_method_buttondown);

        var scrolling_header = new Granite.HeaderLabel (_("Scroll Method")) {
            mnemonic_widget = scroll_method_box
        };

        var content_box = new Granite.Box (VERTICAL, HALF);
        content_box.append (speed_header);
        content_box.append (speed_scale);
        content_box.append (accel_profile_header);
        content_box.append (accel_profile_box);
        content_box.append (scrolling_header);
        content_box.append (scroll_method_box);

        child = content_box;

        var settings = new GLib.Settings ("org.gnome.desktop.peripherals.pointingstick");
        settings.bind ("speed", speed_adjustment, "value", DEFAULT);

        var action_group = new SimpleActionGroup ();
        action_group.add_action (settings.create_action ("accel-profile"));
        action_group.add_action (settings.create_action ("scroll-method"));

        insert_action_group ("pointingstick", action_group);
    }
}
