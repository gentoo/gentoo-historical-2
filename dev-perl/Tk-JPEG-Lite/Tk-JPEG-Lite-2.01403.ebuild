# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tk-JPEG-Lite/Tk-JPEG-Lite-2.01403.ebuild,v 1.5 2006/03/30 23:33:42 agriffis Exp $

inherit perl-module

IUSE=""

DESCRIPTION="lite JPEG loader for Tk::Photo"
SRC_URI="mirror://cpan/authors/id/S/SR/SREZIC/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/S/SR/SREZIC/${P}.readme"

SLOT="0"
LICENSE="Artistic GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc sparc x86"

DEPEND="dev-perl/perl-tk"

