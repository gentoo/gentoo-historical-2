# Copyright 2003 Arcady Genkin <agenkin@gentoo.org>
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclxml/tclxml-2.4.ebuild,v 1.4 2003/08/07 03:21:11 vapier Exp $

DESCRIPTION="Pure Tcl implementation of an XML parser."
HOMEPAGE="http://tclxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~alpha"

DEPEND=">=dev-lang/tcl-8.3.3"

src_compile() {
	econf || die
	make || die

        # Need to hack the config script.
        sed 's:NONE:/usr:' < TclxmlConfig.sh > TclxmlConfig.sh.hacked
        mv TclxmlConfig.sh.hacked TclxmlConfig.sh
}

src_install() {
        einstall || die
        dodoc ChangeLog LICENSE README RELNOTES
}
