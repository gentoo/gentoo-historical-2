# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-selinux/python-selinux-2.12.ebuild,v 1.2 2004/04/08 19:21:28 pebenito Exp $

inherit python
python_version

DESCRIPTION="Python bindings for SELinux functions"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/selinux/"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="x86 ppc sparc"
IUSE=""

DEPEND="dev-lang/python
	sys-libs/libselinux"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_unpack() {
	mkdir -p ${S}
	bzcat ${FILESDIR}/${P}.c.bz2 > ${S}/selinux.c
}

src_compile() {
	cd ${S}
	einfo "Compiling selinux.so for python ${PYVER}"
	gcc -fPIC -shared -o selinux.so -I /usr/include/python${PYVER}/ selinux.c -lselinux || die
}

src_install() {
	insinto /usr/lib/python${PYVER}/site-packages
	doins selinux.so
}
