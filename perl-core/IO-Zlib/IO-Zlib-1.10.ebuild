# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/IO-Zlib/IO-Zlib-1.10.ebuild,v 1.1 2009/07/15 18:30:28 tove Exp $

EAPI=2

MODULE_AUTHOR=TOMHUGHES
inherit perl-module

DESCRIPTION="IO:: style interface to Compress::Zlib"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="virtual/perl-Compress-Zlib"
DEPEND="${RDEPEND}"

SRC_TEST="do"
