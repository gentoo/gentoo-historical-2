# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/getopt/getopt-1.1.4.ebuild,v 1.3 2010/02/20 05:29:40 abcd Exp $

EAPI=3

inherit toolchain-funcs eutils

DESCRIPTION="getopt(1) replacement supporting GNU-style long options"
HOMEPAGE="http://software.frodo.looijaard.name/getopt/"
SRC_URI="http://software.frodo.looijaard.name/getopt/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~sparc-fbsd ~x86-fbsd ~x86-interix ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}/${P}-libintl.patch"
	epatch "${FILESDIR}/${P}-longrename.patch"

	# hopefully this is portable enough
	epatch "${FILESDIR}"/${P}-irix.patch
}

src_compile() {
	local nogettext="1"
	local libintl=""
	local libcgetopt=1

	if use nls; then
		nogettext=0
		has_version sys-libs/glibc || libintl="-lintl"
	fi

	[[ ${CHOST} == *-irix* ]] && libcgetopt=0
	[[ ${CHOST} == *-interix* ]] && libcgetopt=0

	emake CC="$(tc-getCC)" prefix="${EPREFIX}/usr" \
		LIBCGETOPT=${libcgetopt} \
		WITHOUT_GETTEXT=${nogettext} LIBINTL=${libintl} \
		CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	use nls && make prefix="${EPREFIX}/usr" DESTDIR="${D}" install_po

	into /usr
	newbin getopt getopt-long
	newman getopt.1 getopt-long.1

	dodoc "${S}/getopt-"*sh
}
