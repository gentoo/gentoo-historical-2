# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBD-mysql/DBD-mysql-4.01.7.ebuild,v 1.7 2010/11/13 19:33:46 armin76 Exp $

inherit versionator

MODULE_AUTHOR="CAPTTOFU"
MY_P=${PN}-$(delete_version_separator 2 )
S=${WORKDIR}/${MY_P}
inherit eutils perl-module

DESCRIPTION="The Perl DBD:mysql Module"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ~ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/DBI
	virtual/mysql"
DEPEND="${RDEPEND}"

mydoc="ToDo"
