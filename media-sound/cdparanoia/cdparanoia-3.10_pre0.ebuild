# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/cdparanoia/cdparanoia-3.10_pre0.ebuild,v 1.3 2007/10/20 17:36:51 drac Exp $

WANT_AUTOCONF=2.1

inherit autotools eutils libtool toolchain-funcs versionator

MY_P=${PN}-III-$(get_version_component_range 2)$(get_version_component_range 3)

DESCRIPTION="an advanced CDDA reader with error correction"
HOMEPAGE="http://www.xiph.org/paranoia"
SRC_URI="http://downloads.xiph.org/releases/cdparanoia/${MY_P}.src.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-include-cdda_interface_h.patch
	epatch "${FILESDIR}"/${P}-use-destdir.patch
	epatch "${FILESDIR}"/${P}-Makefile.in.patch

	mv configure.guess config.guess
	mv configure.sub config.sub
	sed -i -e '/configure.\(guess\|sub\)/d' configure.in

	eautoconf
	elibtoolize
}

src_compile() {
	tc-export CC AR RANLIB
	econf
	emake OPT="${CFLAGS}" || die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc FAQ.txt README
}
