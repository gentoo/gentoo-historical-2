# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/URI/URI-1.37.ebuild,v 1.1 2008/07/04 08:39:11 tove Exp $

MODULE_AUTHOR=GAAS

inherit perl-module

DESCRIPTION="A URI Perl Module"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/perl-MIME-Base64
	dev-lang/perl"

SRC_TEST=no # see ChangeLog

mydoc="rfc2396.txt"
