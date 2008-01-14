# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/perl-info/perl-info-0.15.ebuild,v 1.5 2008/01/14 20:00:12 dertobi123 Exp $

DESCRIPTION="Tool to gather relevant perl data useful for bugreports; 'emerge --info' for perl"
HOMEPAGE="http://www.gentoo.org/proj/en/perl/"
SRC_URI="http://download.iansview.com/gentoo/tools/perl-info/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~hppa ~ia64 ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/Term-ANSIColor
	>=dev-perl/PortageXS-0.02.04"
RDEPEND="${DEPEND}"

src_install() {
	mv "${WORKDIR}"/usr "${D}"/ || die
}
