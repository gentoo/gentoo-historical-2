# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perltidy/perltidy-20071205.ebuild,v 1.5 2009/03/09 23:26:19 fmccor Exp $

EAPI=2

MY_PN=Perl-Tidy
MY_P=${MY_PN}-${PV}
MODULE_AUTHOR=SHANCOCK
inherit perl-module

DESCRIPTION="Perl script indenter and beautifier."
HOMEPAGE="http://perltidy.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

SRC_TEST="do"
mydoc="examples/*"

pkg_postinst() {
	elog "Example scripts can be found in /usr/share/doc/${PF}"
}
