# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/memdump/memdump-1.0.ebuild,v 1.2 2004/10/17 09:54:16 dholm Exp $

DESCRIPTION="Simple memory dumper for UNIX-Like systems"
HOMEPAGE="http://www.porcupine.org/forensics"
SRC_URI="http://www.porcupine.org/forensics/${P}.tar.gz"
LICENSE="IBM"
SLOT="0"
KEYWORDS="x86 ~ppc"
DEPEND="sys-apps/sed
	sys-apps/grep"
RDEPEND="virtual/libc"
IUSE=""

src_compile() {
	emake XFLAGS="${CFLAGS}" OPT= DEBUG= || die
}

src_test() {
	if has userpriv ${FEATURES};
	then
		einfo "Cannot test with FEATURES=userpriv"
	elif [ -x /bin/wc ];
	then
		einfo "testing"
		if [ "`./memdump -s 344 | wc -c`" = "344" ];
		then
			einfo "passed test"
		else
			die "failed test"
		fi
	fi
}

src_install() {
	dosbin memdump
	dodoc README LICENSE
	doman memdump.1
}
