# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellshoot/gkrellshoot-0.4.1.ebuild,v 1.3 2002/12/09 04:41:57 manson Exp $

S=${WORKDIR}/${P/s/S}
DESCRIPTION="GKrellm2 plugin to take screen shots and lock screen"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://gkrellshoot.sourceforge.net/"

DEPEND=">=app-admin/gkrellm-2*"	

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc "

src_compile() {
	
	export CFLAGS="${CFLAGS/-O?/}"

	make || die
}

src_install () {
	insinto /usr/lib/gkrellm2/plugins
	doins gkrellshoot.so
	dodoc README ChangeLog
}
