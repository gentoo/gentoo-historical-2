#!/usr/bin/env python
"""Generate Python documentation in HTML or as text for interactive use.

At the shell command line outside of Python, run "pydoc <name>" to show
documentation on something.  <name> may be the name of a Python function,
module, package, or a dotted reference to a class or function within a
module or module in a package.  Alternatively, the argument can be the
path to a Python source file.

Or, at the shell prompt, run "pydoc -k <keyword>" to search for a keyword
in the one-line descriptions of modules.

Or, at the shell prompt, run "pydoc -p <port>" to start an HTTP server
on a given port on the local machine to generate documentation web pages.

Or, at the shell prompt, run "pydoc -w <name>" to write out the HTML
documentation for a module to a file named "<name>.html".

In the Python interpreter, do "from pydoc import help" to provide online
help.  Calling help(thing) on a Python object documents the object."""

__author__ = "Ka-Ping Yee <ping@lfw.org>"
__version__ = "26 February 2001"

import sys, imp, os, stat, re, types, inspect
from repr import Repr
from string import expandtabs, find, join, lower, split, strip, rstrip

# --------------------------------------------------------- common routines

def synopsis(filename, cache={}):
    """Get the one-line summary out of a module file."""
    mtime = os.stat(filename)[stat.ST_MTIME]
    lastupdate, result = cache.get(filename, (0, None))
    if lastupdate < mtime:
        file = open(filename)
        line = file.readline()
        while line[:1] == '#' or strip(line) == '':
            line = file.readline()
            if not line: break
        if line[-2:] == '\\\n':
            line = line[:-2] + file.readline()
        line = strip(line)
        if line[:3] == '"""':
            line = line[3:]
            while strip(line) == '':
                line = file.readline()
                if not line: break
            result = split(line, '"""')[0]
        else: result = None
        file.close()
        cache[filename] = (mtime, result)
    return result

def index(dir):
    """Return a list of (module-name, synopsis) pairs for a directory tree."""
    results = []
    for entry in os.listdir(dir):
        path = os.path.join(dir, entry)
        if ispackage(path):
            results.extend(map(
                lambda (m, s), pkg=entry: (pkg + '.' + m, s), index(path)))
        elif os.path.isfile(path) and entry[-3:] == '.py':
            results.append((entry[:-3], synopsis(path)))
    return results

def pathdirs():
    """Convert sys.path into a list of absolute, existing, unique paths."""
    dirs = []
    for dir in sys.path:
        dir = os.path.abspath(dir or '.')
        if dir not in dirs and os.path.isdir(dir):
            dirs.append(dir)
    return dirs

def getdoc(object):
    """Get the doc string or comments for an object."""
    result = inspect.getdoc(object)
    if not result:
        try: result = inspect.getcomments(object)
        except: pass
    return result and rstrip(result) or ''

def classname(object, modname):
    """Get a class name and qualify it with a module name if necessary."""
    name = object.__name__
    if object.__module__ != modname:
        name = object.__module__ + '.' + name
    return name

def isconstant(object):
    """Check if an object is of a type that probably means it's a constant."""
    return type(object) in [
        types.FloatType, types.IntType, types.ListType, types.LongType,
        types.StringType, types.TupleType, types.TypeType,
        hasattr(types, 'UnicodeType') and types.UnicodeType or 0]

def replace(text, *pairs):
    """Do a series of global replacements on a string."""
    for old, new in pairs:
        text = join(split(text, old), new)
    return text

def cram(text, maxlen):
    """Omit part of a string if needed to make it fit in a maximum length."""
    if len(text) > maxlen:
        pre = max(0, (maxlen-3)/2)
        post = max(0, maxlen-3-pre)
        return text[:pre] + '...' + text[len(text)-post:]
    return text

def cleanid(text):
    """Remove the hexadecimal id from a Python object representation."""
    return re.sub(' at 0x[0-9a-f]{5,}>$', '>', text)

def modulename(path):
    """Return the Python module name for a given path, or None."""
    filename = os.path.basename(path)
    if lower(filename[-3:]) == '.py':
        return filename[:-3]
    elif lower(filename[-4:]) == '.pyc':
        return filename[:-4]
    elif lower(filename[-11:]) == 'module.so':
        return filename[:-11]
    elif lower(filename[-13:]) == 'module.so.1':
        return filename[:-13]

class DocImportError(Exception):
    """Class for errors while trying to import something to document it."""
    def __init__(self, filename, etype, evalue):
        self.filename = filename
        self.etype = etype
        self.evalue = evalue
        if type(etype) is types.ClassType:
            etype = etype.__name__
        self.args = '%s: %s' % (etype, evalue)

