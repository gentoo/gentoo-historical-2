# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mtr/mtr-0.69.ebuild,v 1.4 2005/05/16 15:20:57 gustavoz Exp $

inherit eutils flag-o-matic

DESCRIPTION="My TraceRoute. Excellent network diagnostic tool."
HOMEPAGE="http://www.bitwizard.nl/mtr/"
SRC_URI="ftp://ftp.bitwizard.nl/mtr/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 sparc x86"
IUSE="gtk gtk2 ipv6"

DEPEND="dev-util/pkgconfig"
RDEPEND=">=sys-libs/ncurses-5.2
	gtk? (
			!gtk2? ( =x11-libs/gtk+-1.2* )
			gtk2? ( >=x11-libs/gtk+-2 )
		)"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-ac-res_mkquery.patch
}

src_compile() {
	autoconf || die "autoconf failed"

	local myconf
	use gtk || myconf="${myconf} --without-gtk"

	append-ldflags -Wl,-z,now

	econf ${myconf} \
		$(use_enable gtk2) \
		$(use_enable ipv6) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	# this binary is universal. ie: it does both console and gtk.
	make DESTDIR=${D} sbindir=/usr/bin install || die "make install failed"

	insinto /usr/share/${PN} ; doins img/mtr_icon.xpm

	fowners root:wheel /usr/bin/mtr
	fperms 4710 /usr/bin/mtr

	dodoc AUTHORS COPYING ChangeLog FORMATS NEWS README SECURITY TODO
}
