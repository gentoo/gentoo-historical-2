# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xloadimage/xloadimage-4.1.ebuild,v 1.11 2003/02/11 12:45:20 seemant Exp $

inherit eutils

IUSE="tiff jpeg png"

MY_P=${P/-/.}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Xloadimage is a utility which will view many different types of images under X11"
HOMEPAGE="http://gopher.std.com/homepages/jimf/xloadimage.html"
SRC_URI="ftp://ftp.x.org/R5contrib/${MY_P}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2
	http://cvs.gentoo.org/~seemant/${P}-gentoo.diff.bz2"

SLOT="0"
LICENSE="MIT"
KEYWORDS="x86 sparc ppc alpha"

DEPEND="x11-base/xfree
	tiff? ( media-libs/tiff )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${P}-gentoo.diff
	
	cp Make.conf Make.conf.orig
	sed -e "s:OPT_FLAGS=:OPT_FLAGS=$CFLAGS:" Make.conf.orig >Make.conf
	
	chmod +x ${S}/configure
}

src_install () {
	dobin xloadimage
	dosym /usr/bin/xloadimage /usr/bin/xsetbg
	dosym /usr/bin/xloadimage /usr/bin/xview
	dobin uufilter

	insinto /etc/X11
	doins xloadimagerc

	newman xloadimage.man xloadimage.1
	newman uufilter.man uufilter.1

	dosym /usr/share/man/man1/xloadimage.1.gz /usr/share/man/man1/xsetbg.1.gz
	dosym /usr/share/man/man1/xloadimage.1.gz /usr/share/man/man1/xview.1.gz

	dodoc README
}
