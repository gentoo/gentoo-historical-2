# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmitime/gkrellmitime-0.5.1.ebuild,v 1.1.1.1 2005/11/30 10:10:53 chriswhite Exp $

IUSE="nls"
DESCRIPTION="Internet Time plugin for Gkrellm"
SRC_URI="http://eric.bianchi.free.fr/gkrellm/${P}.tar.gz"
HOMEPAGE="http://eric.bianchi.free.fr/gkrellm/"

DEPEND="=app-admin/gkrellm-1.2*"
RDEPEND="nls? ( sys-devel/gettext )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc "

src_compile() {

	if use nls
	then
		enable_nls=1 make || die
	else
		make || die
	fi
}

src_install () {
	insinto /usr/lib/gkrellm/plugins
	doins gkrellm_itime.so
	dodoc README ChangeLog COPYING
}