def importfile(path):
    """Import a Python source file or compiled file given its path."""
    magic = imp.get_magic()
    file = open(path, 'r')
    if file.read(len(magic)) == magic:
        kind = imp.PY_COMPILED
    else:
        kind = imp.PY_SOURCE
    file.close()
    filename = os.path.basename(path)
    name, ext = os.path.splitext(filename)
    file = open(path, 'r')
    try:
        module = imp.load_module(name, file, path, (ext, 'r', kind))
    except:
        raise DocImportError(path, sys.exc_type, sys.exc_value)
    file.close()
    return module

def ispackage(path):
    """Guess whether a path refers to a package directory."""
    if os.path.isdir(path):
        init = os.path.join(path, '__init__.py')
        initc = os.path.join(path, '__init__.pyc')
        if os.path.isfile(init) or os.path.isfile(initc):
            return 1

# ---------------------------------------------------- formatter base class

class Doc:
    def document(self, object, *args):
        """Generate documentation for an object."""
        args = (object,) + args
        if inspect.ismodule(object): return apply(self.docmodule, args)
        if inspect.isclass(object): return apply(self.docclass, args)
        if inspect.ismethod(object): return apply(self.docmethod, args)
        if inspect.isbuiltin(object): return apply(self.docbuiltin, args)
        if inspect.isfunction(object): return apply(self.docfunction, args)
        raise TypeError, "don't know how to document objects of type " + \
            type(object).__name__

# -------------------------------------------- HTML documentation generator

class HTMLRepr(Repr):
    """Class for safely making an HTML representation of a Python object."""
    def __init__(self):
        Repr.__init__(self)
        self.maxlist = self.maxtuple = self.maxdict = 10
        self.maxstring = self.maxother = 50

    def escape(self, text):
        return replace(text, ('&', '&amp;'), ('<', '&lt;'), ('>', '&gt;'))

    def repr(self, object):
        result = Repr.repr(self, object)
        return result

    def repr1(self, x, level):
        methodname = 'repr_' + join(split(type(x).__name__), '_')
        if hasattr(self, methodname):
            return getattr(self, methodname)(x, level)
        else:
            return self.escape(cram(cleanid(repr(x)), self.maxother))

    def repr_string(self, x, level):
        text = self.escape(cram(x, self.maxstring))
        return re.sub(r'((\\[\\abfnrtv]|\\x..|\\u....)+)',
                      r'<font color="#c040c0">\1</font>', repr(text))

    def repr_instance(self, x, level):
        try:
            return cram(cleanid(repr(x)), self.maxstring)
        except:
            return self.escape('<%s instance>' % x.__class__.__name__)

    repr_unicode = repr_string

