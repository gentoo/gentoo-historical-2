# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-office/texmacs/texmacs-1.0.ebuild,v 1.3 2002/08/01 13:09:07 seemant Exp $

S=${WORKDIR}/TeXmacs-${PV}-src
DESCRIPTION="GNU TeXmacs is a free GUI scientific editor, inspired by TeX and GNU Emacs."
SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-${PV}-src.tar.gz
	 ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-600dpi-fonts.tar.gz"
HOMEPAGE="http://www.texmacs.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=app-text/tetex-1.0.7-r7
	>=dev-util/guile-1.3.4
	>=x11-base/xfree-4.2.0-r5"

RDEPEND="${DEPEND}
	app-text/ghostscript"

src_install() {
	cd ${S}
	make DESTDIR=${D} install || die
	
	cd ${WORKDIR}
	dodir /usr/share/texmf
	cp -r fonts ${D}/usr/share/texmf/
	
	cd ${S}
	dodoc COMPILE COPYING LICENSE
}
