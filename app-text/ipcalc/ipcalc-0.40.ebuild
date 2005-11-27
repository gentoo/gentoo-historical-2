# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/ipcalc/ipcalc-0.40.ebuild,v 1.1 2005/11/27 02:13:27 vanquirius Exp $

DESCRIPTION="calculates broadcast/network/etc... from an IP address and netmask"
HOMEPAGE="http://jodies.de/ipcalc"
SRC_URI="http://jodies.de/ipcalc-archive/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.0"

src_install () {
	dobin ${PN} || die
	dodoc changelog
}
