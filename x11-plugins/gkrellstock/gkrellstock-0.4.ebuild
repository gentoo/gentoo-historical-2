# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellstock/gkrellstock-0.4.ebuild,v 1.5 2003/09/06 05:56:25 msterret Exp $

S=${WORKDIR}/${P/s/S}
DESCRIPTION="Get Stock quotes plugin for GKrellM"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://gkrellstock.sourceforge.net/"

DEPEND="=app-admin/gkrellm-1*
	dev-perl/libwww-perl
	dev-perl/Finance-Quote"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 sparc "

src_compile() {
	emake || die
}

src_install () {
	insinto /usr/lib/gkrellm/plugins
	doins gkrellstock.so
	exeinto /usr/X11R6/bin
	doexe GetQuote
	dodoc README ChangeLog COPYING
}
