# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/genlop/genlop-0.30.1.ebuild,v 1.6 2004/06/24 21:49:15 agriffis Exp $

DESCRIPTION="A nice emerge.log parser"
HOMEPAGE="http://pollycoke.org/genlop.html"
SRC_URI="http://pollycoke.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~mips ~alpha arm hppa ~amd64"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8.0-r12
	 >=dev-perl/Time-Duration-1.02
	 >=dev-perl/DateManip-5.40"

src_install() {
	dobin genlop || die
	dodoc README Changelog
	doman genlop.1
	dodir /usr/share/bash-completion
	insinto /usr/share/bash-completion
	newins genlop.bash-completion genlop
}
