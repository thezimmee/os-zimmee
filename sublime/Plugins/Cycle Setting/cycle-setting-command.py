import sublime
import sublime_plugin


class CycleSettingCommand(sublime_plugin.TextCommand):
	def run(self, edit, setting, values, isGlobal = False):
		index = len(values)
		if not index :
			return
		try:
			# Get current setting.
			if isGlobal:
				current = sublime.load_settings("Preferences.sublime-settings").get(setting)
			else:
				current = self.view.settings().get(setting)
				index = values.index(current)
		except:
			index = 0

		index = (index + 1) % len(values)
		self.view.settings().set(setting, values[index])
