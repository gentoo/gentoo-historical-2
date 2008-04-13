# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat-xsys/xchat-xsys-2.2.0.ebuild,v 1.5 2008/04/13 01:02:35 chainsaw Exp $

inherit toolchain-funcs eutils

MY_P="${P/xchat-/}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Sysinfo plugin for X-Chat."
SRC_URI="http://dev.gentoo.org/~chainsaw/xsys/download/${MY_P}.tar.bz2 mirror://gentoo/${MY_P}.tar.bz2"
HOMEPAGE="http://dev.gentoo.org/~chainsaw/xsys/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 ~sparc x86"

RDEPEND="|| (
		>=net-irc/xchat-2.4.0
		>=net-irc/xchat-gnome-0.4
	)
	sys-apps/pciutils
	>=media-sound/audacious-1.4.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	emake -j1 CC="$(tc-getCC)" || die "Compile failed"
}

src_install() {
	exeinto /usr/$(get_libdir)/xchat/plugins
	doexe xsys-${PV}.so || die "doexe failed"

	exeinto /usr/$(get_libdir)/xchat-gnome/plugins
	doexe xsys-${PV}.so || die "doexe failed"

	dodoc ChangeLog README || die "dodoc failed"
}
