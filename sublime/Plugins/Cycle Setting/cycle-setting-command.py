import sublime
import sublime_plugin

# CycleSettingCommand()
# @param  setting  {String}  Setting to change.
# @param  values  {Array}  Values to cycle through.
# @param  file  {String}  Settings file to modify (i.e.,
#     "Preferences.sublime-settings"). This allows you to change settings from
#     plugins.
# @param  persist  {Boolean}  If `file` is set, whether to persist setting to
#     disk.
class CycleSettingCommand(sublime_plugin.TextCommand):
	def run(self, edit, setting, values, file = False, persist = False):
		index = len(values)
		if not index :
			return
		print(file)
		print(persist)
		try:
			# Get current setting.
			if file:
				current = sublime.load_settings(file).get(setting)
				index = values.index(current)
			else:
				current = self.view.settings().get(setting)
				index = values.index(current)
		except:
			index = 0

		index = (index + 1) % len(values)
		if file:
			sublime.load_settings(file).set(setting, values[index])
			if persist:
				sublime.save_settings(file)
		else:
			self.view.settings().set(setting, values[index])
