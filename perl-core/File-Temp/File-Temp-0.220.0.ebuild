# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/File-Temp/File-Temp-0.220.0.ebuild,v 1.1 2011/05/21 06:19:22 tove Exp $

EAPI=3

MODULE_AUTHOR=TJENNESS
MODULE_VERSION=0.22
inherit perl-module

DESCRIPTION="File::Temp can be used to create and open temporary files in a safe way."

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"