class HTMLDoc(Doc):
    """Formatter class for HTML documentation."""

    # ------------------------------------------- HTML formatting utilities

    _repr_instance = HTMLRepr()
    repr = _repr_instance.repr
    escape = _repr_instance.escape

    def preformat(self, text):
        """Format literal preformatted text."""
        text = self.escape(expandtabs(text))
        return replace(text, ('\n\n', '\n \n'), ('\n\n', '\n \n'),
                             (' ', '&nbsp;'), ('\n', '<br>\n'))

    def multicolumn(self, list, format, cols=4):
        """Format a list of items into a multi-column list."""
        result = ''
        rows = (len(list)+cols-1)/cols

        for col in range(cols):
            result = result + '<td width="%d%%" valign=top>' % (100/cols)
            for i in range(rows*col, rows*col+rows):
                if i < len(list):
                    result = result + format(list[i]) + '<br>'
            result = result + '</td>'
        return '<table width="100%%"><tr>%s</tr></table>' % result

    def heading(self, title, fgcol, bgcol, extras=''):
        """Format a page heading."""
        return """
<p><table width="100%%" cellspacing=0 cellpadding=0 border=0>
<tr bgcolor="%s"><td colspan=3 valign=bottom><small><small><br></small></small
><font color="%s" face="helvetica, arial">&nbsp;%s</font></td
><td align=right valign=bottom
><font color="%s" face="helvetica, arial">&nbsp;%s</font></td></tr></table>
    """ % (bgcol, fgcol, title, fgcol, extras)

    def section(self, title, fgcol, bgcol, contents, width=20,
                prelude='', marginalia=None, gap='&nbsp;&nbsp;&nbsp;'):
        """Format a section with a heading."""
        if marginalia is None:
            marginalia = '&nbsp;' * width
        result = """
<p><table width="100%%" cellspacing=0 cellpadding=0 border=0>
<tr bgcolor="%s"><td colspan=3 valign=bottom><small><small><br></small></small
><font color="%s" face="helvetica, arial">&nbsp;%s</font></td></tr>
    """ % (bgcol, fgcol, title)
        if prelude:
            result = result + """
<tr><td bgcolor="%s">%s</td>
<td bgcolor="%s" colspan=2>%s</td></tr>
    """ % (bgcol, marginalia, bgcol, prelude)
        result = result + """
<tr><td bgcolor="%s">%s</td><td>%s</td>
    """ % (bgcol, marginalia, gap)

        result = result + '<td width="100%%">%s</td></tr></table>' % contents
        return result

    def bigsection(self, title, *args):
        """Format a section with a big heading."""
        title = '<big><strong>%s</strong></big>' % title
        return apply(self.section, (title,) + args)

    def footer(self):
        return """
<table width="100%"><tr><td align=right>
<font face="helvetica, arial"><small><small>generated with
<strong>htmldoc</strong> by Ka-Ping Yee</a></small></small></font>
</td></tr></table>
    """

    def namelink(self, name, *dicts):
        """Make a link for an identifier, given name-to-URL mappings."""
        for dict in dicts:
            if dict.has_key(name):
                return '<a href="%s">%s</a>' % (dict[name], name)
        return name

    def classlink(self, object, modname, *dicts):
        """Make a link for a class."""
        name = object.__name__
        if object.__module__ != modname:
            name = object.__module__ + '.' + name
        for dict in dicts:
            if dict.has_key(object):
                return '<a href="%s">%s</a>' % (dict[object], name)
        return name

    def modulelink(self, object):
        """Make a link for a module."""
        return '<a href="%s.html">%s</a>' % (object.__name__, object.__name__)

    def modpkglink(self, (name, path, ispackage, shadowed)):
        """Make a link for a module or package to display in an index."""
        if shadowed:
            return '<font color="#909090">%s</font>' % name
        if path:
            url = '%s.%s.html' % (path, name)
        else:
            url = '%s.html' % name
        if ispackage:
            text = '<strong>%s</strong>&nbsp;(package)' % name
        else:
            text = name
        return '<a href="%s">%s</a>' % (url, text)

    def markup(self, text, escape=None, funcs={}, classes={}, methods={}):
        """Mark up some plain text, given a context of symbols to look for.
        Each context dictionary maps object names to anchor names."""
        escape = escape or self.escape
        results = []
        here = 0
        pattern = re.compile(r'\b(((http|ftp)://\S+[\w/])|'
                                r'(RFC[- ]?(\d+))|'
                                r'(self\.)?(\w+))\b')
        while 1:
            match = pattern.search(text, here)
            if not match: break
            start, end = match.span()
            results.append(escape(text[here:start]))

            all, url, scheme, rfc, rfcnum, selfdot, name = match.groups()
            if url:
                results.append('<a href="%s">%s</a>' % (url, escape(url)))
            elif rfc:
                url = 'http://www.rfc-editor.org/rfc/rfc%s.txt' % rfcnum
                results.append('<a href="%s">%s</a>' % (url, escape(rfc)))
            else:
                if text[end:end+1] == '(':
                    results.append(self.namelink(name, methods, funcs, classes))
                elif selfdot:
                    results.append('self.<strong>%s</strong>' % name)
                else:
                    results.append(self.namelink(name, classes))
            here = end
        results.append(escape(text[here:]))
        return join(results, '')

    # ---------------------------------------------- type-specific routines

    def doctree(self, tree, modname, classes={}, parent=None):
        """Produce HTML for a class tree as given by inspect.getclasstree()."""
        result = ''
        for entry in tree:
            if type(entry) is type(()):
                c, bases = entry
                result = result + '<dt><font face="helvetica, arial"><small>'
                result = result + self.classlink(c, modname, classes)
                if bases and bases != (parent,):
                    parents = []
                    for base in bases:
                        parents.append(self.classlink(base, modname, classes))
                    result = result + '(' + join(parents, ', ') + ')'
                result = result + '\n</small></font></dt>'
            elif type(entry) is type([]):
                result = result + \
                    '<dd>\n%s</dd>\n' % self.doctree(entry, modname, classes, c)
        return '<dl>\n%s</dl>\n' % result

    def docmodule(self, object):
        """Produce HTML documentation for a module object."""
        name = object.__name__
        result = ''
        head = '<br><big><big><strong>&nbsp;%s</strong></big></big>' % name
        try:
            file = inspect.getsourcefile(object)
            filelink = '<a href="file:%s">%s</a>' % (file, file)
        except TypeError:
            filelink = '(built-in)'
        if hasattr(object, '__version__'):
            head = head + ' (version: %s)' % self.escape(object.__version__)
        result = result + self.heading(
            head, '#ffffff', '#7799ee', '<a href=".">index</a><br>' + filelink)

        second = lambda list: list[1]
        modules = map(second, inspect.getmembers(object, inspect.ismodule))

        classes, cdict = [], {}
        for key, value in inspect.getmembers(object, inspect.isclass):
            if (inspect.getmodule(value) or object) is object:
                classes.append(value)
                cdict[key] = cdict[value] = '#' + key
        funcs, fdict = [], {}
        for key, value in inspect.getmembers(object, inspect.isroutine):
            if inspect.isbuiltin(value) or inspect.getmodule(value) is object:
                funcs.append(value)
                fdict[key] = '#-' + key
                if inspect.isfunction(value): fdict[value] = fdict[key]
        for c in classes:
            for base in c.__bases__:
                key, modname = base.__name__, base.__module__
                if modname != name and sys.modules.has_key(modname):
                    module = sys.modules[modname]
                    if hasattr(module, key) and getattr(module, key) is base:
                        if not cdict.has_key(key):
                            cdict[key] = cdict[base] = modname + '.html#' + key
        constants = []
        for key, value in inspect.getmembers(object, isconstant):
            if key[:1] != '_':
                constants.append((key, value))

        doc = self.markup(getdoc(object), self.preformat, fdict, cdict)
        doc = doc and '<tt>%s</tt>' % doc
        result = result + '<p><small>%s</small></p>\n' % doc

        if hasattr(object, '__path__'):
            modpkgs = []
            modnames = []
            for file in os.listdir(object.__path__[0]):
                if file[:1] != '_':
                    path = os.path.join(object.__path__[0], file)
                    modname = modulename(file)
                    if modname and modname not in modnames:
                        modpkgs.append((modname, name, 0, 0))
                        modnames.append(modname)
                    elif ispackage(path):
                            modpkgs.append((file, name, 1, 0))
            modpkgs.sort()
            contents = self.multicolumn(modpkgs, self.modpkglink)
            result = result + self.bigsection(
                'Package Contents', '#ffffff', '#aa55cc', contents)

        elif modules:
            contents = self.multicolumn(modules, self.modulelink)
            result = result + self.bigsection(
                'Modules', '#fffff', '#aa55cc', contents)

        if classes:
            contents = self.doctree(
                inspect.getclasstree(classes, 1), name, cdict)
            for item in classes:
                contents = contents + self.document(item, fdict, cdict)
            result = result + self.bigsection(
                'Classes', '#ffffff', '#ee77aa', contents)
        if funcs:
            contents = ''
            for item in funcs:
                contents = contents + self.document(item, fdict, cdict)
            result = result + self.bigsection(
                'Functions', '#ffffff', '#eeaa77', contents)

        if constants:
            contents = ''
            for key, value in constants:
                contents = contents + ('<br><strong>%s</strong> = %s' %
                                       (key, self.repr(value)))
            result = result + self.bigsection(
                'Constants', '#ffffff', '#55aa55', contents)

        return result

    def docclass(self, object, funcs={}, classes={}):
        """Produce HTML documentation for a class object."""
        name = object.__name__
        bases = object.__bases__
        contents = ''

        methods, mdict = [], {}
        for key, value in inspect.getmembers(object, inspect.ismethod):
            methods.append(value)
            mdict[key] = mdict[value] = '#' + name + '-' + key
        for item in methods:
            contents = contents + self.document(
                item, funcs, classes, mdict, name)

        title = '<a name="%s">class <strong>%s</strong></a>' % (name, name)
        if bases:
            parents = []
            for base in bases:
                parents.append(self.classlink(base, object.__module__, classes))
            title = title + '(%s)' % join(parents, ', ')
        doc = self.markup(getdoc(object), self.preformat,
                          funcs, classes, mdict)
        if doc: doc = '<small><tt>' + doc + '<br>&nbsp;</tt></small>'
        return self.section(title, '#000000', '#ffc8d8', contents, 10, doc)

    def docmethod(self, object, funcs={}, classes={}, methods={}, clname=''):
        """Produce HTML documentation for a method object."""
        return self.document(
            object.im_func, funcs, classes, methods, clname)

    def formatvalue(self, object):
        """Format an argument default value as text."""
        return ('<small><font color="#909090">=%s</font></small>' %
                self.repr(object))

    def docfunction(self, object, funcs={}, classes={}, methods={}, clname=''):
        """Produce HTML documentation for a function object."""
        args, varargs, varkw, defaults = inspect.getargspec(object)
        argspec = inspect.formatargspec(
            args, varargs, varkw, defaults, formatvalue=self.formatvalue)

        if object.__name__ == '<lambda>':
            decl = '<em>lambda</em> ' + argspec[1:-1]
        else:
            anchor = clname + '-' + object.__name__
            decl = '<a name="%s"\n><strong>%s</strong>%s</a>\n' % (
                anchor, object.__name__, argspec)
        doc = self.markup(getdoc(object), self.preformat,
                          funcs, classes, methods)
        doc = replace(doc, ('<br>\n', '</tt></small\n><dd><small><tt>'))
        doc = doc and '<tt>%s</tt>' % doc
        return '<dl><dt>%s<dd><small>%s</small></dl>' % (decl, doc)

    def docbuiltin(self, object, *extras):
        """Produce HTML documentation for a built-in function."""
        return '<dl><dt><strong>%s</strong>(...)</dl>' % object.__name__

    def page(self, object):
        """Produce a complete HTML page of documentation for an object."""
        return '''<!doctype html public "-//W3C//DTD HTML 4.0 Transitional//EN">
<html><title>Python: %s</title>
<body bgcolor="#ffffff">
%s
</body></html>
''' % (describe(object), self.document(object))

    def index(self, dir, shadowed=None):
        """Generate an HTML index for a directory of modules."""
        modpkgs = []
        if shadowed is None: shadowed = {}
        seen = {}
        files = os.listdir(dir)

        def found(name, ispackage,
                  modpkgs=modpkgs, shadowed=shadowed, seen=seen):
            if not seen.has_key(name):
                modpkgs.append((name, '', ispackage, shadowed.has_key(name)))
                seen[name] = 1
                shadowed[name] = 1

        # Package spam/__init__.py takes precedence over module spam.py.
        for file in files:
            path = os.path.join(dir, file)
            if ispackage(path): found(file, 1)
        for file in files:
            path = os.path.join(dir, file)
            if file[:1] != '_' and os.path.isfile(path): 
                modname = modulename(file)
                if modname: found(modname, 0)

        modpkgs.sort()
        contents = self.multicolumn(modpkgs, self.modpkglink)
        return self.bigsection(dir, '#ffffff', '#ee77aa', contents)

