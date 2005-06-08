# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/lwp/lwp-2.0.ebuild,v 1.2 2005/06/08 19:10:15 griffon26 Exp $

inherit eutils

DESCRIPTION="Light weight process library (used by Coda).  This is NOT libwww-perl."
HOMEPAGE="http://www.coda.cs.cmu.edu/"
SRC_URI="http://www.coda.cs.cmu.edu/pub/lwp/src/${P}.tar.gz"

SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~mips ~amd64 ~ia64"
IUSE=""

DEPEND="sys-apps/grep
	sys-apps/sed
	sys-devel/libtool
	sys-devel/gcc"

RDEPEND=""

src_unpack() {
	unpack ${A} ; cd ${S}

	# Was introduced for bug #34542, not sure if still needed
	use amd64 && epatch ${FILESDIR}/lwp-2.0-amd64.patch
}

src_install() {
	einstall || die

	dodoc AUTHORS NEWS PORTING README
}
