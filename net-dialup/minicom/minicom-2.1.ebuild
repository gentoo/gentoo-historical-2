# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/minicom/minicom-2.1.ebuild,v 1.1 2003/08/24 12:59:49 mholzer Exp $

DESCRIPTION="Serial Communication Program"
SRC_URI="http://alioth.debian.org/download.php/123/${P}.tar.gz"
HOMEPAGE="http://alioth.debian.org/projects/minicom"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~hppa ~sparc"

DEPEND=">=sys-libs/ncurses-5.2-r3"

src_compile() {
	econf --sysconfdir=/etc/${PN} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc doc/minicom.FAQ
	insinto /etc/minicom
	doins ${FILESDIR}/minirc.dfl 
	
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}

pkg_postinst() {
	einfo "Minicom relies on the net-misc/lrzsz package to transfer"
	einfo "files using the XMODEM, YMODEM and ZMODEM protocols."
	echo
	einfo "If you need the capability of using the above protocols,"
	einfo "make sure to install net-misc/lrzsz."
	echo
}
