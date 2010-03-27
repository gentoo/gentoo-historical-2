# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/ExtUtils-CBuilder/ExtUtils-CBuilder-0.27.03.ebuild,v 1.1 2010/03/27 21:42:02 robbat2 Exp $

EAPI=2

inherit versionator
MY_P=${PN}-$(delete_version_separator 2 )
MODULE_AUTHOR=DAGOLDEN
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="Compile and link C code for Perl modules"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
