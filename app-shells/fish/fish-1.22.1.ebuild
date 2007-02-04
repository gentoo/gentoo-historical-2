# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/fish/fish-1.22.1.ebuild,v 1.5 2007/02/04 18:49:31 beandog Exp $

DESCRIPTION="fish is the Friendly Interactive SHell"
HOMEPAGE="http://fishshell.org/"
SRC_URI="http://fishshell.org/files/${PV}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc X"
RDEPEND="sys-libs/ncurses
	sys-devel/bc
	www-client/htmlview
	X? ( x11-misc/xsel )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_compile() {
	econf \
		docdir=/usr/share/doc/${PF} \
		--without-xsel \
		|| die "econf failed"
	emake || die "emake failed"
	if use doc; then
		emake doc || die "emake doc failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install
}

pkg_postinst() {
	elog
	elog "If you want to use fish as your default shell, you need to add it"
	elog "to /etc/shells. This is not recommended because fish doesn't install"
	elog "to /bin."
	elog
	ewarn "Many files moved to ${ROOT}usr/share/fish/completions from /etc/fish.d/."
	ewarn "Delete everything in ${ROOT}etc/fish.d/ except fish_interactive.fish."
	ewarn "Otherwise, fish won't notice updates to the installed files,"
	ewarn "because the ones in /etc will override the new ones in /usr."
	echo
}
