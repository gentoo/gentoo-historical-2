# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/waproamd/waproamd-0.6-r1.ebuild,v 1.1 2004/10/09 16:20:41 brix Exp $

inherit eutils

DESCRIPTION="Wireless roaming daemon for configuring wireless settings"

HOMEPAGE="http://www.stud.uni-hamburg.de/~lennart/projects/waproamd/"
SRC_URI="http://0pointer.de/lennart/projects/waproamd/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/libdaemon-0.5"

src_unpack() {
	unpack ${A}

	cp ${FILESDIR}/waproamd.initd ${S}/conf/waproamd.init.in

	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
	econf --disable-lynx --with-initdir=${D}/etc/init.d/ || die
	emake || die
}

src_install() {
	einstall || die
	dodoc README
	insinto /etc/conf.d
	newins ${FILESDIR}/waproamd.confd waproamd
}
