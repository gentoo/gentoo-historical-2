# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/httrack/httrack-3.32.2.ebuild,v 1.1 2005/03/18 14:46:09 seemant Exp $

MY_P=${PN}-3.32.03
DESCRIPTION="HTTrack Website Copier, Open Source Offline Browser"
HOMEPAGE="http://www.httrack.com/"
SRC_URI="http://www.httrack.com/${PN}-3.32-2.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ppc ~amd64 ~sparc"
IUSE=""

DEPEND="virtual/libc"
S="${WORKDIR}/${MY_P}"

src_compile() {
	econf || die "econf failed"
	emake -j1 || die "make failed"
}

src_install() {
	einstall || die "Failed on einstall"
	dodoc AUTHORS COPYING INSTALL README
	dodoc greetings.txt history.txt
	dohtml httrack-doc.html
}
