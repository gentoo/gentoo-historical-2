# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/tuxonice-userui/tuxonice-userui-0.7.2.ebuild,v 1.2 2007/12/28 12:29:06 maekke Exp $

inherit toolchain-funcs eutils

MY_P="suspend2-userui-${PV}"
DESCRIPTION="User Interface for TuxOnIce"
HOMEPAGE="http://www.tuxonice.net"
SRC_URI="http://www.tuxonice.net/downloads/all/${MY_P}.tar.gz
	mirror://gentoo/${MY_P}-fbsplash.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"

IUSE="fbsplash"
DEPEND="fbsplash? (	>=media-gfx/splashutils-1.5.2.1 )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}/${MY_P}-fbsplash.patch"
}

src_compile() {
	# Package contain binaries
	emake clean

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		tuxoniceui_text || die "emake tuxoniceui_text failed"

	if use fbsplash; then
		emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
			tuxoniceui_fbsplash || die "emake tuxoniceui_fbsplash failed"
	fi
}

src_install() {
	into /
	dosbin tuxoniceui_text
	use fbsplash && dosbin tuxoniceui_fbsplash
	dodoc AUTHORS ChangeLog KERNEL_API README TODO USERUI_API
}

pkg_postinst() {
	if use fbsplash; then
		einfo
		einfo "You must create a symlink from /etc/splash/tuxonice"
		einfo "to the theme you want tuxonice to use, e.g.:"
		einfo
		einfo "  # ln -sfn /etc/splash/emergence /etc/splash/tuxonice"
	fi

	einfo
	einfo "Please see /usr/share/doc/${PF}/README.* for further"
	einfo "instructions."
	einfo
}
