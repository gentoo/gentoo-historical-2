# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libmonetra/libmonetra-4.2.ebuild,v 1.1 2004/11/29 07:11:00 robbat2 Exp $

inherit eutils

DESCRIPTION="library for connecting to a MCVE Credit Card Processing Daemon via SSL, TCP/IP, and drop-files."
HOMEPAGE="http://www.mainstreetsoftworks.com/"
SRC_URI="ftp://ftp.mcve.com/pub/libmcve/${P}.tar.gz
	http://www.mainstreetsoftworks.com/freedist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~hppa ~ia64 ~ppc ~s390 ~x86 ppc64 ~sparc ~amd64"
IUSE=""

DEPEND="dev-libs/openssl
	sys-devel/gcc"

src_install() {
	make install DESTDIR="${D}" || die "einstall failed"
}
