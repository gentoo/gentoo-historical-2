# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xplanet/xplanet-0.94-r1.ebuild,v 1.10 2004/01/25 22:40:44 pyrania Exp $

DESCRIPTION="A program to render images of the earth into the X root window"
HOMEPAGE="http://xplanet.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE="gif jpeg X opengl truetype tiff png"

RDEPEND="virtual/x11
	opengl? ( virtual/opengl
		media-libs/glut )
	gif? ( media-libs/giflib
		media-libs/libungif )
	jpeg? ( media-libs/jpeg )
	tiff? ( media-libs/tiff )
	png? ( media-libs/libpng )
	truetype? ( =media-libs/freetype-2* )"

src_unpack() {
	unpack ${A}
	cd ${S}
	# fix GCC3.2 include re-ordering bug.
	sed -i 's,-I$prefix/include,,' configure
	epatch ${FILESDIR}/${PV}-gcc3.patch
}

src_compile() {
	local myconf

	use X \
		&& myconf="$myconf --with-x" \
		|| myconf="$myconf --with-x=no"

	use opengl \
		&& myconf="--with-gl --with-glut --with-animation" \
		|| myconf="--with-gl=no --with-glut=no --with-animation=no"

	use gif \
		&& myconf="$myconf --with-gif" \
		|| myconf="$myconf --with-gif=no"

	use jpeg \
		&& myconf="${myconf} --with-jpeg" \
		|| myconf="${myconf} --with-jpeg=no"

	use tiff \
		&& myconf="${myconf} --with-tiff" \
		|| myconf="${myconf} --with-tiff=no"

	use png \
		&& myconf="${myconf} --with-png --with-pnm" \
		|| myconf="${myconf} --with-png=no --with-pnm=no"

# Compilation fails with freetype enabled, checking upstream
	use truetype \
		&& myconf="${myconf} --with-freetype" \
		|| myconf="${myconf} --with-freetype=no"
#	myconf="${myconf} --with-freetype=no"

	econf ${myconf} || die

	# xplanet doesn't like to build parallel
	make || die
}

src_install () {
	einstall || die

	dodoc README COPYING CREDITS FAQ INSTALL
}
