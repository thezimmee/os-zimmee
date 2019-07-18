#!/usr/bin/python
# -*- coding: utf-8 -*-

import sublime_plugin
import LiveReload

class ToggleLiveReloadPluginCommand(sublime_plugin.ApplicationCommand):
    def run(self, index = 4):
        LiveReload.Plugin.togglePlugin(index)
