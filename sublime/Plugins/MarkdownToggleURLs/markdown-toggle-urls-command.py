import sublime
import sublime_plugin

class MarkdownToggleUrlsCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        enabled = self.view.settings().get("markdown_urls_are_folded")
        if enabled:
            self.view.unfold(self.view.find_by_selector("meta.link.inline markup.underline.link"))
            self.view.settings().set("markdown_urls_are_folded", False)
        else:
            self.view.fold(self.view.find_by_selector("meta.link.inline markup.underline.link"))
            self.view.settings().set("markdown_urls_are_folded", True)

    def is_enabled(self):
        return self.view.match_selector(0, "text.html.markdown")

class MarkdownLinkFolder(sublime_plugin.ViewEventListener):
    @classmethod
    def is_applicable(cls, settings):
        return settings.get("syntax").endswith("Markdown.sublime-syntax")

    def on_load(self):
        self.view.run_command("markdown_toggle_urls")

    # on_post_save = on_load
