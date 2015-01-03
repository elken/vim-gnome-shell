#!/usr/bin/env python
import json
import os
import vim
import zipfile

from gi.repository import Gio


class GnomeShell(object):

    def init(self):
        try:
            self.json = open('metadata.json')
        except IOError:
            return

        self.settings = Gio.Settings(schema='org.gnome.shell')
        self.extensions = self.settings.get_strv('enabled-extensions')

        self.data = json.load(self.json)
        self.json.close()

        self.uuid = self.data['uuid']
        self.name = self.data['name']
        self.desc = self.data['description']
        self.url = "none"
        try:
            self.url = self.data['url']
        except KeyError:
            return

    def getURL(self):
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
        return os.path.exists(
            os.path.join(os.environ['HOME'],
                         ".local/share/gnome-shell/extensions/",
                         self.uuid, "prefs.js"))

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

g = GnomeShell()


def initVGS():
    g.init()
    try:
        vim.command("let g:vim_gnome_shell_uuid = '%s'" % g.getUUID())
        vim.command("let g:vim_gnome_shell_name = '%s'" % g.getName())
    except AttributeError:
        print "Object not loaded, can't init"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")


def VGSEnable():
    try:
        g.enableExtension()
    except AttributeError:
        print "Object not loaded, can't enable"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")


def VGSDisable():
    try:
        g.disableExtension()
    except AttributeError:
        print "Object not loaded, can't disable"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")


def VGSUpdateState():
    try:
        vim.command("let g:vim_gnome_shell_state = %d" % g.getState())
    except AttributeError:
        print "Object not loaded, can't update state"
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
    except AttributeError:
        print "Object not loaded, can't check if dir"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")


def VGSOpenPrefs():
    try:
        g.openPrefs()
    except AttributeError:
        print "Object not loaded, can't open prefs"
        vim.command("let g:vim_gnome_shell_loaded = 0")
    else:
        vim.command("let g:vim_gnome_shell_loaded = 1")


def VGSToggleState():
    try:
        s = g.getState()
        if s:
            g.disableExtension()
        else:
            g.enableExtension()

    except AttributeError:
        print "Object not loaded, can't toggle"
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


def populate():
    vim.command('setlocal modifiable')
    b = vim.current.buffer
    del b[:]
    b[0] = "\"h,j,k,l to keys to move about"
    if g.hasPrefs:
        b.append("\" Press n to open preferences window for " + g.getUUID())
    b.append("\" Press m to make a zip for uploading to extensions.gnome.org")
    b.append("\" Press t to toggle the state of the extension")
    b.append("\" q to quit")
    b.append("Name: " + g.getName())
    b.append("UUID: " + g.getUUID())
    b.append("Description: " + g.getDesc())
    b.append("State: " + str(g.getState() if "Enabled" else "Disabled"))
    b.append("URL: " + g.getURL())
    vim.command('setlocal nomodifiable')


def getFullTree():
    paths = []

    for tld, dirs, files in os.walk('.'):
        for filename in files:
            path = os.path.join(tld, filename)
            paths.append(path)

    return paths


def makeZip():
    try:
        os.remove("%s.zip" % g.getUUID())
    except OSError:
        pass

    print "Making new %s.zip" % g.getUUID()
    zf = zipfile.ZipFile("%s.zip" % g.getUUID(), "w", zipfile.ZIP_DEFLATED)

    dirs = getFullTree()
    files = []

    for d in dirs:
        if d.find('.git') is -1:
            if d.find('%s.zip' % g.getUUID()) is -1:
                files.append(d)

    for f in files:
        print 'Adding %s' % f
        zf.write(str(f))