# -------------------------------------------- text documentation generator

class TextRepr(Repr):
    """Class for safely making a text representation of a Python object."""
    def __init__(self):
        Repr.__init__(self)
        self.maxlist = self.maxtuple = self.maxdict = 10
        self.maxstring = self.maxother = 50

    def repr1(self, x, level):
        methodname = 'repr_' + join(split(type(x).__name__), '_')
        if hasattr(self, methodname):
            return getattr(self, methodname)(x, level)
        else:
            return cram(cleanid(repr(x)), self.maxother)

    def repr_instance(self, x, level):
        try:
            return cram(cleanid(repr(x)), self.maxstring)
        except:
            return '<%s instance>' % x.__class__.__name__

class TextDoc(Doc):
    """Formatter class for text documentation."""

    # ------------------------------------------- text formatting utilities

    _repr_instance = TextRepr()
    repr = _repr_instance.repr

    def bold(self, text):
        """Format a string in bold by overstriking."""
        return join(map(lambda ch: ch + '\b' + ch, text), '')

    def indent(self, text, prefix='    '):
        """Indent text by prepending a given prefix to each line."""
        if not text: return ''
        lines = split(text, '\n')
        lines = map(lambda line, prefix=prefix: prefix + line, lines)
        if lines: lines[-1] = rstrip(lines[-1])
        return join(lines, '\n')

    def section(self, title, contents):
        """Format a section with a given heading."""
        return self.bold(title) + '\n' + rstrip(self.indent(contents)) + '\n\n'

    # ---------------------------------------------- type-specific routines

    def doctree(self, tree, modname, parent=None, prefix=''):
        """Render in text a class tree as returned by inspect.getclasstree()."""
        result = ''
        for entry in tree:
            if type(entry) is type(()):
                cl, bases = entry
                result = result + prefix + classname(cl, modname)
                if bases and bases != (parent,):
                    parents = map(lambda cl, m=modname: classname(cl, m), bases)
                    result = result + '(%s)' % join(parents, ', ')
                result = result + '\n'
            elif type(entry) is type([]):
                result = result + self.doctree(
                    entry, modname, cl, prefix + '    ')
        return result

    def docmodule(self, object):
        """Produce text documentation for a given module object."""
        result = ''

        name = object.__name__
        lines = split(strip(getdoc(object)), '\n')
        if len(lines) == 1:
            if lines[0]: name = name + ' - ' + lines[0]
            lines = []
        elif len(lines) >= 2 and not rstrip(lines[1]):
            if lines[0]: name = name + ' - ' + lines[0]
            lines = lines[2:]
        result = result + self.section('NAME', name)
        try: file = inspect.getfile(object) # XXX or getsourcefile?
        except TypeError: file = None
        result = result + self.section('FILE', file or '(built-in)')
        if lines:
            result = result + self.section('DESCRIPTION', join(lines, '\n'))

        classes = []
        for key, value in inspect.getmembers(object, inspect.isclass):
            if (inspect.getmodule(value) or object) is object:
                classes.append(value)
        funcs = []
        for key, value in inspect.getmembers(object, inspect.isroutine):
            if inspect.isbuiltin(value) or inspect.getmodule(value) is object:
                funcs.append(value)
        constants = []
        for key, value in inspect.getmembers(object, isconstant):
            if key[:1] != '_':
                constants.append((key, value))

        if hasattr(object, '__path__'):
            modpkgs = []
            for file in os.listdir(object.__path__[0]):
                if file[:1] != '_':
                    path = os.path.join(object.__path__[0], file)
                    modname = modulename(file)
                    if modname and modname not in modpkgs:
                        modpkgs.append(modname)
                    elif ispackage(path):
                        modpkgs.append(file + ' (package)')
            modpkgs.sort()
            result = result + self.section(
                'PACKAGE CONTENTS', join(modpkgs, '\n'))

        if classes:
            contents = self.doctree(
                inspect.getclasstree(classes, 1), object.__name__) + '\n'
            for item in classes:
                contents = contents + self.document(item) + '\n'
            result = result + self.section('CLASSES', contents)

        if funcs:
            contents = ''
            for item in funcs:
                contents = contents + self.document(item) + '\n'
            result = result + self.section('FUNCTIONS', contents)

        if constants:
            contents = ''
            for key, value in constants:
                line = key + ' = ' + self.repr(value)
                chop = 70 - len(line)
                line = self.bold(key) + ' = ' + self.repr(value)
                if chop < 0: line = line[:chop] + '...'
                contents = contents + line + '\n'
            result = result + self.section('CONSTANTS', contents)

        if hasattr(object, '__version__'):
            version = str(object.__version__)
            if hasattr(object, '__date__'):
                version = version + ', ' + str(object.__date__)
            result = result + self.section('VERSION', version)

        if hasattr(object, '__author__'):
            author = str(object.__author__)
            if hasattr(object, '__email__'):
                author = author + ' <' + str(object.__email__) + '>'
            result = result + self.section('AUTHOR', author)

        return result

    def docclass(self, object):
        """Produce text documentation for a given class object."""
        name = object.__name__
        bases = object.__bases__

        title = 'class ' + self.bold(name)
        if bases:
            parents = map(lambda c, m=object.__module__: classname(c, m), bases)
            title = title + '(%s)' % join(parents, ', ')

        doc = getdoc(object)
        contents = doc and doc + '\n'
        methods = map(lambda (key, value): value,
                      inspect.getmembers(object, inspect.ismethod))
        for item in methods:
            contents = contents + '\n' + self.document(item)

        if not contents: return title + '\n'
        return title + '\n' + self.indent(rstrip(contents), ' |  ') + '\n'

    def docmethod(self, object):
        """Produce text documentation for a method object."""
        return self.document(object.im_func)

    def formatvalue(self, object):
        """Format an argument default value as text."""
        return '=' + self.repr(object)

    def docfunction(self, object):
        """Produce text documentation for a function object."""
        try:
            args, varargs, varkw, defaults = inspect.getargspec(object)
            argspec = inspect.formatargspec(
                args, varargs, varkw, defaults, formatvalue=self.formatvalue)
        except TypeError:
            argspec = '(...)'

        if object.__name__ == '<lambda>':
            decl = '<lambda> ' + argspec[1:-1]
        else:
            decl = self.bold(object.__name__) + argspec
        doc = getdoc(object)
        if doc:
            return decl + '\n' + rstrip(self.indent(doc)) + '\n'
        else:
            return decl + '\n'

    def docbuiltin(self, object):
        """Produce text documentation for a built-in function object."""
        return (self.bold(object.__name__) + '(...)\n' +
                rstrip(self.indent(object.__doc__)) + '\n')

