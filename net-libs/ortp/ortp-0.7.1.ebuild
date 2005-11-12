# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/ortp/ortp-0.7.1.ebuild,v 1.1 2005/11/12 04:36:03 dragonheart Exp $

DESCRIPTION="Open Real-time Transport Protocol (RTP) stack"
HOMEPAGE="http://www.linphone.org/ortp/"
SRC_URI="http://www.linphone.org/ortp/sources/${P}.tar.gz"

IUSE="ipv6"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"

DEPEND=">=dev-libs/glib-2.0.0
		>=dev-util/pkgconfig-0.9.0"
RDEPEND=">=dev-libs/glib-2.0.0"

src_compile() {
	econf $(use_enable ipv6) || die 'configure failed'
	emake || die 'make compile failed'
}

src_install() {
	emake DESTDIR=${D} install || die "Make install failed"

	dodoc README ChangeLog AUTHORS TODO NEWS
	dodoc docs/*.txt
}
