# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdparanoia/cdparanoia-3.10.2.ebuild,v 1.1 2008/09/21 21:42:42 aballier Exp $

inherit autotools eutils flag-o-matic libtool toolchain-funcs versionator

MY_P=${PN}-III-$(get_version_component_range 2-3)

DESCRIPTION="an advanced CDDA reader with error correction"
HOMEPAGE="http://www.xiph.org/paranoia"
SRC_URI="http://downloads.xiph.org/releases/cdparanoia/${MY_P}.src.tgz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch \
		"${FILESDIR}"/${PN}-3.10.2-use-destdir.patch \
		"${FILESDIR}"/${PN}-3.10.2-Makefile.in.patch

	mv configure.guess config.guess
	mv configure.sub config.sub
	sed -i -e '/configure.\(guess\|sub\)/d' configure.in || die "sed failed."

	eautoconf
	elibtoolize
}

src_compile() {
	tc-export CC AR RANLIB
	append-flags -I"${S}/interface"
	econf
	emake OPT="${CFLAGS}" || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc README
}