# --------------------------------------------------------- user interfaces

def pager(text):
    """The first time this is called, determine what kind of pager to use."""
    global pager
    pager = getpager()
    pager(text)

def getpager():
    """Decide what method to use for paging through text."""
    if type(sys.stdout) is not types.FileType:
        return plainpager
    if not sys.stdin.isatty() or not sys.stdout.isatty():
        return plainpager
    if os.environ.has_key('PAGER'):
        return lambda a: pipepager(a, os.environ['PAGER'])
    if sys.platform in ['win', 'win32', 'nt']:
        return lambda a: tempfilepager(a, 'more')
    if hasattr(os, 'system') and os.system('less 2>/dev/null') == 0:
        return lambda a: pipepager(a, 'less')

    import tempfile
    filename = tempfile.mktemp()
    open(filename, 'w').close()
    try:
        if hasattr(os, 'system') and os.system('more %s' % filename) == 0:
            return lambda text: pipepager(text, 'more')
        else:
            return ttypager
    finally:
        os.unlink(filename)

def pipepager(text, cmd):
    """Page through text by feeding it to another program."""
    pipe = os.popen(cmd, 'w')
    try:
        pipe.write(text)
        pipe.close()
    except IOError:
        # Ignore broken pipes caused by quitting the pager program.
        pass

