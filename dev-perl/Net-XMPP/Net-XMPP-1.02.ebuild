# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-XMPP/Net-XMPP-1.02.ebuild,v 1.10 2010/02/05 20:56:47 tove Exp $

EAPI=2

MODULE_AUTHOR=HACKER
inherit perl-module

DESCRIPTION="XMPP Perl Library"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-perl/XML-Stream-1.22
	dev-perl/Digest-SHA1"
DEPEND="virtual/perl-Module-Build
	${RDEPEND}"

SRC_TEST="do"
