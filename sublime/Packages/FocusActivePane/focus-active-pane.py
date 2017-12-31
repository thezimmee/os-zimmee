import os
import sublime
import sublime_plugin


# With ThemeTweaker:
# class FocusActivePaneListener(sublime_plugin.EventListener):
# 	def on_activated(self, view):
# 		# Do nothing if the view is not a file.
# 		if view.file_name() == None:
# 			return

# 		# Load settings.
# 		preferences = sublime.load_settings("Preferences.sublime-settings")
# 		view_settings = view.settings()

# 		# Reset to default color scheme for active pane.
# 		if (view_settings.has("focused_is_inactive")):
# 			# Set view as active.
# 			view_settings.erase("focused_is_inactive")
# 			sublime.run_command("theme_tweaker_clear")

# 	def on_deactivated(self, view):
# 		# Do nothing if the view is not a file.
# 		if view.file_name() == None:
# 			return

# 		# Load settings.
# 		preferences = sublime.load_settings("Preferences.sublime-settings")
# 		view_settings = view.settings()

# 		# Do nothing if the view is already active.
# 		if (view_settings.has("focused_is_inactive")):
# 			return

# 		# Set view as active.
# 		view_settings.set("focused_is_inactive", True)

# 		# Get tweaker settings.
# 		tweaker_settings = preferences.get("inactive_pane_tweaker")
# 		if tweaker_settings is None:
# 			tweaker_settings = "brightness(0.5);saturation(0.5);"

# 		# Tweak the theme to be inactive.
# 		sublime.run_command("theme_tweaker_custom", {"filters": tweaker_settings})



# Inserts a suffix to a theme's base filename.
def get_theme_name(theme):
	preferences = sublime.load_settings("Preferences.sublime-settings")
	suffix = preferences.get("focused_color_scheme_suffix")

	# Suffix default:
	if suffix is None:
		suffix = ".inactive"

	# Insert the
	theme = theme.split(".")
	theme[1] = "." + theme[1]
	theme.insert(1, suffix)
	theme = "".join(theme)
	return theme

class FocusActivePaneListener(sublime_plugin.EventListener):
	def on_activated(self, view):
		# Do nothing if the view is not a file.
		if view.file_name() == None and "git-savvy" not in view.scope_name(0) and "text.find-in-files" not in view.scope_name(0):
			print("Skipping activation for:", view.file_name(), view.name())
			return

		# Load settings.
		preferences = sublime.load_settings("Preferences.sublime-settings")
		view_settings = view.settings()
		# Load theme paths.
		active_theme = view_settings.get("color_scheme")
		configured_theme = preferences.get("color_scheme")
		focus_theme = get_theme_name(active_theme)

		# Restore to the default theme.
		if active_theme != focus_theme:
			view_settings.set("color_scheme", configured_theme)
			print('---')
			print('activated', view.file_name(), view.name())

	def on_deactivated(self, view):
		# Do nothing if the view is not a file.
		if view.file_name() == None and "git-savvy" not in view.scope_name(0) and "text.find-in-files" not in view.scope_name(0):
			print("Skipping deactivation for:", view.file_name(), view.name())
			return

		# Load settings.
		preferences = sublime.load_settings("Preferences.sublime-settings")
		view_settings = view.settings()
		# Load theme paths.
		active_theme = view_settings.get("color_scheme")
		focus_theme = get_theme_name(active_theme)

		print('active_theme', active_theme)
		print('focus_theme', focus_theme)

		# Apply the focus theme if it's not already applied.
		if focus_theme != "" and focus_theme != active_theme:
			# Make sure the theme path exists.
			theme_path = os.path.normpath(os.path.join(sublime.packages_path(), "..", focus_theme))
			try:
				open(theme_path)
			except IOError:
				print("Theme " + focus_theme + " does not exist.")
				return

			# Set the focus theme.
			view_settings.set("color_scheme", focus_theme)
			print('---')
			print('deactivated', view.file_name(), view.name())

