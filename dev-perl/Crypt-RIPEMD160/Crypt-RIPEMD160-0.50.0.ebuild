# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-RIPEMD160/Crypt-RIPEMD160-0.50.0.ebuild,v 1.4 2012/04/24 07:09:21 jdhore Exp $

EAPI=4

MODULE_AUTHOR=TODDR
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="Crypt::RIPEMD160 module for perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

export OPTIMIZE="$CFLAGS"
PATCHES=( "${FILESDIR}"/0.50.0-header.patch )
SRC_TEST=do
