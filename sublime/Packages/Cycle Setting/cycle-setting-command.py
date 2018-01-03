import sublime
import sublime_plugin


class CycleSettingCommand(sublime_plugin.TextCommand):
	def run(self, edit, setting, options, isGlobal = False):
		index = len(options)
		if not index :
			return
		try:
			# Get current setting.
			if isGlobal:
				current = sublime.load_settings("Preferences.sublime-settings").get(setting)
			else:
				current = self.view.settings().get(setting)
			index = options.index(current)
		except:
			index = 0

		index = (index + 1) % len(options)
		self.view.settings().set(setting, options[index])
