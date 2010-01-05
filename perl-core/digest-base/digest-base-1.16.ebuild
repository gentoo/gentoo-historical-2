# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/digest-base/digest-base-1.16.ebuild,v 1.9 2010/01/05 19:28:37 nixnut Exp $

EAPI=2

MY_PN=Digest
MY_P=${MY_PN}-${PV}
MODULE_AUTHOR=GAAS
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="Modules that calculate message digests"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="virtual/perl-MIME-Base64"
DEPEND="${RDEPEND}"

SRC_TEST="do"
mydoc="rfc*.txt"
