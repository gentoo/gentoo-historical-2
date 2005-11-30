# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Andreas Voegele <voegelas@users.sourceforge.net>
# Maintainer: Mikael Hallendal <hallski@gentoo.org>
# /home/cvsroot/gentoo-x86/skel.build,v 1.9 2001/10/21 16:17:12 agriffis Exp

S=${WORKDIR}/${P}
DESCRIPTION="A PostScript viewer for X11"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/ghostview/"

DEPEND="virtual/glibc
        virtual/x11"

RDEPEND="${DEPEND}
	>=app-text/ghostscript-6.50-r2"

src_unpack() { 
	unpack ${A}
	# This patch contains all the Debian patches and enables anti-aliasing.
	patch -p0 < ${FILESDIR}/${PF}-gentoo.diff
}

src_compile() {
	xmkmf -a || die
	cp Makefile Makefile.old
	sed -e "s,all:: ghostview.\$(MANSUFFIX).html,all:: ,g" Makefile.old > Makefile
	emake || die
}

src_install() {
	dobin ghostview
	newman ghostview.man ghostview.1
	insinto /etc/X11/app-defaults
	newins Ghostview.ad Ghostview
	dodoc COPYING HISTORY README comments.doc
}
