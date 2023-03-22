local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on('format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local background
    local foreground
    if hover then
      background = '#4b4052'
      foreground = '#909090'
    elseif tab.is_active then
      background = '#1b3052'
      foreground = '#d0d0d0'
    else
      background = '#1b1032'
      foreground = '#808080'
    end

    local edge_foreground = background
    local edge_background = '#0b0022'

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = utf8.char(0xe0b2) },
      { Background = { Color = background } },
      { Foreground = { Color = '#ace1cf' } },
      { Text = tab.tab_index + 1 .. ' ' },
      { Foreground = { Color = foreground } },
      { Text = wezterm.truncate_right(tab.active_pane.title, max_width - 4) },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Text = utf8.char(0xe0b0) },
    }
  end
)
wezterm.on('update-right-status',
  function(window, pane)
    if window:leader_is_active() then
      window:set_right_status('LDR')
    else
      local table_name = window:active_key_table()
      if table_name then
        window:set_right_status(table_name:gsub('_', ' '))
      else
        window:set_right_status('')
      end
    end
  end
)

local quick_select_links = act.QuickSelectArgs {
  label = 'open url',
  patterns = {
    'https?://\\S+',
    'git://\\S+',
    'ssh://\\S+',
    'ftp://\\S+',
    'file://\\S+',
    'mailto://\\S+',
  },
  action = wezterm.action_callback(function(window, pane)
    wezterm.open_with(window:get_selection_text_for_pane(pane), 'rofi-open')
  end),
}
local quick_select_cmdline = act.QuickSelectArgs {
  label = 'copy command line',
  patterns = {
    "❯ [^│↲]+[^[:space:]│↲]",
    "sudo [^│↲]+[^[:space:]│↲]",
    "b?[as]sh [^│↲]+[^[:space:]│↲]",
    "if [^│↲]+[^[:space:]│↲]",
    "for [^│↲]+[^[:space:]│↲]",
    "docker-compose [^│↲]+[^[:space:]│↲]",
    "docker [^│↲]+[^[:space:]│↲]",
    "git [^│↲]+[^[:space:]│↲]",
    "ls [^│↲]+[^[:space:]│↲]",
    "cd [^│↲]+[^[:space:]│↲]",
    "mkdir [^│↲]+[^[:space:]│↲]",
    "cat [^│↲]+[^[:space:]│↲]",
    "n?vim? [^│↲]+[^[:space:]│↲]",
    "c?make [^│↲]+[^[:space:]│↲]",
    "cargo [^│↲]+[^[:space:]│↲]",
    "rust[cu]?p? [^│↲]+[^[:space:]│↲]",
    "python[23]? [^│↲]+[^[:space:]│↲]",
    "pip[23]? [^│↲]+[^[:space:]│↲]",
    "pytest [^│↲]+[^[:space:]│↲]",
    "apt [^│↲]+[^[:space:]│↲]",
    "php [^│↲]+[^[:space:]│↲]",
    "node [^│↲]+[^[:space:]│↲]",
    "np[mx] [^│↲]+[^[:space:]│↲]",
    "p?grep [^│↲]+[^[:space:]│↲]",
    "p?kill [^│↲]+[^[:space:]│↲]",
    "fd [^│↲]+[^[:space:]│↲]",
    "rg [^│↲]+[^[:space:]│↲]",
    "echo [^│↲]+[^[:space:]│↲]",
    "g?awk [^│↲]+[^[:space:]│↲]",
    "curl [^│↲]+[^[:space:]│↲]",
    "sed [^│↲]+[^[:space:]│↲]",
    "basename [^│↲]+[^[:space:]│↲]",
    "dirname [^│↲]+[^[:space:]│↲]",
    "head [^│↲]+[^[:space:]│↲]",
    "tail [^│↲]+[^[:space:]│↲]",
  },
}
local quick_select_ip = act.QuickSelectArgs {
  label = 'copy ip',
  patterns = {
    "[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+",
    "[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}\z
    :[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}:[0-9a-fA-F]{0,4}",
  },
}
local quick_select_number = act.QuickSelectArgs {
  label = 'copy number',
  patterns = {
    "[0-9]*\\.?[0-9]+",
    "[0-9]*,[0-9]+",
  },
}
local quick_select_nonspace = act.QuickSelectArgs {
  label = 'copy non-space',
  patterns = { "[^[:space:]]+" },
}

