# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-Tools/Audio-Tools-0.01.ebuild,v 1.8 2003/07/11 19:57:53 gmsoft Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Tools required by some Audio modules"
SRC_URI="http://www.cpan.org/modules/by-module/Audio/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Audio/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc ~sparc ~alpha hppa"
