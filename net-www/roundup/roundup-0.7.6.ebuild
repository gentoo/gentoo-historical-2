# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/roundup/roundup-0.7.6.ebuild,v 1.2 2004/08/09 18:03:25 gustavoz Exp $

inherit eutils

DESCRIPTION="Simple-to-use and -install issue-tracking system with command-line, web, and e-mail interfaces."
SRC_URI="mirror://sourceforge/roundup/${P}.tar.gz"
HOMEPAGE="http://roundup.sourceforge.net"
KEYWORDS="x86 sparc ~amd64 ~ppc"
LICENSE="as-is"
SLOT="0"

DEPEND=">=dev-lang/python-2.2
	>=sys-libs/db-3.2.9"

src_compile() {
	python setup.py build || die
}

src_install() {
	python setup.py install --root=${D} --prefix=/usr || die
	dodoc CHANGES.txt PKG-INFO README.txt doc/*.txt
	dohtml doc/*.html
	dobin ${FILESDIR}/roundup
}

pkg_postinst() {
	einfo
	ewarn "As a non privileged user! (not root)"
	einfo "Run 'roundup-admin install' to set up a roundup instance"
	einfo "Then edit your config.py file in the tracker home you setup"
	einfo "Run 'roundup-admin initialise' to setup the admin pass"
	einfo "run /usr/bin/roundup start port host [your tracker home] and all should work!"
	einfo "run /usr/bin/roundup stop [your tracker home] to stop the server"
	einfo "log is in [tracker home]/roundup.log"
	einfo "pid file is in [tracker home]/roundup.pid"
	einfo
	einfo "See upgrading.txt for upgrading instructions."
}
