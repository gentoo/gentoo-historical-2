# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Log-Log4perl/Log-Log4perl-1.28.ebuild,v 1.3 2010/05/08 18:00:43 armin76 Exp $

EAPI=2

MODULE_AUTHOR="MSCHILLI"
inherit perl-module

DESCRIPTION="Log::Log4perl is a Perl port of the widely popular log4j logging package."
HOMEPAGE="http://log4perl.sourceforge.net/"

SLOT="0"
KEYWORDS="amd64 ~arm ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="test"

RDEPEND="virtual/perl-Time-HiRes"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"
