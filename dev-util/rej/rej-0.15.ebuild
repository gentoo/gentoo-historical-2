# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rej/rej-0.15.ebuild,v 1.2 2005/05/07 17:02:15 dholm Exp $

DESCRIPTION="A utility for solving diff/patch rejects"
HOMEPAGE="http://ftp.suse.com/pub/people/mason/rej/"
SRC_URI="http://ftp.suse.com/pub/people/mason/rej/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl"

src_compile() {
	echo
}

src_install() {
	dobin rej qp
	dodoc CHANGELOG README vimrc
}
