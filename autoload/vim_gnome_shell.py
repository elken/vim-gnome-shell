#!/usr/bin/env python
import string
import json
import sys
import os

from gi.repository import Gio

class GnomeShell(object):

    def __init__(self):
        try:
            self.json = open('metadata.json')
        except IOError, e:
            return 

        self.data = json.load(self.json)
        self.json.close()

        self.uuid = self.data['uuid']
        self.name = self.data['name']
        self.desc = self.data['description']
        try:
            self.url = self.data['url']
        except KeyError, e:
            print "No URL in metadata.json"
            self.url = "none"

        self.settings = Gio.Settings(schema='org.gnome.shell')
        self.extensions = self.settings.get_strv('enabled-extensions')

    def getURL(self):
        if self.url != "none":
            return self.url

    def getDesc(self):
        return self.desc

    def getUUID(self):
        return self.uuid

    def getName(self):
        return self.name

    def getState(self):
        if self.uuid in self.extensions:
            return 1
        else:
            return 0

    def hasPrefs(self):
        return os.path.exists(os.path.join(os.environ['HOME'],".local/share/gnome-shell/extensions/",self.uuid,"prefs.js"))

    def openPrefs(self):
        if self.hasPrefs():
            os.system("gnome-shell-extension-prefs "+self.uuid+" 2> /dev/null")
        else:
            return 0

    def enableExtension(self):
        if self.getState() == 1:
            print self.uuid + " is already enabled." 
            return

        self.extensions.append(self.uuid)
        self.settings.set_strv('enabled-extensions', self.extensions)
        print self.uuid + " is now enabled." 

    def disableExtension(self):
        if self.getState() == 0:
            print self.uuid + " is not enabled or installed." 
            return

        while self.uuid in self.extensions:
            self.extensions.remove(self.uuid)

        self.settings.set_strv('enabled-extensions', self.extensions)
        print self.uuid + " is now disabled." 

g

def reset():
    vim.command("let g:vim_gnome_shell_uuid = ''")
    vim.command("let g:vim_gnome_shell_name = ''")
    vim.command("let g:vim_gnome_shell_cwd = ''")
    vim.command("let g:vim_gnome_shell_state = ''")

def initVGS():
    reset()
    g = GnomeShell()
    try:
        vim.command("let g:vim_gnome_shell_uuid = '%s'" % g.getUUID())
        vim.command("let g:vim_gnome_shell_name = '%s'" % g.getName())
    except AttributeError, e:
        print "g is not defined, unable to find metadata.json"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")

def VGSEnable():
    try:
        g.enableExtension()
    except AttributeError, e:
        print "g is not defined, unable to find metadata.json"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")

def VGSDisable():
    try:
        g.disableExtension()
    except AttributeError, e:
        print "g is not defined, unable to find metadata.json"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")

def VGSUpdateState():
    try:
        vim.command("let g:vim_gnome_shell_state = %d" % g.getState())
    except AttributeError, e:
        print "g is not defined, unable to find metadata.json"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")

def VGSIsExtensionDir():
    try:
        vim.command("call s:SetCWD()")
        cwd = vim.eval("g:vim_gnome_shell_cwd")
        cwd = cwd[:-1]
        uuid = g.getUUID()
        if cwd == uuid:
            return 1
        else:
            return 0
    except AttributeError, e:
        print "g is not defined, unable to find metadata.json"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")

def normal(str):
    vim.command("normal "+str)

def insert(arg):
    for i in arg:
        normal("o")
        vim.current.line = i
    
def append(arg):
    for i in arg:
        vim.current.line = vim.current.line + i + " "
