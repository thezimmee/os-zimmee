import sublime
import sublime_plugin

class DisableCompletionListener(sublime_plugin.EventListener):
    def on_query_completions(self, view, prefix, locations):
        return ([], sublime.INHIBIT_WORD_COMPLETIONS)