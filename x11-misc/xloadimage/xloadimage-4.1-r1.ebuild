# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xloadimage/xloadimage-4.1-r1.ebuild,v 1.12 2003/11/13 14:28:15 tuxus Exp $

inherit eutils

MY_P="${P/-/.}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="utility to view many different types of images under X11"
HOMEPAGE="http://world.std.com/~jimf/xloadimage.html"
SRC_URI="ftp://ftp.x.org/R5contrib/${MY_P}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 sparc ppc alpha arm hppa amd64 mips"
IUSE="tiff jpeg png"

DEPEND=">=sys-apps/sed-4.0.5
	x11-base/xfree
	tiff? ( media-libs/tiff )
	png? ( media-libs/libpng )
	jpeg? ( media-libs/jpeg )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${WORKDIR}/${P}-gentoo.diff

	# Do not define errno extern, but rather include errno.h
	# <azarah@gentoo.org> (1 Jan 2003)
	epatch ${FILESDIR}/${P}-include-errno_h.patch

	sed -i "s:OPT_FLAGS=:OPT_FLAGS=$CFLAGS:" Make.conf

	chmod +x ${S}/configure
	sed -i "s:^#include <varargs.h>:#include <stdarg.h>:" ${S}/rlelib.c
}

src_install() {
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
