# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/log-dispatch/log-dispatch-2.21.ebuild,v 1.1 2008/10/31 08:38:33 tove Exp $

MODULE_AUTHOR=DROLSKY
MY_PN=Log-Dispatch
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="Dispatches messages to multiple Log::Dispatch::* objects"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

SRC_TEST="do"

RDEPEND="dev-perl/Params-Validate
	dev-lang/perl"
DEPEND="${RDEPND}
	>=dev-perl/module-build-0.28"
