# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libfame/libfame-0.9.1.ebuild,v 1.1 2004/09/27 02:02:27 morfic Exp $

inherit flag-o-matic gnuconfig gcc

DESCRIPTION="MPEG-1 and MPEG-4 video encoding library"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz"
HOMEPAGE="http://fame.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~ia64 ppc64"
IUSE="mmx sse"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}

	cd ${S}
	# Do not add -march=i586, bug #41770.
	sed -i -e 's:-march=i[345]86 ::g' configure

	#closing bug #45736
	if [ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ]
	then
		epatch ${FILESDIR}/${P}-mmx_configure.patch
		epatch ${FILESDIR}/${P}-gcc34.patch
	fi

	# This is needed for alpha and probably other newer arches (amd64)
	# (13 Jan 2004 agriffis)
	gnuconfig_update
}

src_compile() {
#	filter-flags -fprefetch-loop-arrays
	econf $(use_enable mmx) $(use_enable sse) || die
	emake || die
}

src_install() {
	dodir /usr
	dodir /usr/lib

	einstall install || die
	dobin libfame-config

	insinto /usr/share/aclocal
	doins libfame.m4

	dodoc CHANGES README
	doman doc/*.3
}
