# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/ksplash-ml/ksplash-ml-0.95.2-r1.ebuild,v 1.6 2003/09/05 23:18:18 msterret Exp $

inherit kde-base

need-kde 3

S=${WORKDIR}/ksplashml-${PV}
DESCRIPTION="Fancy splash-screen for KDE 3.x"
SRC_URI="http://www.shadowcom.net/Software/ksplash-ml/ksplashml-${PV}.tgz"
HOMEPAGE="http://www.shadowcom.net/Software/ksplash-ml"

newdepend ">=kde-base/kdebase-3.0"

LICENSE="BSD"

KEYWORDS="x86 ppc"

src_install() {

	kde_src_install

	dodir /etc/env.d
	echo "KSPLASH=${PREFIX}/bin/ksplash" > ${D}/etc/env.d/90ksplash-ml

}
