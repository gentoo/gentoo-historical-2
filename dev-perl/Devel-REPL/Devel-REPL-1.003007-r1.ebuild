# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-REPL/Devel-REPL-1.003007-r1.ebuild,v 1.1 2010/03/05 11:13:15 tove Exp $

EAPI=2

#MODULE_AUTHOR="OLIVER"
MODULE_AUTHOR="MSTROUT"
inherit perl-module

DESCRIPTION="a modern perl interactive shell"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Moose-0.74
	>=dev-perl/MooseX-Object-Pluggable-0.0009
	>=dev-perl/MooseX-Getopt-0.18
	>=dev-perl/MooseX-AttributeHelpers-0.16
	dev-perl/namespace-clean
	dev-perl/File-HomeDir
	virtual/perl-File-Spec
	virtual/perl-Term-ANSIColor

	dev-perl/PPI
	dev-perl/Data-Dump-Streamer
	dev-perl/File-Next
	dev-perl/B-Keywords
	dev-perl/Lexical-Persistence
	dev-perl/App-Nopaste
	dev-perl/Module-Refresh
"
# B::Concise? => perl
# Devel::Peek => perl
# Term::ReadLine => perl

DEPEND="${RDEPEND}"

SRC_TEST="do"
PATCHES=( "${FILESDIR}"/cpan_rt_54579.patch )
