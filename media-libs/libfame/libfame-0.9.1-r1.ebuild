# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libfame/libfame-0.9.1-r1.ebuild,v 1.26 2009/02/15 00:08:23 loki_val Exp $

inherit flag-o-matic toolchain-funcs eutils

PATCHLEVEL="2"
DESCRIPTION="MPEG-1 and MPEG-4 video encoding library"
HOMEPAGE="http://fame.sourceforge.net/"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz
	http://digilander.libero.it/dgp85/gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 sh sparc x86"
IUSE="mmx"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/${PV}

	# Do not add -march=i586, bug #41770.
	sed -i -e 's:-march=i[345]86 ::g' configure
	epatch "${FILESDIR}/${P}-gcc43.patch"
}

src_compile() {
#	filter-flags -fprefetch-loop-arrays
	econf \
		$(use_enable mmx) \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	make install DESTDIR="${D}" || die "make install failed"
	dodoc CHANGES README
}
