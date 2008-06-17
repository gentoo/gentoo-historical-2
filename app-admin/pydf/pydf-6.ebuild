# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/pydf/pydf-6.ebuild,v 1.4 2008/06/17 14:46:06 drac Exp $

MY_P=${P/-/_}

DESCRIPTION="Enhanced df with colors"
HOMEPAGE="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/"
SRC_URI="http://kassiopeia.juls.savba.sk/~garabik/software/pydf/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-lang/python"

src_compile() { :; }

src_install() {
	dobin pydf || die "dobin failed."
	insinto /etc
	doins pydfrc || die "doins failed."
	doman pydf.1
	dodoc README
}
