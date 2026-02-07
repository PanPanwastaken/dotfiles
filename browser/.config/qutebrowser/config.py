config.load_autoconfig(False)

c.auto_save.session = True
c.session.lazy_restore = True

c.url.start_pages = ['https://youtube.com', 'https://mail.google.com/mail/u/2/', 'https://discord.com/app']
c.url.default_page = 'https://youtube.com'

c.statusbar.show = 'never'
c.tabs.show = 'never'
c.tabs.favicons.show = 'never'
c.scrolling.bar = 'never'

c.fonts.default_family = 'JetBrainsMono Nerd Font'
c.fonts.default_size = '10pt'
c.fonts.completion.entry = '10pt JetBrainsMono Nerd Font'
c.fonts.completion.category = 'bold 10pt JetBrainsMono Nerd Font'
c.fonts.debug_console = '10pt JetBrainsMono Nerd Font'
c.fonts.downloads = '10pt JetBrainsMono Nerd Font'
c.fonts.hints = 'bold 10pt JetBrainsMono Nerd Font'
c.fonts.keyhint = '10pt JetBrainsMono Nerd Font'
c.fonts.messages.error = '10pt JetBrainsMono Nerd Font'
c.fonts.messages.info = '10pt JetBrainsMono Nerd Font'
c.fonts.messages.warning = '10pt JetBrainsMono Nerd Font'
c.fonts.prompts = '10pt JetBrainsMono Nerd Font'
c.fonts.statusbar = '10pt JetBrainsMono Nerd Font'
c.fonts.tabs.selected = 'bold 10pt JetBrainsMono Nerd Font'
c.fonts.tabs.unselected = '10pt JetBrainsMono Nerd Font'
c.fonts.web.family.standard = 'JetBrainsMono Nerd Font'
c.fonts.web.family.fixed = 'JetBrainsMono Nerd Font'
c.fonts.web.family.serif = 'JetBrainsMono Nerd Font'
c.fonts.web.family.sans_serif = 'JetBrainsMono Nerd Font'

c.content.blocking.enabled = True
c.content.blocking.method = 'both'
c.content.user_stylesheets = ["~/.config/qutebrowser/css/teto-sites.css"]
config.set('content.javascript.can_open_tabs_automatically', True, 'https://*.youtube.com')
config.set('content.javascript.can_open_tabs_automatically', True, 'https://*.twitch.tv')

c.tabs.padding = {'top': 6, 'bottom': 6, 'left': 10, 'right': 10}
c.tabs.indicator.width = 3
c.tabs.indicator.padding = {'top': 0, 'bottom': 0, 'left': 0, 'right': 6}
c.statusbar.padding = {'top': 6, 'bottom': 6, 'left': 8, 'right': 8}
c.hints.radius = 4
c.hints.padding = {'top': 2, 'bottom': 2, 'left': 4, 'right': 4}
c.hints.border = '1px solid #e63946'
c.completion.height = '35%'
c.completion.scrollbar.padding = 2
c.completion.scrollbar.width = 8
c.tabs.title.format = '{audio}{current_title}'
c.tabs.position = 'top'
c.window.transparent = True

c.qt.args = ['disable-gpu', 'enable-features=VaapiVideoDecodeLinuxGL']
c.qt.force_software_rendering = 'chromium'

pink = '#e63946'
blue = '#f1faee'
bg_dark = 'rgba(12, 6, 6, 0.85)'
bg_darker = 'rgba(8, 4, 4, 0.9)'
bg_light = 'rgba(25, 12, 12, 0.8)'
fg = '#f1faee'
fg_dim = '#c0b8b0'

c.colors.statusbar.normal.bg = bg_dark
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.insert.bg = 'rgba(255, 110, 180, 0.2)'
c.colors.statusbar.insert.fg = pink
c.colors.statusbar.command.bg = bg_darker
c.colors.statusbar.command.fg = blue
c.colors.statusbar.caret.bg = 'rgba(127, 219, 255, 0.2)'
c.colors.statusbar.caret.fg = blue
c.colors.statusbar.passthrough.bg = bg_dark
c.colors.statusbar.passthrough.fg = fg
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.hover.fg = pink
c.colors.statusbar.url.success.http.fg = blue
c.colors.statusbar.url.success.https.fg = blue
c.colors.statusbar.url.warn.fg = '#ffb86c'
c.colors.statusbar.url.error.fg = '#ff5555'

