# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellaclock/gkrellaclock-0.3.2.ebuild,v 1.9 2004/04/30 21:01:09 pvdabeel Exp $

IUSE=""
S=${WORKDIR}/${P/a/A}
DESCRIPTION="Nice analog clock for GKrellM2"
SRC_URI="http://www.geocities.com/m_muthukumar/${P}.tar.gz"
HOMEPAGE="http://www.geocities.com/m_muthukumar/gkrellaclock.html"

DEPEND=">=app-admin/gkrellm-2*"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc alpha ppc"

src_compile() {
	export CFLAGS="${CFLAGS/-O?/}"
	emake || die
}

src_install () {
	insinto /usr/lib/gkrellm2/plugins
	doins gkrellaclock.so
	dodoc README ChangeLog
}
