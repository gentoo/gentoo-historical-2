# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jens Blaesche <mr.big@pc-trouble.de>
# /home/cvsroot/gentoo-x86/skel.build,v 1.7 2001/08/25 21:15:08 chadh Exp
# 16.Sept.2001 23.35 CET

MY_P=${P/-/_}
S=${WORKDIR}/${P}
DESCRIPTION="a Image-Watcher-Plugin for Gkrellm."
SRC_URI="http://prdownloads.sourceforge.net/gkrellkam/${MY_P}.tar.gz"
HOMEPAGE="http://gkrellkam.sourceforge.net"

DEPEND=">=app-admin/gkrellm-1.2.11"

src_compile() {
	emake || die
}

src_install () {
	exeinto /usr/lib/gkrellm/plugins
	doexe gkrellkam.so

	doman gkrellkam-list.5
	dodoc README ChangeLog COPYING example.list Release
}
