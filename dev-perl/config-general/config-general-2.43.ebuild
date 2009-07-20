# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/config-general/config-general-2.43.ebuild,v 1.1 2009/07/20 06:59:31 tove Exp $

EAPI=2

MODULE_AUTHOR=TLINDEN
MY_PN=Config-General
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="Config file parser module"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

SRC_TEST="do"

src_prepare() {
	rm "${S}"/General/i || die
	perl-module_src_prepare
}
