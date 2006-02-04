# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ortp/ortp-0.8.1.ebuild,v 1.1 2006/02/04 07:44:13 dragonheart Exp $

DESCRIPTION="Open Real-time Transport Protocol (RTP) stack"
HOMEPAGE="http://www.linphone.org/ortp/"
SRC_URI="http://www.linphone.org/ortp/sources/${P}.tar.gz"

IUSE="ipv6"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND="=dev-libs/glib-2*
		>=dev-util/pkgconfig-0.9.0"
RDEPEND="=dev-libs/glib-2*"

src_compile() {
	econf $(use_enable ipv6) || die 'configure failed'
	emake || die 'make compile failed'
}

src_install() {
	emake DESTDIR=${D} install || die "Make install failed"
	sed -i -e "s:^\(#include <\)\(glib\.h>\)$:\1glib-2.0/\2:" ${D}/usr/include/ortp/rtpport.h

	dodoc README ChangeLog AUTHORS TODO NEWS
	dodoc docs/*.txt
}
