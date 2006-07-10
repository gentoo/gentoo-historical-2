# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-proto/xproto/xproto-7.0.5.ebuild,v 1.7 2006/07/10 11:51:38 agriffis Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xproto protocol headers"
RESTRICT="mirror"
KEYWORDS="alpha amd64 arm ~hppa ia64 ~m68k mips ppc ppc64 ~s390 sh sparc x86 ~x86-fbsd"
RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	x-modular_unpack_source

	x-modular_reconf_source
}
