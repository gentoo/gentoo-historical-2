# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/locale-maketext-lexicon/locale-maketext-lexicon-0.32.ebuild,v 1.6 2004/12/20 11:17:03 mcummings Exp $

inherit perl-module

MY_P=Locale-Maketext-Lexicon-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Use other catalog formats in Maketext"
SRC_URI="http://www.cpan.org/authors/id/A/AU/AUTRIJUS/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/A/AU/AUTRIJUS/"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 ~amd64 ~ppc sparc ~alpha ~hppa"
IUSE=""

DEPEND="${DEPEND}
		<dev-perl/Test-Simple-0.48
		dev-perl/locale-maketext
		dev-perl/regexp-common"
