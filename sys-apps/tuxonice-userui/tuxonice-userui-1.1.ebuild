# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tuxonice-userui/tuxonice-userui-1.1.ebuild,v 1.1 2012/10/20 08:17:47 pacho Exp $

EAPI=4
inherit toolchain-funcs eutils

DESCRIPTION="User Interface for TuxOnIce"
HOMEPAGE="http://www.tuxonice.net"
SRC_URI="http://tuxonice.net/files/${P}.tar.gz -> ${P}.tar
	mirror://debian/pool/main/t/${PN}/${PN}_${PV}-2~exp1.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="fbsplash"
DEPEND="fbsplash? ( >=media-gfx/splashutils-1.5.2.1
	media-libs/libmng[lcms]
	>=media-libs/libpng-1.4.8[static-libs]
	media-libs/freetype[static-libs]
	|| ( <app-arch/bzip2-1.0.6-r3[static] >=app-arch/bzip2-1.0.6-r3[static-libs] )
	media-libs/lcms:0[static-libs] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	local d=${WORKDIR}/debian/patches
	EPATCH_SOURCE=${d} epatch $(<"${d}"/series)
	sed -i -e 's/make/$(MAKE)/' Makefile || die
}

src_compile() {
	# Package contain binaries
	emake clean

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		tuxoniceui || die "emake tuxoniceui_text failed"

	if use fbsplash; then
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
			fbsplash || die "emake tuxoniceui_fbsplash failed"
	fi
}

src_install() {
	into /
	dosbin tuxoniceui
	dodoc AUTHORS ChangeLog KERNEL_API README TODO USERUI_API
}

pkg_postinst() {
	if use fbsplash; then
		einfo
		elog "You must create a symlink from /etc/splash/tuxonice"
		elog "to the theme you want tuxonice to use, e.g.:"
		elog
		elog "  # ln -sfn /etc/splash/emergence /etc/splash/tuxonice"
	fi
	einfo
	einfo "Please see /usr/share/doc/${PF}/README.* for further"
	einfo "instructions."
	einfo
}
