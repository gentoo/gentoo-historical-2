# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/ksymoops/ksymoops-2.4.10.ebuild,v 1.2 2005/03/17 00:59:38 r3pek Exp $

DESCRIPTION="Utility to decode a kernel oops, or other kernel call traces."
SRC_URI="ftp://ftp.kernel.org/pub/linux/utils/kernel/ksymoops/v2.4/${P}.tar.gz"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/ksymoops/"
DEPEND="virtual/libc >=sys-devel/binutils-2.9.1.0.25"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~alpha ~mips ~sparc ~amd64 ~ia64 ~s390"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S}
	mv Makefile Makefile.orig
	# static/dynamic hack
	# unfortunately, binutils and gcc ebuilds both install a libiberty.a
	# and gcc's is not compatible with binutils libbfd.a
	# linking against a bad mixuture results in missing symbols.
	# linking against the shared (dynamic) objects seems to work.
	sed -e "/^STATIC/s:-Bstatic:-Bdynamic:" -e "s:-O2:${CFLAGS}:" < \
		Makefile.orig > Makefile
	# Note: this problem is fixed as of gcc-2.95.3-r6, so we can remove this
	# fix eventually
}

src_compile() {
	emake all || die
}

src_install() {
	exeinto /usr/bin
	doexe ksymoops
	doman ksymoops.8
	dodoc Changelog README README.XFree86
}
