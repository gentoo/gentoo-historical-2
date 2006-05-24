# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/getopt/getopt-1.1.4.ebuild,v 1.1 2006/05/24 11:49:47 flameeyes Exp $

inherit toolchain-funcs eutils

DESCRIPTION="getopt(1) replacement supporting GNU-style long options"
HOMEPAGE="http://software.frodo.looijaard.name/getopt/"
SRC_URI="http://software.frodo.looijaard.name/getopt/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-libintl.patch"
	epatch "${FILESDIR}/${P}-longrename.patch"
}

src_compile() {
	local nogettext="1"
	local libintl=""

	if use nls; then
		nogettext=0
		has_version sys-libs/glibc || libintl="-lintl"
	fi

	emake CC="$(tc-getCC)" prefix="/usr" \
		WITHOUT_GETTEXT=${nogettext} LIBINTL=${libintl} \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	use nls && make prefix="/usr" DESTDIR="${D}" install_po

	into /usr
	newbin getopt getopt-long
	newman getopt.1 getopt-long.1

	dodoc "${S}/getopt-"*sh
}
