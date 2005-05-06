# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellaclock/gkrellaclock-0.3.2.1.ebuild,v 1.9 2005/05/06 00:16:03 swegener Exp $

inherit multilib

IUSE=""
S=${WORKDIR}/${P/a/A}
DESCRIPTION="Nice analog clock for GKrellM2"
SRC_URI="http://www.geocities.com/m_muthukumar/${P}.tar.gz"
HOMEPAGE="http://www.geocities.com/m_muthukumar/gkrellaclock.html"

DEPEND=">=app-admin/gkrellm-2"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 sparc alpha ppc amd64"

src_compile() {
	export CFLAGS="${CFLAGS/-O?/}"
	emake || die
}

src_install () {
	insinto /usr/$(get_libdir)/gkrellm2/plugins
	doins gkrellaclock.so
	dodoc README ChangeLog
}
