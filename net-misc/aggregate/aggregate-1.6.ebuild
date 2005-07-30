# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/aggregate/aggregate-1.6.ebuild,v 1.10 2005/07/30 17:52:12 swegener Exp $

DESCRIPTION="aggregate takes a list of prefixes in conventional format on stdin, and performs two optimisations to reduce the length of the prefix list."
BASE_URI="http://dist.automagic.org/"
HOMEPAGE="${BASE_URI}"
SRC_URI="${BASE_URI}/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc alpha ~hppa ia64 amd64 ~sparc ~mips"
IUSE=""
DEPEND=""
RDEPEND="dev-lang/perl"

src_install() {
	dobin aggregate aggregate-ios
	doman aggregate.1 aggregate-ios.1
	dodoc LICENSE HISTORY
}
