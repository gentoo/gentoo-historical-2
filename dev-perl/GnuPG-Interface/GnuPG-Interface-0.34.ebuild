# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GnuPG-Interface/GnuPG-Interface-0.34.ebuild,v 1.4 2004/06/25 00:34:08 agriffis Exp $

inherit perl-module

DESCRIPTION=" GnuPG::Interface is a Perl module interface to interacting with GnuPG."
HOMEPAGE="http://gnupg-interface.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnupg-interface/${P}.tar.gz"
LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~ia64 alpha ~hppa"
IUSE=""
DEPEND=">=app-crypt/gnupg-1.2.1-r1
		>=dev-perl/Class-MethodMaker-1.08"


