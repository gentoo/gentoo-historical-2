# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/skipstone/skipstone-0.9.2.ebuild,v 1.3 2004/06/25 01:12:11 agriffis Exp $

inherit eutils

IUSE="nls"

DESCRIPTION="GTK+ based web browser based on the Mozilla engine"
SRC_URI="http://www.muhri.net/skipstone/${P}.tar.gz"
HOMEPAGE="http://www.muhri.net/skipstone/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND=">=net-www/mozilla-1.6
	>=x11-libs/gtk+-2.0"

RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	if use nls; then
		epatch ${FILESDIR}/${PN}-gentoo.patch
	fi
}

src_compile() {
	local myconf
	use nls && myconf="${myconf} --enable-nls"
	has_version '>=net-www/mozilla-1.7' && \
	myconf="${myconf} --enable-cvs-mozilla"

	econf ${myconf}
	make PREFIX="/usr/lib/mozilla" || die
}

src_install() {
	einstall \
		PREFIX=${D}/usr \
		LOCALEDIR=${D}/usr/share/locale
	dodoc AUTHORS COPYING README README.copying
}