c.colors.tabs.bar.bg = bg_dark
c.colors.tabs.selected.even.bg = 'rgba(255, 110, 180, 0.25)'
c.colors.tabs.selected.even.fg = '#ffffff'
c.colors.tabs.selected.odd.bg = 'rgba(255, 110, 180, 0.25)'
c.colors.tabs.selected.odd.fg = '#ffffff'
c.colors.tabs.even.bg = bg_light
c.colors.tabs.even.fg = fg_dim
c.colors.tabs.odd.bg = bg_dark
c.colors.tabs.odd.fg = fg_dim
c.colors.tabs.indicator.start = pink
c.colors.tabs.indicator.stop = blue
c.colors.tabs.indicator.error = '#ff5555'

c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg_darker
c.colors.completion.even.bg = bg_dark
c.colors.completion.category.fg = pink
c.colors.completion.category.bg = 'rgba(255, 110, 180, 0.15)'
c.colors.completion.category.border.top = pink
c.colors.completion.category.border.bottom = 'rgba(255, 110, 180, 0.3)'
c.colors.completion.item.selected.fg = '#ffffff'
c.colors.completion.item.selected.bg = 'rgba(127, 219, 255, 0.25)'
c.colors.completion.item.selected.border.top = blue
c.colors.completion.item.selected.border.bottom = blue
c.colors.completion.match.fg = pink
c.colors.completion.scrollbar.fg = blue
c.colors.completion.scrollbar.bg = bg_darker

c.colors.downloads.bar.bg = bg_dark
c.colors.downloads.start.fg = '#ffffff'
c.colors.downloads.start.bg = pink
c.colors.downloads.stop.fg = '#ffffff'
c.colors.downloads.stop.bg = blue

c.colors.messages.info.bg = bg_darker
c.colors.messages.info.fg = blue
c.colors.messages.info.border = blue
c.colors.messages.error.bg = bg_darker
c.colors.messages.error.fg = '#ff5555'
c.colors.messages.error.border = '#ff5555'
c.colors.messages.warning.bg = bg_darker
c.colors.messages.warning.fg = '#ffb86c'
c.colors.messages.warning.border = '#ffb86c'

c.colors.hints.bg = pink
c.colors.hints.fg = '#ffffff'
c.colors.hints.match.fg = '#000000'

c.colors.prompts.bg = bg_darker
c.colors.prompts.fg = fg
c.colors.prompts.border = pink
c.colors.prompts.selected.bg = 'rgba(255, 110, 180, 0.3)'
c.colors.prompts.selected.fg = '#ffffff'

c.colors.keyhint.bg = bg_darker
c.colors.keyhint.fg = fg
c.colors.keyhint.suffix.fg = pink

c.colors.contextmenu.menu.bg = bg_darker
c.colors.contextmenu.menu.fg = fg
c.colors.contextmenu.selected.bg = 'rgba(255, 110, 180, 0.3)'
c.colors.contextmenu.selected.fg = '#ffffff'
c.colors.contextmenu.disabled.bg = bg_dark
c.colors.contextmenu.disabled.fg = fg_dim

c.colors.webpage.bg = '#0f0f19'
c.colors.webpage.preferred_color_scheme = 'dark'

config.bind('<Ctrl-1>', 'tab-focus 1')
config.bind('<Ctrl-2>', 'tab-focus 2')
config.bind('<Ctrl-3>', 'tab-focus 3')
config.bind('<Ctrl-4>', 'tab-focus 4')
config.bind('<Ctrl-5>', 'tab-focus 5')
config.bind('<Ctrl-6>', 'tab-focus 6')
config.bind('<Ctrl-7>', 'tab-focus 7')
config.bind('<Ctrl-8>', 'tab-focus 8')
config.bind('<Ctrl-9>', 'tab-focus -1')
config.bind('<Ctrl-h>', 'history')
config.bind('<Ctrl-r>', 'reload')
config.bind(',p', 'spawn --userscript pip-player.sh')
