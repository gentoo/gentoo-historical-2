# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/nas/nas-1.5.ebuild,v 1.10 2003/09/06 23:59:48 msterret Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Network Audio System"
SRC_URI="http://radscan.com/nas/${P}.src.tar.gz"
HOMEPAGE="http://radscan.com/nas.html"

SLOT="0"
LICENSE="X11"
KEYWORDS="x86 sparc ~ppc hppa alpha"

# This is ridculuous, we only need xmkmf, but no other package
# provides it. 20020607 (Seemant): Actually, the homepage says it needs
# the entire X11 build environment, so this is ok.
DEPEND="virtual/x11"

src_compile() {
	xmkmf
	touch doc/man/lib/tmp.{_man,man}
	emake World || die
}

src_install () {
	make DESTDIR=${D} install || die
	make DESTDIR=${D} install.man || die

	for i in ${D}/usr/X11R6/man/man?/*.?x
	do
		gzip -9 $i
	done

	dodoc BUGS BUILDNOTES FAQ HISTORY README RELEASE TODO
	mv ${D}/usr/X11R6/lib/X11/doc/html ${D}/usr/share/doc/${P}/
	rmdir ${D}/usr/X11R6/lib/X11/doc


}
