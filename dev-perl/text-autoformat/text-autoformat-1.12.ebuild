# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/text-autoformat/text-autoformat-1.12.ebuild,v 1.2 2004/05/30 16:46:59 kloeri Exp $

inherit perl-module

MY_P=Text-Autoformat-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Automatic text wrapping and reformatting"
SRC_URI="http://www.cpan.org/modules/by-module/Text/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Text/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~amd64 ~ppc ~sparc alpha ~hppa"

DEPEND="${DEPEND}
		dev-perl/text-reform"
