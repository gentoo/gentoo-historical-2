# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-pmu/gkrellm-pmu-2.0.ebuild,v 1.1 2003/12/05 03:48:02 pylon Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GKrellM2 plugin for battery display on Apple machines"
SRC_URI="http://www.cymes.de/members/joker/projects/gkrellm-pmu/${P}.tar.gz"
HOMEPAGE="http://www.cymes.de/members/joker/projects/gkrellm-pmu/gkrellm-pmu.html"

DEPEND="=app-admin/gkrellm-2*"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~ppc"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc COPYING ChangeLog INSTALL README
}
