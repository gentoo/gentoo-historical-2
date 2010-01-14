# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdotool/xdotool-20091231.02.ebuild,v 1.1 2010/01/14 05:32:46 joker Exp $

EAPI=2

inherit eutils toolchain-funcs flag-o-matic multilib

DESCRIPTION="Simulate keyboard input and mouse activity, move and resize windows."
HOMEPAGE="http://www.semicomplete.com/projects/xdotool/"
SRC_URI="http://semicomplete.googlecode.com/files/${P}.tar.gz"
LICENSE="as-is"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples"

DEPEND="x11-libs/libXtst
	x11-libs/libX11"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}_install-D.patch" \
		"${FILESDIR}/${P}_as-needed.patch"
}

src_compile() {
	tc-export CC LD
	export LDFLAGS="$(raw-ldflags)"
	default
	emake libxdo.so || die "Unable to build libxdo.so"
}

src_install() {
	emake PREFIX="${D}usr" INSTALLMAN="${D}usr/share/man" INSTALLLIB="${D}usr/$(get_libdir)" install || die

	dodoc CHANGELIST README
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
