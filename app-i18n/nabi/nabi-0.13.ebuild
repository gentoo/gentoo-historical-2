# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/nabi/nabi-0.13.ebuild,v 1.5 2005/01/01 14:36:24 eradicator Exp $

DESCRIPTION="Simple Hanguk X Input Method"
HOMEPAGE="http://nabi.kldp.net/"
SRC_URI="http://download.kldp.net/nabi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86 ~ppc"

DEPEND=">=x11-libs/gtk+-2.2"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING* ChangeLog README NEWS
}

pkg_postinst() {
	einfo "You MUST add environment variable...                           "
	einfo "                                                               "
	einfo "export XMODIFIERS=\"@im=nabi\"                                 "
	einfo "export XIM_PROGRAM=/usr/bin/nabi // for /xinit.xinitrx.d/xinput"
	einfo "                                                               "
}
