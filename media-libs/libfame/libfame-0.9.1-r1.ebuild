# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libfame/libfame-0.9.1-r1.ebuild,v 1.7 2005/05/10 16:44:13 flameeyes Exp $

inherit flag-o-matic gcc eutils

PATCHLEVEL="1"
DESCRIPTION="MPEG-1 and MPEG-4 video encoding library"
HOMEPAGE="http://fame.sourceforge.net/"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz
	http://digilander.libero.it/dgp85/gentoo/${PN}-patches-${PATCHLEVEL}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86 ~ppc64"
IUSE="mmx sse"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}

	[ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ] || \
		EPATCH_EXCLUDE="${EPATCH_EXCLUDE} 02_all_mmx-configure.patch 03_all_gcc34.patch"

	EPATCH_SUFFIX="patch" epatch ${WORKDIR}/${PV}

	# Do not add -march=i586, bug #41770.
	sed -i -e 's:-march=i[345]86 ::g' configure
}

src_compile() {
#	filter-flags -fprefetch-loop-arrays
	econf \
		$(use_enable mmx) \
		$(use_enable sse) \
		|| die "configure failed"

	emake || die "make failed"
}

src_install() {
	dodir /usr
	dodir /usr/lib

	einstall install || die "make install failed"
	dobin libfame-config

	insinto /usr/share/aclocal
	doins libfame.m4

	dodoc CHANGES README
	doman doc/*.3
}
