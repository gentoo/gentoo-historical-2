# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/tmpwatch/tmpwatch-2.8.4.ebuild,v 1.7 2004/06/06 14:28:26 dragonheart Exp $

RPM_V="4"

DESCRIPTION="Utility recursively searches through specified directories and removes files which have not been accessed in a specified period of time."
SRC_URI="ftp://ftp.redhat.com/pub/redhat/linux/rawhide/SRPMS/SRPMS/${P}-${RPM_V}.src.rpm"
HOMEPAGE="ftp://ftp.redhat.com/pub/redhat/linux/rawhide/SRPMS/SRPMS"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86 ~ppc"

DEPEND="virtual/glibc
	app-arch/rpm2targz"

src_unpack() {
	cd ${WORKDIR}
	rpm2targz ${DISTDIR}/${P}-${RPM_V}.src.rpm
	tar zxf ${P}-${RPM_V}.src.tar.gz
	tar zxf ${P}.tar.gz

	cd ${S}
	sed -i "s:..RPM_OPT_FLAGS.:${CFLAGS}:" \
		Makefile
}

src_compile() {
	emake || die
}

src_install() {
	preplib /usr

	dosbin tmpwatch
	doman tmpwatch.8
}
