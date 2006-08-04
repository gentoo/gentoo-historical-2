# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/evilwm/evilwm-0.99.25.ebuild,v 1.2 2006/08/04 08:35:15 tove Exp $

inherit toolchain-funcs multilib

DESCRIPTION="A minimalist, no frills window manager for X."
SRC_URI="http://www.6809.org.uk/evilwm/${P}.tar.gz"
HOMEPAGE="http://evilwm.sourceforge.net"

IUSE=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc-macos ~sparc x86"

RDEPEND="|| ( x11-libs/libXext virtual/x11 )"

DEPEND="${RDEPEND}
	|| ( (	x11-proto/xextproto
		x11-proto/xproto )
	virtual/x11 )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's/^#define DEF_FONT.*/#define DEF_FONT "fixed"/' evilwm.h \
		|| die "sed font failed"
	sed -i -e '/^CFLAGS/s/ -Os/ /' \
		-e 's/install -s /install /' Makefile || die "sed opt failed"
}

src_compile() {
	emake CC="$(tc-getCC)" XROOT="/usr" LDPATH="-L/usr/$(get_libdir)" || die
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"

	dodoc ChangeLog README TODO || die "dodoc failed"

	echo -e "#!/bin/sh\n/usr/bin/${PN}" > "${T}/${PN}"
	exeinto /etc/X11/Sessions
	doexe "${T}/${PN}" || die "/etc/X11/Sessions failed"

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop" || die "${PN}.desktop failed."
}