def tempfilepager(text, cmd):
    """Page through text by invoking a program on a temporary file."""
    import tempfile
    filename = tempfile.mktemp()
    file = open(filename, 'w')
    file.write(text)
    file.close()
    try:
        os.system(cmd + ' ' + filename)
    finally:
        os.unlink(filename)

def plain(text):
    """Remove boldface formatting from text."""
    return re.sub('.\b', '', text)

def ttypager(text):
    """Page through text on a text terminal."""
    lines = split(plain(text), '\n')
    try:
        import tty
        fd = sys.stdin.fileno()
        old = tty.tcgetattr(fd)
        tty.setcbreak(fd)
        getchar = lambda: sys.stdin.read(1)
    except ImportError:
        tty = None
        getchar = lambda: sys.stdin.readline()[:-1][:1]

    try:
        r = inc = os.environ.get('LINES', 25) - 1
        sys.stdout.write(join(lines[:inc], '\n') + '\n')
        while lines[r:]:
            sys.stdout.write('-- more --')
            sys.stdout.flush()
            c = getchar()

            if c in ['q', 'Q']:
                sys.stdout.write('\r          \r')
                break
            elif c in ['\r', '\n']:
                sys.stdout.write('\r          \r' + lines[r] + '\n')
                r = r + 1
                continue
            if c in ['b', 'B', '\x1b']:
                r = r - inc - inc
                if r < 0: r = 0
            sys.stdout.write('\n' + join(lines[r:r+inc], '\n') + '\n')
            r = r + inc

    finally:
        if tty:
            tty.tcsetattr(fd, tty.TCSAFLUSH, old)

