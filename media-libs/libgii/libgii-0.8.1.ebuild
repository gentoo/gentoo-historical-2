# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libgii/libgii-0.8.1.ebuild,v 1.8 2002/12/09 04:26:12 manson Exp $

IUSE="X"


S=${WORKDIR}/${P}
DESCRIPTION="Fast and safe graphics and drivers for about any graphics card to the Linux kernel (sometimes)"
SRC_URI="http://www.ggi-project.org/ftp/ggi/v2.0/${P}.tar.bz2"
HOMEPAGE="http://www.ggi-project.org/"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND="X? ( virtual/x11 )"

src_compile() {

	local myconf

	use X || myconf="--without-x --disable-x --disable-xwin"

	econf ${myconf} || die
	emake || die

}

src_install () {

	make DESTDIR=${D} install || die

	cd ${D}/usr/share/man/man3
	for i in *.3gii
	do
		mv ${i} ${i%.3gii}.3
	done

	cd ${S}
	dodoc ChangeLog* FAQ NEWS README
	docinto txt
	dodoc doc/*.txt
	docinto docbook
	dodoc doc/docbook/*.sgml

}
