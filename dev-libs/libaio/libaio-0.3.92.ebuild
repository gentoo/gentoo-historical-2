# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libaio/libaio-0.3.92.ebuild,v 1.1 2003/11/30 15:55:45 brad_mssw Exp $

DESCRIPTION="Asynchronous input/output library maintained by RedHat, required by Oracle9i AMD64 edition"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="http://www.kernel.org/pub/linux/kernel/people/bcrl/aio/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa amd64"
IUSE="nls"

DEPEND=""

src_compile() {
	make || die
}

src_install() {
	make \
		prefix=${D}/usr \
		install || die
}
