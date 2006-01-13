# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/text-autoformat/text-autoformat-1.13.ebuild,v 1.1 2006/01/13 16:45:33 mcummings Exp $

inherit perl-module

MY_P=Text-Autoformat-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Automatic text wrapping and reformatting"
SRC_URI="mirror://cpan/authors/id/D/DC/DCONWAY/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Text/${MY_P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="${DEPEND}
		>=dev-perl/text-reform-1.11"
