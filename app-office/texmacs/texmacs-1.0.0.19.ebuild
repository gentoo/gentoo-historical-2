# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# /space/gentoo/cvsroot/gentoo-x86/skel.ebuild,v 1.3 2002/02/04 15:46:51 gbevin Exp

S=${WORKDIR}/TeXmacs-${PV}-src
DESCRIPTION="GNU TeXmacs is a free GUI scientific editor, inspired by TeX and GNU Emacs."
SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-${PV}-src.tar.gz
	 ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-600dpi-fonts.tar.gz"
HOMEPAGE="http://www.texmacs.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

DEPEND=">=app-text/tetex-1.0.7-r7
	>=dev-util/guile-1.3.4
	>=x11-base/xfree-4.2.0-r5"

RDEPEND="${DEPEND}
	app-text/ghostscript"

src_compile() {
       
       cd ${S}
       ./configure
       cd src
       mv common.makefile common.makefile.orig
       cat common.makefile.orig | sed -e 's|CXXOPTIMIZE = -O3 -fexpensive-optimizations -fno-exceptions|CXXOPTIMIZE = -O0|g' > common.makefile

       cd ${S}
       make || die
}


src_install() {

	cd ${S}
	make DESTDIR=${D} install || die
	
	cd ${WORKDIR}
	dodir /usr/share/texmf
	cp -r fonts ${D}/usr/share/texmf/
	
	cd ${S}
	dodoc COMPILE COPYING LICENSE
}
