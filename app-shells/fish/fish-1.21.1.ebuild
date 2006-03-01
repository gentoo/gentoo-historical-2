# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/fish/fish-1.21.1.ebuild,v 1.2 2006/03/01 21:09:34 spyderous Exp $

DESCRIPTION="fish is the Friendly Interactive SHell"
HOMEPAGE="http://roo.no-ip.org/fish/"
SRC_URI="http://roo.no-ip.org/fish/files/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RDEPEND="sys-libs/ncurses
	sys-devel/bc
	|| ( (
			x11-libs/libSM
			x11-libs/libXext
		)
		virtual/x11
	)"
DEPEND="${RDEPEND}
	app-doc/doxygen"

src_compile() {
	econf docdir=/usr/share/doc/${PF} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install
}

pkg_postinst() {
	einfo
	einfo "If you want to use fish as your default shell, you need to add it"
	einfo "to /etc/shells. This is not recommended because fish doesn't install"
	einfo "to /bin."
	einfo
	ewarn "Completion files moved to ${ROOT}usr/share/fish/completions."
	ewarn "You may safely delete ${ROOT}etc/fish.d/completions."
	einfo
}
