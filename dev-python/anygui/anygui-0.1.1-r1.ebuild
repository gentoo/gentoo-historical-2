# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/anygui/anygui-0.1.1-r1.ebuild,v 1.20 2004/07/03 12:25:27 kloeri Exp $

IUSE="wxwin gtk qt tcltk"

DESCRIPTION="Generic GUI Module for Python"
SRC_URI="mirror://sourceforge/anygui/${P}.tar.gz"
HOMEPAGE="http://anygui.sourceforge.net/"

DEPEND=">=dev-lang/python-2.0
	sys-libs/ncurses
	qt? ( dev-python/PyQt )
	gtk? ( dev-python/pygtk )
	tcltk? ( dev-lang/tk )
	wxwin? ( dev-python/wxpython )"

#Propsed wxwin use variable for wxGTK for wxWindows? ( dev-python/wxpython ) *NOT* official
#future:
#also use variable fltk for fltk? ( dev-python/PyFLTK ) no ebuild for PyFLTK yet
#java? ( dev-python/jython ) Java Swing (javagui) http://www.jython.org

SLOT="0"
KEYWORDS="x86 sparc alpha"
LICENSE="MIT"

src_compile() {

	python setup.py build || die "Python Build Failed"

}

src_install() {

	python setup.py install --prefix=${D}/usr || die "Python Install Failed"

	dodoc CHANGELOG.txt INSTALL.txt KNOWN_BUGS.txt LICENSE.txt \
	MAINTAINERS.txt  PKG-INFO README.txt TODO.txt VERSION.txt \
	doc/anygui.txt doc/tutorial.txt

	dohtml doc/anygui.html

	insinto /usr/share/doc/${PF}/pdf
	doins doc/anygui.pdf

	insinto /usr/share/doc/${PF}/ps
	doins doc/anygui.ps

}
