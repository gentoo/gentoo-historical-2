# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/qmtest/qmtest-2.3.ebuild,v 1.1 2005/12/27 03:21:32 kanaka Exp $

inherit eutils
DESCRIPTION="CodeSourcery's test harness system"
HOMEPAGE="http://www.codesourcery.com/qmtest/"
MY_P=qm-${PV}
SRC_URI="http://www.codesourcery.com/public/${PN}/${MY_P}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/python"

S=${WORKDIR}/${MY_P}

src_compile() {
	python setup.py build || die "setup.py build failed"
}

src_install() {
	python setup.py install --prefix ${D}/usr || die "setup.py install failed"
}

