# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-IP/Net-IP-1.25-r1.ebuild,v 1.5 2010/01/10 19:01:17 grobian Exp $

MODULE_AUTHOR=MANU
inherit perl-module

DESCRIPTION="Perl extension for manipulating IPv4/IPv6 addresses"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

PATCHES=( "${FILESDIR}/initip-0.patch" )
SRC_TEST="do"

mydoc="TODO"

DEPEND="dev-lang/perl"