def plainpager(text):
    """Simply print unformatted text.  This is the ultimate fallback."""
    sys.stdout.write(plain(text))

def describe(thing):
    """Produce a short description of the given kind of thing."""
    if inspect.ismodule(thing):
        if thing.__name__ in sys.builtin_module_names:
            return 'built-in module ' + thing.__name__
        if hasattr(thing, '__path__'):
            return 'package ' + thing.__name__
        else:
            return 'module ' + thing.__name__
    if inspect.isbuiltin(thing):
        return 'built-in function ' + thing.__name__
    if inspect.isclass(thing):
        return 'class ' + thing.__name__
    if inspect.isfunction(thing):
        return 'function ' + thing.__name__
    if inspect.ismethod(thing):
        return 'method ' + thing.__name__
    return repr(thing)

def locate(path):
    """Locate an object by name (or dotted path), importing as necessary."""
    if not path: # special case: imp.find_module('') strangely succeeds
        return None, None
    if type(path) is not types.StringType:
        return None, path
    if hasattr(__builtins__, path):
        return None, getattr(__builtins__, path)
    parts = split(path, '.')
    n = 1
    while n <= len(parts):
        path = join(parts[:n], '.')
        try:
            module = __import__(path)
            module = reload(module)
        except:
            # Did the error occur before or after we found the module?
            if sys.modules.has_key(path):
                filename = sys.modules[path].__file__
            elif sys.exc_type is SyntaxError:
                filename = sys.exc_value.filename
            else:
                # module not found, so stop looking
                break
            # error occurred in the imported module, so report it
            raise DocImportError(filename, sys.exc_type, sys.exc_value)
        try:
            x = module
            for p in parts[1:]:
                x = getattr(x, p)
            return join(parts[:-1], '.'), x
        except AttributeError:
            n = n + 1
            continue
    return None, None

# --------------------------------------- interactive interpreter interface

text = TextDoc()
html = HTMLDoc()

def doc(thing):
    """Display documentation on an object (for interactive use)."""
    if type(thing) is type(""):
        try:
            path, x = locate(thing)
        except DocImportError, value:
            print 'problem in %s - %s' % (value.filename, value.args)
            return
        if x:
            thing = x
        else:
            print 'could not find or import %s' % repr(thing)
            return

    desc = describe(thing)
    module = inspect.getmodule(thing)
    if module and module is not thing:
        desc = desc + ' in module ' + module.__name__
    pager('Help on %s:\n\n' % desc + text.document(thing))

def writedocs(path, pkgpath=''):
    if os.path.isdir(path):
        dir = path
        for file in os.listdir(dir):
            path = os.path.join(dir, file)
            if os.path.isdir(path):
                writedocs(path, file + '.' + pkgpath)
            if os.path.isfile(path):
                writedocs(path, pkgpath)
    if os.path.isfile(path):
        modname = modulename(path)
        if modname:
            writedoc(pkgpath + modname)

def writedoc(key):
    """Write HTML documentation to a file in the current directory."""
    path, object = locate(key)
    if object:
        file = open(key + '.html', 'w')
        file.write(html.page(object))
        file.close()
        print 'wrote', key + '.html'

class Helper:
    def __repr__(self):
        return """To get help on a Python object, call help(object).
To get help on a module or package, either import it before calling
help(module) or call help('modulename')."""

    def __call__(self, *args):
        if args:
            doc(args[0])
        else:
            print repr(self)

help = Helper()

def man(key):
    """Display documentation on an object in a form similar to man(1)."""
    path, object = locate(key)
    if object:
        title = 'Python Library Documentation: ' + describe(object)
        if path: title = title + ' in ' + path
        pager('\n' + title + '\n\n' + text.document(object))
        found = 1
    else:
        print 'could not find or import %s' % repr(key)

def apropos(key):
    """Print all the one-line module summaries that contain a substring."""
    key = lower(key)
    for module in sys.builtin_module_names:
        desc = __import__(module).__doc__ or ''
        desc = split(desc, '\n')[0]
        if find(lower(module + ' ' + desc), key) >= 0:
            print module, '-', desc or '(no description)'
    modules = []
    for dir in pathdirs():
        for module, desc in index(dir):
            desc = desc or ''
            if module not in modules:
                modules.append(module)
                if find(lower(module + ' ' + desc), key) >= 0:
                    desc = desc or '(no description)'
                    if module[-9:] == '.__init__':
                        print module[:-9], '(package) -', desc
                    else:
                        print module, '-', desc

