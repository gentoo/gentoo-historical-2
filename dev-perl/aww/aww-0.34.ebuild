# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/aww/aww-0.34.ebuild,v 1.10 2006/06/06 02:33:21 mcummings Exp $

inherit perl-module

MY_P=${P/a/A}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Aww is a command-line frontend to the website meta language (wml)"
HOMEPAGE="http://www.panhorst.com/aww/"
SRC_URI="mirror://sourceforge/aww/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ia64 ~ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl
dev-perl/HTML-Parser
dev-perl/Crypt-Blowfish
virtual/perl-Getopt-Long
dev-perl/crypt-cbc
dev-perl/Config-Simple"


RDEPEND="net-ftp/lftp
>=dev-lang/wml-2.0.9
dev-perl/HTML-Parser
dev-perl/Crypt-Blowfish
virtual/perl-Getopt-Long"
