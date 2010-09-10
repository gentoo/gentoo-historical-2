# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libfontenc/libfontenc-1.0.5.ebuild,v 1.10 2010/09/10 22:52:39 scarabeus Exp $

# Must be before x-modular eclass is inherited
# SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org fontenc library"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}
	x11-proto/xproto"

pkg_setup() {
	CONFIGURE_OPTIONS="--with-encodingsdir=/usr/share/fonts/encodings"
}
