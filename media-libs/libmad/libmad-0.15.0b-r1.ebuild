# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmad/libmad-0.15.0b-r1.ebuild,v 1.1 2003/09/03 20:56:35 lostlogic Exp $

IUSE="debug"

S=${WORKDIR}/${P}

DESCRIPTION="\"M\"peg \"A\"udio \"D\"ecoder library"
HOMEPAGE="http://mad.sourceforge.net"
SRC_URI="mirror://sourceforge/mad/${P}.tar.gz
	http://www.fefe.de/diffs/${P}-speedup.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${P}.tar.gz
	epatch ${DISTDIR}/${P}-speedup.diff.gz
}

src_compile() {
	local myconf

	myconf="--with-gnu-ld --enable-accuracy"
	# --enable-speed         optimize for speed over accuracy
	# --enable-accuracy      optimize for accuracy over speed
	# --enable-experimental  enable code using the EXPERIMENTAL
	#                        preprocessor define

	use debug && myconf="${myconf} --enable-debugging" \
		|| myconf="${myconf} --disable-debugging"

	econf ${myconf} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	einstall || die "make install failed"

	dodoc CHANGES COPYRIGHT CREDITS README TODO VERSION

	# This file must be updated with each version update
	dodir /usr/lib/pkgconfig
	insinto /usr/lib/pkgconfig
	doins ${FILESDIR}/mad.pc
}
