# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/povray/povray-3.6.1-r1.ebuild,v 1.6 2004/12/25 00:52:47 weeve Exp $

inherit flag-o-matic

DESCRIPTION="The Persistence Of Vision Ray Tracer"
SRC_URI="ftp://ftp.povray.org/pub/povray/Official/Unix/povray-3.6.tar.bz2"
HOMEPAGE="http://www.povray.org/"

SLOT="0"
LICENSE="povlegal-3.6"
KEYWORDS="x86 ppc ~alpha ~amd64 ppc64 ~sparc"
IUSE="X svga"

DEPEND="media-libs/libpng
	>=media-libs/tiff-3.6.1
	media-libs/jpeg
	sys-libs/zlib
	X? ( virtual/x11 )
	svga? ( media-libs/svgalib )"


src_compile() {
	local myconf

	# closes bug 71255
	if  get-flag march == k6-2 ; then
		filter-flags -fomit-frame-pointer
	fi

	echo ${CFLAGS}

	use X && myconf="${myconf} --with-x" \
		|| myconf="${myconf} --without-x"\
		CFLAGS="${CFLAGS} -DX_DISPLAY_MISSING"
	use svga || myconf="${myconf} --without-svga"

	econf COMPILED_BY="${USER} (on `uname -n`)" ${myconf} || die

	# Copy the user configuration into /etc/skel
	cp Makefile Makefile.orig
	sed -e "s:^povconfuser = .*:povconfuser = ${D}etc/skel/.povray/3.6/:" Makefile.orig >Makefile

	einfo Building povray
	emake || die "build failed"
}

src_install() {
	emake DESTDIR=${D} install || die
}
