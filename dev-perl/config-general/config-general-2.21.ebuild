# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/config-general/config-general-2.21.ebuild,v 1.3 2004/05/27 23:00:18 kloeri Exp $


inherit perl-module

MY_P=Config-General-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Config file parser module"
SRC_URI="http://www.cpan.org/CPAN/authors/id/T/TL/TLINDEN/${MY_P}.tar.gz"
HOMEPAGE="http://www.daemon.de/config-general/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ~amd64 ~ppc sparc alpha"
