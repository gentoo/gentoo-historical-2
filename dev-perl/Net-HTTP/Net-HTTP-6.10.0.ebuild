# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-HTTP/Net-HTTP-6.10.0.ebuild,v 1.3 2011/05/15 17:43:25 armin76 Exp $

EAPI=4

MODULE_AUTHOR=GAAS
MODULE_VERSION=6.01
inherit perl-module

DESCRIPTION="Low-level HTTP connection (client)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	!<dev-perl/libwww-perl-6
	virtual/perl-Compress-Raw-Zlib
	virtual/perl-IO
	virtual/perl-IO-Compress
"
DEPEND="${RDEPEND}"

SRC_TEST=do
