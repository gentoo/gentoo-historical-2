# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/xcin/xcin-2.5.2.3.ebuild,v 1.5 2003/02/13 08:48:08 vapier Exp $

IUSE="nls"

DESCRIPTION="Chinese X Input Method"
HOMEPAGE="http://xcin.linux.org.tw/"
SRC_URI="ftp://xcin.linux.org.tw/pub/xcin/xcin/${P}.tar.gz"
LICENSE="XCIN"
SLOT="0"
KEYWORDS="x86 ppc"
DEPEND="nls? ( sys-devel/gettext )"

S=${WORKDIR}/${PN}

src_unpack () {
	unpack ${A}
	cd ${S}/po
	patch -p0 < ${FILESDIR}/xcin-gentoo.patch || die
}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--disable-bimsphone \
		--with-xcin-rcdir=/etc \
		--mandir=/usr/share/man || die "./configure failed"
	make || die
}

src_install () {
	make \
		prefix=${D}/usr \
		xcin_rcp=${D}/etc \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.
}
