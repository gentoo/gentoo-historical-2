# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellkam/gkrellkam-0.3.4.ebuild,v 1.1.1.1 2005/11/30 10:10:37 chriswhite Exp $

MY_P=${P/-/_}
IUSE=""
DESCRIPTION="a Image-Watcher-Plugin for Gkrellm."
SRC_URI="mirror://sourceforge/gkrellkam/${MY_P}.tar.gz"
HOMEPAGE="http://gkrellkam.sourceforge.net"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc"

DEPEND="=app-admin/gkrellm-1.2*"

src_install () {
	exeinto /usr/lib/gkrellm/plugins
	doexe gkrellkam.so

	doman gkrellkam-list.5
	dodoc README ChangeLog COPYING example.list Release
}
