import os
from shutil import copyfile
import sublime
import sublime_plugin

# Returns color scheme path for where the unfocused scheme should be.
def get_unfocused_scheme_path(view):
	main_scheme = view.settings().get("color_scheme")
	return os.path.join(sublime.packages_path(), "User/UnfocusedThemes", os.path.dirname(main_scheme), "Unfocused - " + os.path.basename(main_scheme))

# Returns whether this plugin is disabled.
def is_disabled():
	return not sublime.load_settings("Preferences.sublime-settings").get("focus_active_view")

# Returns true if `view` is a widget, not a file.
def is_widget(view):
	return view.settings().get("is_widget")

# Focuses a view.
def focus(view):
	# Check if plugin should run on this view.
	if is_disabled() or is_widget(view):
		return
	# Check that this view is not already focused.
	view_settings = view.settings()
	if view_settings.get("is_focused", False):
		return
	# Focus this view.
	sublime_settings = sublime.load_settings("Preferences.sublime-settings")
	scheme = sublime_settings.get("color_scheme")
	view_settings.set("is_focused", True)
	view_settings.set("color_scheme", scheme)
	# Unfocus other views, if not already unfocused.
	for window in sublime.windows():
		for other_view in window.views():
			other_view_settings = other_view.settings()
			if other_view.id() != view.id() and not is_widget(other_view) and other_view_settings.get("is_focused"):
				unfocus(other_view)

# Unfocuses a view.
def unfocus(view):
	view_settings = view.settings()
	unfocused_scheme = get_unfocused_scheme_path(view)
	if os.path.exists(unfocused_scheme):
		view_settings.set("is_focused", False)
		view_settings.set("color_scheme", unfocused_scheme)

# Creates an unfocused color scheme based on the currently active scheme.
def create_unfocused_color_scheme():
	sublime_settings = sublime.load_settings("Preferences.sublime-settings")
	original_scheme = sublime_settings.get("color_scheme")
	active_view = sublime.active_window().active_view()
	# Get active scheme.
	current_scheme = active_view.settings().get("color_scheme")

	# Method to restore the current color scheme.
	def restore_original_scheme():
		sublime_settings.set("color_scheme", original_scheme)

	# Tweak current scheme with ThemeTweaker.
	sublime_settings.set("color_scheme", current_scheme)
	new_scheme = get_unfocused_scheme_path(active_view)
	tweaker_settings = sublime_settings.get("unfocused_pane_tweaker")
	if tweaker_settings is None:
		tweaker_settings = "brightness(0.97);saturation(0.85);"
	sublime.run_command("theme_tweaker_custom", {"filters": tweaker_settings})

	try:
		# Copy the tweaked scheme to its final destination.
		if not os.path.exists(os.path.normpath(os.path.dirname(new_scheme))):
			os.makedirs(os.path.dirname(os.path.normpath(new_scheme)))
		copyfile(os.path.normpath(os.path.join(sublime.packages_path(), "User/ThemeTweaker/tweak-" + os.path.basename(current_scheme))), new_scheme)
		sublime.set_timeout_async(restore_original_scheme, 1000)

		# Return unfocused scheme path.
		return new_scheme
	except Exception as e:
		restore_original_scheme()
		print(e)
		return

# Create / update an unfocused scheme for the currently active scheme.
class CreateUnfocusedColorSchemeCommand(sublime_plugin.WindowCommand):
	def run(self):
		create_unfocused_color_scheme()

# Command to toggle focusing active view.
class ToggleFocusActiveViewCommand(sublime_plugin.WindowCommand):
	def run(self):
		if is_disabled():
			sublime.load_settings("Preferences.sublime-settings").set("focus_active_view", True)
			focus(self.window.active_view())
		else:
			sublime.load_settings("Preferences.sublime-settings").set("focus_active_view", False)
			for window in sublime.windows():
				for view in window.views():
					view.settings().erase("color_scheme")


# View listener.
class FocusActiveViewListener(sublime_plugin.EventListener):
	# When view is activated...
	def on_activated(self, view):
		focus(view)
