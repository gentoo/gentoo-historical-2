# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Locale/DateTime-Locale-0.21.ebuild,v 1.1 2005/04/25 14:29:47 mcummings Exp $

inherit perl-module

DESCRIPTION="Localization support for DateTime"
HOMEPAGE="http://search.cpan.org/~drolsky/${P}/"
SRC_URI="mirror://cpan/authors/id/D/DR/DROLSKY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~alpha ~amd64 ~ppc64"
IUSE=""

DEPEND="dev-perl/module-build
		dev-perl/Params-Validate"
