# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-IniFiles/Config-IniFiles-2.38.ebuild,v 1.12 2006/08/05 01:27:40 mcummings Exp $

inherit perl-module

DESCRIPTION="A module for reading .ini-style configuration files"
HOMEPAGE="http://config-inifiles.sourceforge.net/"
SRC_URI="mirror://cpan/authors/id/W/WA/WADG/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""
DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
