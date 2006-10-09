# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mtr/mtr-0.71.ebuild,v 1.2 2006/10/09 10:12:05 jokey Exp $

inherit eutils flag-o-matic

DESCRIPTION="My TraceRoute. Excellent network diagnostic tool."
HOMEPAGE="http://www.bitwizard.nl/mtr/"
SRC_URI="ftp://ftp.bitwizard.nl/mtr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc-macos ~s390 ~sparc ~x86"
IUSE="gtk ipv6"

DEPEND="dev-util/pkgconfig
	sys-libs/ncurses
	gtk? ( >=x11-libs/gtk+-2 )"

src_compile() {
	autoconf || die "autoconf failed"

	local myconf
	use gtk || myconf="${myconf} --without-gtk"

	use ppc-macos && append-flags "-DBIND_8_COMPAT"
	append-ldflags $(bindnow-flags)

	econf ${myconf} \
		$(use_enable gtk gtk2) \
		$(use_enable ipv6) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	# this binary is universal. ie: it does both console and gtk.
	make DESTDIR="${D}" sbindir=/usr/bin install || die "make install failed"

	insinto /usr/share/${PN} ; doins img/mtr_icon.xpm

	fowners root:wheel /usr/bin/mtr
	fperms 4710 /usr/bin/mtr

	dodoc AUTHORS ChangeLog FORMATS NEWS README SECURITY TODO
}
