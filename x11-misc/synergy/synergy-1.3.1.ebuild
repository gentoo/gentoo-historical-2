# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/synergy/synergy-1.3.1.ebuild,v 1.11 2008/02/24 17:59:49 flameeyes Exp $

inherit eutils autotools

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple computers."
SRC_URI="mirror://sourceforge/${PN}2/${P}.tar.gz"
HOMEPAGE="http://synergy2.sourceforge.net/"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86 ~x86-fbsd"
SLOT="0"
IUSE=""

RDEPEND="x11-libs/libXtst
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/kbproto
	x11-proto/xineramaproto
	x11-libs/libXt"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Remove -Werror usage.
	sed -i -e '/ACX_CXX_WARNINGS_ARE_ERRORS/d' \
		configure.in || die "unable to sed out -Werror usage."
	eautoreconf
}

src_compile() {
	econf --sysconfdir=/etc \
		--disable-dependency-tracking || die
	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
	insinto /etc
	doins "${S}"/examples/synergy.conf
}

pkg_postinst() {
	elog
	elog "${PN} can also be used to connect to computers running Windows."
	elog "Visit ${HOMEPAGE} to find the Windows client."
	elog
}
