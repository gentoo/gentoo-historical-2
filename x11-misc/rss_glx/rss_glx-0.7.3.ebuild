# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/rss_glx/rss_glx-0.7.3.ebuild,v 1.1 2003/02/23 20:57:23 vapier Exp $

DESCRIPTION="OpenGL screensavers, ported to GLX.  Suitable for use with xscreensaver"
HOMEPAGE="http://rss-glx.sourceforge.net/"
SRC_URI="mirror://sourceforge/rss-glx/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"

DEPEND="x11-base/xfree"

src_compile() {
	econf --bindir=/usr/lib/xscreensaver || die
	emake || die
}

src_install() {
	einstall bindir="${D}/usr/lib/xscreensaver"
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README README.xscreensaver
}

pkg_postinst() {
	echo
	einfo "Read /usr/share/doc/${PF}/README.xscreensaver.gz for"
	einfo "entries to add to your ~/.xscreensaver file to enable these hacks"
	echo
}
