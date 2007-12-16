# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdlabelgen/cdlabelgen-4.0.0.ebuild,v 1.1 2007/12/16 15:30:47 pylon Exp $

inherit eutils

DESCRIPTION="CD cover, tray card and envelope generator"
HOMEPAGE="http://www.aczoom.com/tools/cdinsert"
SRC_URI="http://www.aczoom.com/pub/tools/${P}.tgz"
LICENSE="aczoom"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="dev-lang/perl"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${PV}-create-MAN_DIR.diff
}

src_install() {
	emake install BASE_DIR="${D}"/usr || die "emake failed"
	dodoc ChangeLog README INSTALL.WEB cdinsert.pl || die "dodoc failed."
	dohtml *.html || die "dohtml failed."
}
