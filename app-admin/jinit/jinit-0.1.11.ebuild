# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/jinit/jinit-0.1.11.ebuild,v 1.6 2004/06/25 17:46:13 vapier Exp $

DESCRIPTION="An alternative to sysvinit which supports the need(8) concept"
HOMEPAGE="http://homepage.ntlworld.com/john.fremlin/programs/linux/jinit/ http://www.atnf.csiro.au/~rgooch/linux/boot-scripts/"
SRC_URI="http://homepage.ntlworld.com/john.fremlin/programs/linux/jinit/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"
IUSE=""

DEPEND="virtual/libc"
RDEPEND=""

src_compile() {
	econf || die "econf failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	mv ${D}/usr/sbin ${D}/
	mv ${D}/sbin/init ${D}/sbin/jinit
	dodoc AUTHORS ChangeLog NEWS README TODO
	cp -R example-setup ${D}/usr/share/doc/${PF}/

	#find ${D}/usr/share/doc/${PF}/example-setup -name "Makefile*"
}
