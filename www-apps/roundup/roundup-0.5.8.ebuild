# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/roundup/roundup-0.5.8.ebuild,v 1.1 2004/08/15 15:36:30 stuart Exp $

S="${WORKDIR}/${P}"
DESCRIPTION="Simple-to-use and -install issue-tracking system with command-line, web, and e-mail interfaces."
SRC_URI="mirror://sourceforge/roundup/${P}.tar.gz"
HOMEPAGE="http://roundup.sourceforge.net"
KEYWORDS="~x86 ~sparc"
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
}

pkg_postinst() {
	einfo
	einfo "Run 'roundup-admin install' to set up a roundup instance"
	einfo
}
