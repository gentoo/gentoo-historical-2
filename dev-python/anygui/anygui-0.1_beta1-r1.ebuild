# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Tod Neidt <tneidt@fidnet.com>
#$Header $

pv="0.1b1"
S=${WORKDIR}/${PN}-${pv}
DESCRIPTION="Generic GUI Module for Python"
SRC_URI="http://prdownloads.sourceforge.net/anygui/${PN}-${pv}.tar.gz"
HOMEPAGE="http://anygui.sourceforge.net/"

DEPEND=">=dev-lang/python-2.0
	sys-libs/ncurses
        qt? ( =dev-python/PyQt-2.4* ) 
        gtk? ( dev-python/pygtk )
        tcltk? ( dev-lang/tk-8.3.3 )"
#future: 
#       might need a wxw use variable for wxGTK for wxw? ( dev-python/wxPython )
#       also use variable fltk for fltk? ( dev-python/PyFLTK ) no ebuild for PyFLTK yet
#       java? ( dev-python/jython ) Java Swing (javagui) http://www.jython.org
        
src_compile() {

        python setup.py build || die
        
}

src_install() {

        python setup.py install --prefix=${D}/usr || die 

        dodoc CHANGELOG.txt INSTALL.txt KNOWN_BUGS.txt LICENSE.txt \
                MAINTAINERS.txt  PKG-INFO README.txt TODO.txt VERSION.txt
        
}