# --------------------------------------------------- web browser interface

def serve(address, callback=None):
    import BaseHTTPServer, mimetools

    # Patch up mimetools.Message so it doesn't break if rfc822 is reloaded.
    class Message(mimetools.Message):
        def __init__(self, fp, seekable=1):
            Message = self.__class__
            Message.__bases__[0].__bases__[0].__init__(self, fp, seekable)
            self.encodingheader = self.getheader('content-transfer-encoding')
            self.typeheader = self.getheader('content-type')
            self.parsetype()
            self.parseplist()

    class DocHandler(BaseHTTPServer.BaseHTTPRequestHandler):
        def send_document(self, title, contents):
            self.send_response(200)
            self.send_header('Content-Type', 'text/html')
            self.end_headers()
            self.wfile.write(
'''<!doctype html public "-//W3C//DTD HTML 4.0 Transitional//EN">
<html><title>Python: %s</title><body bgcolor="#ffffff">''' % title)
            self.wfile.write(contents)
            self.wfile.write('</body></html>')

        def do_GET(self):
            path = self.path
            if path[-5:] == '.html': path = path[:-5]
            if path[:1] == '/': path = path[1:]
            if path and path != '.':
                try:
                    p, x = locate(path)
                except DocImportError, value:
                    self.send_document(path, html.escape(
                        'problem with %s - %s' % (value.filename, value.args)))
                    return
                if x:
                    self.send_document(describe(x), html.document(x))
                else:
                    self.send_document(path,
'There is no Python module or object named "%s".' % path)
            else:
                heading = html.heading(
                    '<br><big><big><strong>&nbsp;'
                    'Python: Index of Modules'
                    '</strong></big></big>',
                    '#ffffff', '#7799ee')
                builtins = []
                for name in sys.builtin_module_names:
                    builtins.append('<a href="%s.html">%s</a>' % (name, name))
                indices = ['<p>Built-in modules: ' + join(builtins, ', ')]
                seen = {}
                for dir in pathdirs():
                    indices.append(html.index(dir, seen))
                self.send_document('Index of Modules', heading + join(indices))

        def log_message(self, *args): pass

    class DocServer(BaseHTTPServer.HTTPServer):
        def __init__(self, address, callback):
            self.callback = callback
            self.base.__init__(self, address, self.handler)

        def server_activate(self):
            self.base.server_activate(self)
            if self.callback: self.callback()

    DocServer.base = BaseHTTPServer.HTTPServer
    DocServer.handler = DocHandler
    DocHandler.MessageClass = Message
    try:
        DocServer(address, callback).serve_forever()
    except KeyboardInterrupt:
        print 'server stopped'

# -------------------------------------------------- command-line interface

if __name__ == '__main__':
    import getopt
    class BadUsage: pass

    try:
        opts, args = getopt.getopt(sys.argv[1:], 'k:p:w')
        writing = 0

        for opt, val in opts:
            if opt == '-k':
                apropos(lower(val))
                break
            if opt == '-p':
                try:
                    port = int(val)
                except ValueError:
                    raise BadUsage
                def ready(port=port):
                    print 'server ready at http://127.0.0.1:%d/' % port
                serve(('127.0.0.1', port), ready)
                break
            if opt == '-w':
                if not args: raise BadUsage
                writing = 1
        else:
            if args:
                for arg in args:
                    try:
                        if os.path.isfile(arg):
                            arg = importfile(arg)
                        if writing:
                            if os.path.isdir(arg): writedocs(arg)
                            else: writedoc(arg)
                        else: man(arg)
                    except DocImportError, value:
                        print 'problem in %s - %s' % (
                            value.filename, value.args)
            else:
                if sys.platform in ['mac', 'win', 'win32', 'nt']:
                    # GUI platforms with threading
                    import threading
                    ready = threading.Event()
                    address = ('127.0.0.1', 12346)
                    threading.Thread(
                        target=serve, args=(address, ready.set)).start()
                    ready.wait()
                    import webbrowser
                    webbrowser.open('http://127.0.0.1:12346/')
                else:
                    raise BadUsage

    except (getopt.error, BadUsage):
        print """%s <name> ...
    Show documentation on something.
    <name> may be the name of a Python function, module, or package,
    or a dotted reference to a class or function within a module or
    module in a package, or the filename of a Python module to import.

%s -k <keyword>
    Search for a keyword in the synopsis lines of all modules.

%s -p <port>
    Start an HTTP server on the given port on the local machine.

%s -w <module> ...
    Write out the HTML documentation for a module to a file.

%s -w <moduledir>
    Write out the HTML documentation for all modules in the tree
    under a given directory to files in the current directory.
""" % ((sys.argv[0],) * 5)
