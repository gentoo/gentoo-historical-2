# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tclxml/tclxml-2.6.ebuild,v 1.7 2004/12/22 21:31:44 kloeri Exp $

DESCRIPTION="Pure Tcl implementation of an XML parser."
HOMEPAGE="http://tclxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"
IUSE=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc alpha"
DEPEND=">=dev-lang/tcl-8.3.3"

src_compile() {
	econf || die
	make || die

	# Need to hack the config script.
	sed -i 's:NONE:/usr:' TclxmlConfig.sh
}

src_install() {
	einstall || die
	dodoc ChangeLog LICENSE README RELNOTES
}
