import os
from shutil import copyfile
import sublime
import sublime_plugin


def get_unfocused_theme_path(view):
	main_theme = view.settings().get("color_scheme")
	return os.path.join(sublime.packages_path(), "User/UnfocusedThemes", os.path.dirname(main_theme), "Unfocused - " + os.path.basename(main_theme))

def skip_view(view):
	# Do nothing if setting is toggled off.
	sublime_settings = sublime.load_settings("Preferences.sublime-settings")
	if not sublime_settings.get("focus_active_view"):
		return True

	# Do nothing if the view is not one we want to inactivate.
	if view.file_name() == None and "git-savvy" not in view.scope_name(0) and "text.find-in-files" not in view.scope_name(0):
		return True

	return False

class FocusActiveViewListener(sublime_plugin.EventListener):
	# When view is activated...
	def on_activated(self, view):
		# Check if plugin should run on this view.
		if skip_view(view):
			return

		# Do nothing is view is already focused.
		sublime_settings = sublime.load_settings("Preferences.sublime-settings")
		view_settings = view.settings()
		if view_settings.get("is_focused", False) == True or view.id() != sublime.active_window().active_view().id():
			return

		# Set view as focused.
		theme = sublime_settings.get("color_scheme")
		view_settings.set("is_focused", True)
		view_settings.set("color_scheme", theme)

	# When view is deactivated...
	def on_deactivated(self, view):
		# Check if plugin should run on this view.
		if skip_view(view):
			return

		# Do nothing if view is already unfocused or still active.
		view_settings = view.settings()
		active_view = sublime.active_window().active_view()
		if view_settings.get("is_focused", False) == False or active_view is None or view.id() == active_view.id():
			return

		# If there is no unfocused theme set, set it.
		unfocused_theme = get_unfocused_theme_path(view)
		if os.path.exists(unfocused_theme):
			# Set view as unfocused.
			view_settings.set("is_focused", False)
			view_settings.set("color_scheme", unfocused_theme)

# Create / update an unfocused theme for the currently active theme.
class CreateUnfocusedThemeCommand(sublime_plugin.WindowCommand):
	def run(self):
		sublime_settings = sublime.load_settings("Preferences.sublime-settings")
		original_theme = sublime_settings.get("color_scheme")
		active_view = self.window.active_view()
		# Get active theme.
		current_theme = active_view.settings().get("color_scheme")

		# Method to restore the current color scheme.
		def restore_theme():
			sublime_settings.set("color_scheme", original_theme)

		# Tweak current theme with ThemeTweaker.
		sublime_settings.set("color_scheme", current_theme)
		new_theme = get_unfocused_theme_path(active_view)
		tweaker_settings = sublime_settings.get("unfocused_pane_tweaker")
		if tweaker_settings is None:
			tweaker_settings = "brightness(0.97);saturation(0.75);"
		sublime.run_command("theme_tweaker_custom", {"filters": tweaker_settings})

		try:
			# Copy the tweaked theme to its final destination.
			if not os.path.exists(os.path.normpath(os.path.dirname(new_theme))):
				os.makedirs(os.path.dirname(os.path.normpath(new_theme)))
			copyfile(os.path.normpath(os.path.join(sublime.packages_path(), "User/ThemeTweaker/tweak-" + os.path.basename(current_theme))), new_theme)
			sublime.set_timeout_async(restore_theme, 1000)

			# Return unfocused theme path.
			return new_theme
		except Exception as e:
			restore_theme()
			print(e)
			return
