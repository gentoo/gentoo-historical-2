# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libquicktime/libquicktime-0.9.2_pre1.ebuild,v 1.1 2002/11/04 22:37:24 seemant Exp $

inherit libtool

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://libquicktime.sourceforge.net/"
SRC_URI="mirror://sourceforge/libquicktime/${MY_P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~x86"

IUSE="oggvorbis png jpeg"

DEPEND="media-libs/libdv
	=x11-libs/gtk+-1.2*
	png? ( media-libs/libpng )
	jpeg ( media-libs/jpeg )
	oggvorbis? ( media-libs/libvorbis )"

src_compile() {

	elibtoolize

	local myconf
	
	use mmx \
		&& myconf="${myconf} --enable-mmx" \
		|| myconf="${myconf} --disable-mmx"

	econf ${myconf}
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
