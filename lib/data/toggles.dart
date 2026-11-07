import 'package:flutter/material.dart';

class SetupToggle {
  const SetupToggle(this.id, this.title, this.subtitle, this.icon, this.tip);
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String tip;
}

class ToggleGroup {
  const ToggleGroup(this.title, this.items);
  final String title;
  final List<SetupToggle> items;
}

const List<ToggleGroup> toggleGroups = <ToggleGroup>[
  ToggleGroup('Sensi Setup', <SetupToggle>[
    SetupToggle(
        'mobile_sensi',
        'Mobile Sensi',
        'Your chosen touch sensitivity',
        Icons.touch_app,
        'Write down your current values, then test one small adjustment at a time.'),
    SetupToggle(
        'emu_sensi',
        'Emu Sensi',
        'Your emulator preference',
        Icons.desktop_windows,
        'Keep a separate note for emulator play so the two setups do not get mixed.'),
    SetupToggle(
        'hud_phone',
        'HUD Phone',
        'Your phone control layout',
        Icons.phone_android,
        'Place frequently used controls where your fingers can reach without stretching.'),
    SetupToggle(
        'phone_dpi',
        'Device DPI',
        'Your personal DPI note',
        Icons.grid_4x4,
        'Treat DPI as a note for your setup. This checklist never changes device display settings.'),
    SetupToggle(
        'ai_sensi_aim',
        'AI Sensi and Aim',
        'Your practice sensitivity preference',
        Icons.auto_awesome,
        'Adjust this saved practice note gradually. It does not control aim in a game.'),
  ]),
  ToggleGroup('Ball Setup', <SetupToggle>[
    SetupToggle(
        'ball_overlay',
        'Ball Overlay',
        'Saved overlay preference only',
        Icons.sports_baseball_outlined,
        'Choose whether your ball overlay preference is on or hidden. This app saves the setting but never draws a ball in Training.'),
  ]),
  ToggleGroup('Crosshair', <SetupToggle>[
    SetupToggle(
        'crosshair',
        'Crosshair Overlay',
        'Show or hide your training reticle',
        Icons.gps_fixed,
        'Switch this on to use your chosen crosshair color and Pro Crosshair style in drills.'),
  ]),
  ToggleGroup('Controls', <SetupToggle>[
    SetupToggle(
        'aim_lock',
        'Aim Lock Practice Cue',
        'Optional visual focus cue in drills',
        Icons.center_focus_strong,
        'This preference is for a visual focus cue in this app only; it never locks aim or controls a game.'),
    SetupToggle(
        'gyro',
        'Gyroscope Aim',
        'Your gyro preference',
        Icons.screen_rotation,
        'If you use gyro, try gentle tilts first and keep your wrists relaxed.'),
    SetupToggle(
        'custom_hud',
        'Custom HUD Layout',
        'Your button arrangement',
        Icons.dashboard_customize,
        'Save a simple layout before experimenting so you can compare comfort.'),
    SetupToggle(
        'fire_size',
        'Fire Button Size',
        'Your preferred button size',
        Icons.radio_button_checked,
        'Choose a size that is easy to tap without blocking your view.'),
    SetupToggle(
        'claw',
        '4-Finger Claw Layout',
        'Your finger layout preference',
        Icons.pan_tool_alt,
        'Build up gradually. Stop if a position causes discomfort or strain.'),
  ]),
  ToggleGroup('Display', <SetupToggle>[
    SetupToggle(
        'fps_live',
        'FPS',
        'Show an in-app FPS reading (simulated)',
        Icons.speed,
        'This is a generated demonstration value. The app does not read device frame rate.'),
    SetupToggle(
        'ram_live',
        'RAM',
        'Show an in-app RAM reading (simulated)',
        Icons.memory,
        'This is a generated demonstration value. The app does not inspect device memory.'),
    SetupToggle(
        'ping_live',
        'Ping Live',
        'Show an in-app ping reading (simulated)',
        Icons.network_check,
        'This is a generated demonstration value. The app does not connect to a server or measure network latency.'),
    SetupToggle(
        'high_fps',
        'High Frame Rate Mode',
        'Reminder for your own setup',
        Icons.speed,
        'Check the game menu yourself and choose a mode that stays smooth on your device.'),
    SetupToggle(
        'smooth_graphics',
        'Smooth Graphics',
        'Your graphics preference',
        Icons.auto_graph,
        'A consistent picture can make target movement easier to read.'),
    SetupToggle(
        'brightness',
        'Screen Brightness Lock Reminder',
        'A personal reminder',
        Icons.brightness_6,
        'Set a comfortable brightness before a session and avoid glare.'),
  ]),
  ToggleGroup('Training Habits', <SetupToggle>[
    SetupToggle(
        'warmup',
        'Daily Warm-up Reminder',
        'Your habit checklist',
        Icons.alarm,
        'Start with a few minutes of easy, controlled practice before raising difficulty.'),
    SetupToggle(
        'haptics',
        'Haptic Feedback',
        'Haptic tap on hits and misses while the practice profile is ON',
        Icons.vibration,
        'When enabled, the active practice profile gives a medium haptic on a hit and a light haptic on a miss.'),
    SetupToggle(
        'sounds',
        'Sound Effects',
        'System click on hits and misses while the practice profile is ON',
        Icons.volume_up,
        'When enabled, the active practice profile plays the device system click after hits and misses.'),
    SetupToggle(
        'hit_markers',
        'Show Hit Markers in Drills',
        'Visual drill feedback',
        Icons.my_location,
        'Hit markers can help you notice successful timing during practice.'),
  ]),
];

Map<String, bool> defaultToggleValues() => <String, bool>{
      for (final group in toggleGroups)
        for (final item in group.items) item.id: false,
    };

Map<String, dynamic> defaultProfileValues() => <String, dynamic>{
      'mobile_sensi': 100,
      'emu_sensi': 100,
      'hud_phone': 'Balanced',
      'phone_dpi': 420,
      'ai_sensi_aim': 100,
      'aim_lock': false,
      'fps_live': false,
      'ram_live': false,
      'ping_live': false,
      'gyro': 50,
      'custom_hud': 'Balanced',
      'fire_size': 55,
      'claw': 'Four fingers',
      'high_fps': '60 FPS',
      'smooth_graphics': 'Balanced',
      'brightness': 70,
      'warmup': 10,
      'ball_color': 'Red',
      'ball_size': 34,
      'crosshair_color': 'Lime',
      'crosshair_style': 'Precision',
      'crosshair_size': 32,
      'crosshair_thickness': 2,
      'crosshair_gap': 5,
      'crosshair_opacity': 0.9,
    };

const Map<String, int> trainingOverlayColors = <String, int>{
  'Red': 0xFFFF303E,
  'Crimson': 0xFFE11D2E,
  'Orange': 0xFFFF8A24,
  'Gold': 0xFFFFD43B,
  'Lime': 0xFFB5F542,
  'Green': 0xFF28D17C,
  'Cyan': 0xFF35D8E6,
  'Blue': 0xFF4388FF,
  'Violet': 0xFFAA70FF,
  'White': 0xFFF4F4F4,
};
