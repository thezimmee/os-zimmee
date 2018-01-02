import os
from shutil import copyfile
import sublime
import sublime_plugin


class PromptSaveActiveThemeCommand(sublime_plugin.WindowCommand):
	def run(self):
		# Get active theme.
		active_theme = self.window.active_view().settings().get("color_scheme")
		active_theme_path = os.path.relpath(os.path.join(sublime.packages_path(), os.path.dirname(active_theme), "Copy - " + os.path.basename(active_theme)), sublime.packages_path())
		# Prompt user for new theme path.
		panel_view = self.window.show_input_panel("Theme Name:", active_theme_path, self.on_done, None, None)
		# Select the file name.
		panel_view.sel().clear()
		panel_view.sel().add(sublime.Region(len(os.path.dirname(active_theme_path)) + 1, len(active_theme_path) - len(os.path.splitext(active_theme_path)[1])))

	def on_done(self, path):
		try:
			# Run save active theme command.
			if self.window.active_view():
				self.window.active_view().run_command("save_active_theme", {"path": path})
		except ValueError:
			pass

class SaveActiveThemeCommand(sublime_plugin.TextCommand):
	def run(self, edit, path):
		# Get active theme.
		self.active_theme = os.path.normpath(os.path.join(sublime.packages_path(), "..", self.view.settings().get("color_scheme")))

		# Save theme.
		self.new_theme = os.path.normpath(os.path.join(sublime.packages_path(), "..", path))
		if os.path.exists(self.new_theme):
			self.existing_theme = os.path.join(os.path.dirname(self.new_theme), "Backup - " + os.path.basename(self.new_theme))
			self.view.window().show_quick_panel([["Destination theme already exists... continue?", "It will be backed up to " + os.path.relpath(self.existing_theme, sublime.packages_path())], ["Cancel", "Skip saving this theme."]], self.on_done)
		else:
			self.save_theme()

	def on_done(self, choice):
		if choice == 1 or choice == -1:
			return
		os.rename(self.new_theme, self.existing_theme)
		self.save_theme()

	def save_theme(self):
		copyfile(self.active_theme, self.new_theme)
