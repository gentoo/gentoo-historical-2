# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxsettings-client/libxsettings-client-0.17.ebuild,v 1.1 2009/03/01 03:20:33 miknix Exp $

GPE_TARBALL_SUFFIX="bz2"

inherit gpe autotools

DESCRIPTION="XSETTINGS client code"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sh ~x86 ~hppa"

DOCS="ChangeLog"
IUSE=""

RDEPEND="${RDEPEND}"

DEPEND="${DEPEND}
	${RDEPEND}
	x11-proto/xproto
	x11-libs/libX11"

src_unpack() {
	gpe_src_unpack "$@"

	sed -i -e \
		's;INCLUDES = -I $(includedir);INCLUDES = -I '$ROOT'/$(includedir);' \
		Makefile.in || die "Sed failed"
	eautoconf
}

