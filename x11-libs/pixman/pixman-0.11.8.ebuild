# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/pixman/pixman-0.11.8.ebuild,v 1.3 2008/07/20 14:01:57 yngwin Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="Low-level pixel manipulation routines"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="altivec mmx sse sse2"

CONFIGURE_OPTIONS="$(use_enable altivec vmx) $(use_enable mmx) \
$(use_enable sse2) --disable-gtk"

src_unpack() {
	x-modular_src_unpack
	cd "${S}"
	use sse && epatch "${FILESDIR}"/${P}-sse.patch
	epatch "${FILESDIR}"/${P}-sse2-intrinsics-check.patch
	eautoreconf
	elibtoolize
}