return {
  unicode_version = 14,
  default_prog = { '/usr/local/bin/fish', '-l' },
  font = wezterm.font_with_fallback {
    { family = 'Hack Nerd Font Mono' },
    { family = 'Noto Emoji' },
  },
  font_size = 9,
  window_background_opacity = 0.8,
  hide_tab_bar_if_only_one_tab = true,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0 },
  term = 'wezterm',
  use_fancy_tab_bar = false,
  window_frame = {
    font_size = 9,
  },
  tab_max_width = 32,
  color_scheme = 'Solarized Dark Higher Contrast',
  disable_default_quick_select_patterns = true,
  quick_select_patterns = {
    "[^[:space:]]*[/.][^[:space:]]*",
  },
  warn_about_missing_glyphs = false,
  disable_default_key_bindings = true,
  leader = { key = 'phys:Space', mods = 'ALT' },
  keys = {
    { key = '!', mods = 'SHIFT|ALT', action = act.ActivateTab(0) },
    { key = '"', mods = 'SHIFT|ALT', action = act.ActivateTab(1) },
    { key = '·', mods = 'SHIFT|ALT', action = act.ActivateTab(2) },
    { key = '$', mods = 'SHIFT|ALT', action = act.ActivateTab(3) },
    { key = '%', mods = 'SHIFT|ALT', action = act.ActivateTab(4) },
    { key = '&', mods = 'SHIFT|ALT', action = act.ActivateTab(5) },
    { key = '/', mods = 'SHIFT|ALT', action = act.ActivateTab(6) },
    { key = '(', mods = 'SHIFT|ALT', action = act.ActivateTab(7) },
    { key = ')', mods = 'SHIFT|ALT', action = act.ActivateTab(8) },
    { key = '=', mods = 'SHIFT|ALT', action = act.ActivateTab(9) },
    { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
    { key = '+', mods = 'SHIFT|CTRL', action = act.IncreaseFontSize },
    { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
    { key = '-', mods = 'SHIFT|CTRL', action = act.DecreaseFontSize },
    { key = '0', mods = 'CTRL', action = act.ResetFontSize },
    { key = '0', mods = 'SHIFT|CTRL', action = act.ResetFontSize },
    { key = 'B', mods = 'CTRL', action = quick_select_number },
    { key = 'B', mods = 'SHIFT|CTRL', action = quick_select_number },
    { key = 'C', mods = 'CTRL', action = quick_select_cmdline },
    { key = 'C', mods = 'SHIFT|CTRL', action = quick_select_cmdline },
    -- { key = 'C', mods = 'CTRL', action = act.CopyTo 'Clipboard' },
    -- { key = 'C', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'D', mods = 'CTRL', action = act.ScrollByPage(1) },
    { key = 'D', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
    { key = 'F', mods = 'CTRL', action = act.Search
      'CurrentSelectionOrEmptyString' },
    { key = 'F', mods = 'SHIFT|CTRL', action = act.Search
      'CurrentSelectionOrEmptyString' },
    { key = 'I', mods = 'CTRL', action = quick_select_ip },
    { key = 'I', mods = 'SHIFT|CTRL', action = quick_select_ip },
    { key = 'K', mods = 'CTRL', action = quick_select_links },
    { key = 'K', mods = 'SHIFT|CTRL', action = quick_select_links },
    -- { key = 'K', mods = 'CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
    -- { key = 'K', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'L', mods = 'CTRL', action = act.ShowDebugOverlay },
    { key = 'L', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
    { key = 'M', mods = 'CTRL', action = act.Hide },
    { key = 'M', mods = 'SHIFT|CTRL', action = act.Hide },
    { key = 'N', mods = 'CTRL', action = act.SpawnWindow },
    { key = 'N', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
    { key = 'P', mods = 'CTRL', action = act.QuickSelect },
    { key = 'P', mods = 'SHIFT|CTRL', action = act.QuickSelect },
    { key = 'R', mods = 'CTRL', action = act.ReloadConfiguration },
    { key = 'R', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
    { key = 'S', mods = 'CTRL', action = quick_select_nonspace },
    { key = 'S', mods = 'SHIFT|CTRL', action = quick_select_nonspace },
    { key = 'T', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'T', mods = 'SHIFT|ALT', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'U', mods = 'CTRL', action = act.ScrollByPage(-1) },
    { key = 'U', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
    { key = 'U', mods = 'ALT|CTRL', action = act.CharSelect
      { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    { key = 'U', mods = 'SHIFT|ALT|CTRL', action = act.CharSelect
      { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    { key = 'W', mods = 'CTRL', action = act.CloseCurrentTab{ confirm = true } },
    { key = 'W', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
    { key = 'X', mods = 'CTRL', action = act.ActivateCopyMode },
    { key = 'X', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
    { key = 'Y', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'Y', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'Z', mods = 'CTRL', action = act.TogglePaneZoomState },
    { key = 'Z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
    { key = '^', mods = 'CTRL', action = act.ActivateTab(5) },
    { key = '^', mods = 'SHIFT|CTRL', action = act.ActivateTab(5) },
    { key = 'b', mods = 'SHIFT|CTRL', action = quick_select_number },
    { key = 'c', mods = 'SHIFT|CTRL', action = quick_select_cmdline },
    -- { key = 'c', mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
    { key = 'd', mods = 'SHIFT|CTRL', action = act.ScrollByPage(1) },
    { key = 'f', mods = 'SHIFT|CTRL', action = act.Search
      'CurrentSelectionOrEmptyString' },
    { key = 'f', mods = 'SUPER', action = act.Search
      'CurrentSelectionOrEmptyString' },
    { key = 'i', mods = 'SHIFT|CTRL', action = quick_select_ip },
    { key = 'k', mods = 'SHIFT|CTRL', action = quick_select_links },
    -- { key = 'k', mods = 'SHIFT|CTRL', action = act.ClearScrollback 'ScrollbackOnly' },
    -- { key = 'k', mods = 'SUPER', action = act.ClearScrollback 'ScrollbackOnly' },
    { key = 'l', mods = 'SHIFT|CTRL', action = act.ShowDebugOverlay },
    { key = 'm', mods = 'SHIFT|CTRL', action = act.Hide },
    { key = 'm', mods = 'SUPER', action = act.Hide },
    { key = 'n', mods = 'SHIFT|CTRL', action = act.SpawnWindow },
    { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
    { key = 'p', mods = 'SHIFT|CTRL', action = act.QuickSelect },
    { key = 'r', mods = 'SHIFT|CTRL', action = act.ReloadConfiguration },
    { key = 'r', mods = 'SUPER', action = act.ReloadConfiguration },
    { key = 's', mods = 'SHIFT|CTRL', action = quick_select_nonspace },
    { key = 't', mods = 'SHIFT|ALT', action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'u', mods = 'SHIFT|CTRL', action = act.ScrollByPage(-1) },
    { key = 'u', mods = 'SHIFT|ALT|CTRL', action = act.CharSelect
      { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    { key = 'w', mods = 'SHIFT|CTRL', action = act.CloseCurrentTab{ confirm = true } },
    { key = 'w', mods = 'SUPER', action = act.CloseCurrentTab{ confirm = true } },
    { key = 'x', mods = 'SHIFT|CTRL', action = act.ActivateCopyMode },
    { key = 'y', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'y', mods = 'SHIFT|CTRL', action = act.PasteFrom 'Clipboard' },
    { key = 'z', mods = 'SHIFT|CTRL', action = act.TogglePaneZoomState },
    { key = '{', mods = 'SUPER', action = act.ActivateTabRelative(-1) },
    { key = '{', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(-1) },
    { key = '}', mods = 'SUPER', action = act.ActivateTabRelative(1) },
    { key = '}', mods = 'SHIFT|SUPER', action = act.ActivateTabRelative(1) },
    { key = 'phys:Space', mods = 'SHIFT|CTRL', action = act.ActivateCommandPalette },
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },
    { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },
    { key = 'PageUp', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(-1) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
    { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'PageDown', mods = 'SHIFT|CTRL', action = act.MoveTabRelative(1) },
    { key = 'LeftArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Left' },
    { key = 'LeftArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
    { key = 'RightArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Right' },
    { key = 'RightArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
    { key = 'UpArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Up' },
    { key = 'UpArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
    { key = 'DownArrow', mods = 'SHIFT|CTRL', action = act.ActivatePaneDirection 'Down' },
    { key = 'DownArrow', mods = 'SHIFT|ALT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
    { key = 'Insert', mods = 'SHIFT', action = act.PasteFrom 'PrimarySelection' },
    { key = 'Insert', mods = 'CTRL', action = act.CopyTo 'PrimarySelection' },
    { key = 'Copy', mods = 'NONE', action = act.CopyTo 'Clipboard' },
    { key = 'Paste', mods = 'NONE', action = act.PasteFrom 'Clipboard' },
    { key = 'Backspace', mods = 'CTRL', action = wezterm.action.SendString('\x1b\x7f') },
    -- tmux keys
    { key = 'F', mods = 'SHIFT|ALT', action = act.ToggleFullScreen },
    { key = 'S', mods = 'SHIFT|ALT', action = act.SplitVertical
      { domain = 'CurrentPaneDomain' } },
    { key = 'V', mods = 'SHIFT|ALT', action = act.SplitHorizontal
      { domain = 'CurrentPaneDomain' } },
    { key = 'O', mods = 'SHIFT|ALT', action = act.ActivateTabRelative(1) },
    { key = 'I', mods = 'SHIFT|ALT', action = act.ActivateTabRelative(-1) },
    { key = 'L', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Right' },
    { key = 'K', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Up' },
    { key = 'J', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Down' },
    { key = 'H', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Left' },
    { key = 'L', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
    { key = 'K', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
    { key = 'J', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
    { key = 'H', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
    { key = 'f', mods = 'SHIFT|ALT', action = act.ToggleFullScreen },
    { key = 's', mods = 'SHIFT|ALT', action = act.SplitVertical
      { domain = 'CurrentPaneDomain' } },
    { key = 'v', mods = 'SHIFT|ALT', action = act.SplitHorizontal
      { domain = 'CurrentPaneDomain' } },
    { key = 'o', mods = 'SHIFT|ALT', action = act.ActivateTabRelative(1) },
    { key = 'i', mods = 'SHIFT|ALT', action = act.ActivateTabRelative(-1) },
    { key = 'l', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Down' },
    { key = 'h', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Right', 1 } },
    { key = 'k', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Up', 1 } },
    { key = 'j', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Down', 1 } },
    { key = 'h', mods = 'ALT|CTRL', action = act.AdjustPaneSize{ 'Left', 1 } },
    -- Custom modes
    { key = 'p', mods = 'LEADER', action = act.ActivateKeyTable
      { name = 'pane_mode', one_shot = false } },
  },
  key_tables = {
    pane_mode = {
      { key = 'LeftArrow', action = act.ActivatePaneDirection 'Left' },
      { key = 'h', action = act.ActivatePaneDirection 'Left' },
      { key = 'RightArrow', action = act.ActivatePaneDirection 'Right' },
      { key = 'l', action = act.ActivatePaneDirection 'Right' },
      { key = 'UpArrow', action = act.ActivatePaneDirection 'Up' },
      { key = 'k', action = act.ActivatePaneDirection 'Up' },
      { key = 'DownArrow', action = act.ActivatePaneDirection 'Down' },
      { key = 'j', action = act.ActivatePaneDirection 'Down' },
      { key = 'LeftArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'h', mods = 'SHIFT', action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'RightArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'l', mods = 'SHIFT', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'UpArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'k', mods = 'SHIFT', action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'DownArrow', mods = 'SHIFT', action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'j', mods = 'SHIFT', action = act.AdjustPaneSize { 'Down', 1 } },
      -- Cancel the mode by pressing escape
      { key = 'Escape', action = 'PopKeyTable' },
    },
    copy_mode = {
      { key = 'Tab', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'Tab', mods = 'SHIFT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'MoveToStartOfNextLine' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'Space', mods = 'NONE', action = act.CopyMode{ SetSelectionMode = 'Cell' } },
      { key = '$', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = '$', mods = 'SHIFT', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = ',', mods = 'NONE', action = act.CopyMode 'JumpReverse' },
      { key = '0', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = ';', mods = 'NONE', action = act.CopyMode 'JumpAgain' },
      { key = 'F', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'F', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = false } } },
      { key = 'G', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'G', mods = 'SHIFT', action = act.CopyMode 'MoveToScrollbackBottom' },
      { key = 'H', mods = 'NONE', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'H', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportTop' },
      { key = 'L', mods = 'NONE', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'L', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportBottom' },
      { key = 'M', mods = 'NONE', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'M', mods = 'SHIFT', action = act.CopyMode 'MoveToViewportMiddle' },
      { key = 'O', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'O', mods = 'SHIFT', action = act.CopyMode 'MoveToSelectionOtherEndHoriz' },
      { key = 'T', mods = 'NONE', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'T', mods = 'SHIFT', action = act.CopyMode{ JumpBackward = { prev_char = true } } },
      { key = 'V', mods = 'NONE', action = act.CopyMode{ SetSelectionMode = 'Line' } },
      { key = 'V', mods = 'SHIFT', action = act.CopyMode{ SetSelectionMode = 'Line' } },
      { key = '^', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = '^', mods = 'SHIFT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'b', mods = 'NONE', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'b', mods = 'CTRL', action = act.CopyMode 'PageUp' },
      { key = 'c', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'd', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (0.5) } },
      { key = 'e', mods = 'NONE', action = act.CopyMode 'MoveForwardWordEnd' },
      { key = 'f', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = false } } },
      { key = 'f', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'f', mods = 'CTRL', action = act.CopyMode 'PageDown' },
      { key = 'g', mods = 'NONE', action = act.CopyMode 'MoveToScrollbackTop' },
      { key = 'g', mods = 'CTRL', action = act.CopyMode 'Close' },
      { key = 'h', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'j', mods = 'NONE', action = act.CopyMode 'MoveDown' },
      { key = 'k', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'l', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'm', mods = 'ALT', action = act.CopyMode 'MoveToStartOfLineContent' },
      { key = 'o', mods = 'NONE', action = act.CopyMode 'MoveToSelectionOtherEnd' },
      { key = 'q', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 't', mods = 'NONE', action = act.CopyMode{ JumpForward = { prev_char = true } } },
      { key = 'u', mods = 'CTRL', action = act.CopyMode{ MoveByPage = (-0.5) } },
      { key = 'v', mods = 'NONE', action = act.CopyMode{ SetSelectionMode = 'Cell' } },
      { key = 'v', mods = 'CTRL', action = act.CopyMode{ SetSelectionMode = 'Block' } },
      { key = 'w', mods = 'NONE', action = act.CopyMode 'MoveForwardWord' },
      { key = 'y', mods = 'NONE', action = act.Multiple{
        { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' }} },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PageUp' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'PageDown' },
      { key = 'End', mods = 'NONE', action = act.CopyMode 'MoveToEndOfLineContent' },
      { key = 'Home', mods = 'NONE', action = act.CopyMode 'MoveToStartOfLine' },
      { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode 'MoveLeft' },
      { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode 'MoveBackwardWord' },
      { key = 'RightArrow', mods = 'NONE', action = act.CopyMode 'MoveRight' },
      { key = 'RightArrow', mods = 'ALT', action = act.CopyMode 'MoveForwardWord' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'MoveUp' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'MoveDown' },
    },
    search_mode = {
      { key = 'Enter', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'Enter', mods = 'SHIFT', action = act.CopyMode 'NextMatch' },
      { key = 'Escape', mods = 'NONE', action = act.CopyMode 'Close' },
      { key = 'n', mods = 'CTRL', action = act.CopyMode 'NextMatch' },
      { key = 'p', mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
      { key = 'r', mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
      { key = 'u', mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
      { key = 'v', mods = 'ALT', action = act.CopyMode 'PriorMatchPage' },
      { key = 'v', mods = 'CTRL', action = act.CopyMode 'NextMatchPage' },
      { key = 'PageUp', mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
      { key = 'PageDown', mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
      { key = 'UpArrow', mods = 'NONE', action = act.CopyMode 'PriorMatch' },
      { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
    },
  },
}
