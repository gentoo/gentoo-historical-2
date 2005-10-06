# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libherdstat/libherdstat-0.1.0_beta1.ebuild,v 1.1 2005/10/06 18:25:21 ka0ttic Exp $

DESCRIPTION="C++ library offering interfaces for portage-related things such as Gentoo-specific XML files, package searching, and version sorting"
HOMEPAGE="http://developer.berlios.de/projects/libherdstat/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="debug doc curl ncurses static"

RDEPEND=">=dev-libs/xmlwrapp-0.5.0
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	dev-util/pkgconfig"
RDEPEND="${RDEPEND}
	!curl? ( net-misc/wget )"

src_compile() {
	econf \
		$(use_enable debug) \
		$(use_enable static) \
		$(use_with ncurses) \
		$(use_with curl) \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO NEWS

	if use doc ; then
		dohtml -r doc/${PV}/html/*
		doman doc/${PV}/man/*/*.[0-9]
	fi
}
