# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtimer/wmtimer-2.92-r1.ebuild,v 1.1 2008/10/28 10:13:29 s4t4n Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="Dockable clock which can run in alarm, countdown timer or chronograph mode"
HOMEPAGE="http://www.darkops.net/wmtimer"
SRC_URI="http://www.darkops.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${P}/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e "s:-O2::" -e "s:-g:${CFLAGS}:g" -i Makefile
	epatch "${FILESDIR}"/"${PN}"-counter-fix.patch
}

src_compile() {
	emake CC="$(tc-getCC)" \
		LIBDIR="-L/usr/$(get_libdir)" || die "emake failed."
}

src_install() {
	dobin wmtimer
	dodoc ../{Changelog,CREDITS,README}
}
