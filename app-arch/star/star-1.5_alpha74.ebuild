# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/star/star-1.5_alpha74.ebuild,v 1.7 2007/02/05 14:56:59 armin76 Exp $

DESCRIPTION="An enhanced (world's fastest) tar, as well as enhanced mt/rmt"
HOMEPAGE="http://cdrecord.berlios.de/old/private/star.html"
SRC_URI="ftp://ftp.berlios.de/pub/${PN}/alpha/${PN}-${PV/_alpha/a}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1 CDDL-Schily"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE=""

DEPEND="virtual/libc"

S=${WORKDIR}/${P/_alpha[0-9][0-9]}

src_unpack() {
	unpack ${A}
	cd ${S}/DEFAULTS
	sed -i \
		-e 's:/opt/schily:/usr:g' \
		-e 's:bin:root:g' \
		-e 's:/usr/src/linux/include:/usr/include:' \
		Defaults.linux

	if use amd64 ; then
		cd ${S}/RULES
		cp i386-linux-cc.rul x86_64-linux-cc.rul
		cp i386-linux-gcc.rul x86_64-linux-gcc.rul
	fi

	if use ppc64 ; then
		cd ${S}/RULES
		cp ppc-linux-cc.rul ppc64-linux-cc.rul
		cp ppc-linux-gcc.rul ppc64-linux-gcc.rul
	fi

}

src_compile() {
	emake COPTX="${CFLAGS}" || die
}

src_install() {
	make INS_BASE=${D}/usr install || die
	insinto /etc/default
	newins ${S}/rmt/rmt.dfl rmt

	# install mt as mt.star to not conflict with other packages
	mv ${D}/usr/bin/mt ${D}/usr/bin/mt.star

	# same goes for rmt (see #33119, sort of)
	mv ${D}/usr/sbin/rmt ${D}/usr/sbin/rmt.star

	# finally, remove /usr/bin/tar and /usr/bin/gnutar #33119
	rm ${D}/usr/bin/tar ${D}/usr/bin/gnutar

	dosym star /usr/bin/ustar

	dodoc BUILD Changelog AN-1.* README README.* PORTING TODO

	rm ${D}/usr/man/man1/match*
	dodir /usr/share/
	mv ${D}/usr/man/ ${D}/usr/share

	mv ${D}/usr/share/man/man1/rmt.1.gz ${D}/usr/share/man/man1/rmt.star.1.gz
}
