# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-selinux/python-selinux-2.7.ebuild,v 1.2 2003/10/13 19:22:00 pebenito Exp $

DESCRIPTION="Python bindings for SELinux functions"
HOMEPAGE="http://selinux.dev.gentoo.org/python"
SRC_URI="http://selinux.dev.gentoo.org/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="sys-libs/libselinux"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_compile() {
	cd ${S}
	gcc -shared -o selinux.so -I /usr/include/python2.2/ selinux.c -lselinux || die
}

src_install() {
	insinto /usr/lib/python2.2/site-packages
	doins selinux.so
}
