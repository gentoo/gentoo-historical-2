# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/FileHandle-Unget/FileHandle-Unget-0.14.ebuild,v 1.7 2005/04/22 14:39:25 blubb Exp $

inherit perl-module

DESCRIPTION="A FileHandle which supports ungetting of multiple bytes"
SRC_URI="http://www.cpan.org/modules/by-module/Mail/DCOPPIT/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Mail/DCOPPIT/${P}.readme"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc ppc amd64"
IUSE=""

DEPEND="dev-perl/WeakRef"
