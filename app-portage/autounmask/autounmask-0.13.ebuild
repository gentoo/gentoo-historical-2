# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/autounmask/autounmask-0.13.ebuild,v 1.3 2007/04/27 11:35:00 armin76 Exp $

DESCRIPTION="autounmask - Unmasking packages the easy way"
HOMEPAGE="http://download.iansview.com/gentoo/tools/autounmask/"
SRC_URI="http://download.iansview.com/gentoo/tools/autounmask/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/perl
		>=dev-perl/PortageXS-0.02.06
		dev-perl/Term-ANSIColor"
RDEPEND="${DEPEND}
		sys-apps/portage"

src_install() {
	dobin autounmask || die
	dodoc Changelog
}
