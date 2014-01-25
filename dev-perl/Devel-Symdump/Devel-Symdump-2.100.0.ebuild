# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Symdump/Devel-Symdump-2.100.0.ebuild,v 1.7 2014/01/25 10:58:15 zlogene Exp $

EAPI=4

MODULE_AUTHOR=ANDK
MODULE_VERSION=2.10
inherit versionator perl-module

DESCRIPTION="Dump symbol names or the symbol table"

SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

SRC_TEST="do"
