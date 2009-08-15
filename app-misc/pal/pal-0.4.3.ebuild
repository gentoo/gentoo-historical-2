# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pal/pal-0.4.3.ebuild,v 1.3 2009/08/15 13:00:06 ssuominen Exp $

EAPI=2
inherit toolchain-funcs eutils

DESCRIPTION="pal command-line calendar program"
HOMEPAGE="http://palcal.sourceforge.net/"
SRC_URI="mirror://sourceforge/palcal/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="nls unicode"

RDEPEND=">=dev-libs/glib-2.0
	sys-libs/readline
	sys-libs/ncurses[unicode?]
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${P}/src

src_prepare() {
	epatch "${FILESDIR}"/${PV}-strip.patch
	epatch "${FILESDIR}"/${PV}-ldflags.patch
	if use unicode; then
		sed -i "/^LIBS/s/-lncurses/&w/" "${S}"/Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" OPT="${CFLAGS}" LDOPT="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install-man install-bin install-share \
		|| die "make install failed"

	if use nls; then
		emake DESTDIR="${D}" install-mo || die "make install-mo failed"
	fi

	dodoc "${WORKDIR}"/${P}/{ChangeLog,doc/example.css} || die "dodoc failed"
}
