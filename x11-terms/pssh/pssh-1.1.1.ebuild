# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/pssh/pssh-1.1.1.ebuild,v 1.1 2004/11/04 11:17:36 voxus Exp $

DESCRIPTION="This package provides parallel versions of the openssh tools."
HOMEPAGE="http://www.theether.org/pssh/"
SRC_URI="http://www.theether.org/pssh/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=">=dev-lang/python-2.2"
RDEPEND="net-misc/openssh"

src_install() {
	dodoc AUTHORS COPYING TODO COPYING

#	FIXME: how can i get current python version?
	PY_VER=`ls /usr/lib | grep python | sort | tail -n 1`
	PY_DIR=/usr/lib/${PY_VER}/site-packages

	cd bin

	for n in `ls`;
	do
		sed -e "s/python2\.2/${PY_VER/\./\\.}/" $n > $n.v
		mv $n.v $n
	done;

	dobin {pnuke,prsync,pscp,pslurp,pssh}

	cd ..

	insinto ${PY_DIR}
	doins `find lib -type f`
}
