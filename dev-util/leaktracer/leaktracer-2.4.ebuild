# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/leaktracer/leaktracer-2.4.ebuild,v 1.5 2004/07/02 05:10:03 eradicator Exp $

inherit eutils

DESCRIPTION="trace and analyze memory leaks in C++ programs"
HOMEPAGE="http://www.andreasen.org/LeakTracer/"
SRC_URI="mirror://gentoo/${P}.tbz2"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND="virtual/libc
	>=dev-lang/perl-5
	sys-devel/gdb"

src_compile() {
	epatch ${FILESDIR}/LeakCheck-gentoo.patch
	make || die
}

src_install() {
	dobin LeakCheck leak-analyze || die "dobin failed"
	dolib.so LeakTracer.so || die "dolib.so failed"
	dohtml README.html
	dodoc README VERSION
}

pkg_postinst() {
	einfo "To use LeakTracer, run LeakCheck my_prog and then leak-analyze my_prog leak.out"
	einfo "Please reffer to README file for more info."
}
