# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmpeg3/libmpeg3-1.5-r1.ebuild,v 1.1 2002/04/15 21:46:16 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="An mpeg library for linux"
SRC_URI="http://heroinewarrior.com/${P}.tar.gz"
HOMEPAGE="http://heroinewarrior.com/libmpeg3.php3"

RDEPEND="sys-libs/zlib 
	media-libs/jpeg"

DEPEND="${RDEPEND}
	dev-lang/nasm"

src_unpack() {

	unpack ${A}
	cd ${S}

	# The Makefile is patched to install the header files as well.
	# This patch was generated using the info in the src.rpm that
	# SourceForge provides for this package.
	patch -p1 < ${FILESDIR}/libmpeg3-gentoo-patch-part1
}

src_compile() {
	
	export CFLAGS=${CFLAGS}
	make ${myconf} || die
}

src_install () {

	# This patch patches the .h files that get installed into /usr/include
	# to show the correct include syntax '<>' instead of '""'  This patch
	# was also generated using info from SF's src.rpm

	patch -p1 < ${FILESDIR}/libmpeg3-gentoo-patch-part2
	
	dodir /usr/bin
	
	make \
		DESTDIR=${D}/usr \
		install || die
	
	dolib.a ${CHOST%%-*}/libmpeg3.a
	
#	insinto /usr/include/libmpeg3/${CHOST%%-*}
#	doins *.{h,inc}

#	insinto /usr/include/libmpeg3/audio
#	doins audio/*.h

#	insinto /usr/include/libmpeg3/video
#	doins video/*.h

	dohtml docs/*.html

}
