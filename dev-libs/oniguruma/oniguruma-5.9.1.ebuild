# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/oniguruma/oniguruma-5.9.1.ebuild,v 1.12 2008/04/04 17:13:36 drac Exp $

inherit libtool

MY_P=onig-${PV}

DESCRIPTION="a regular expression library for different character encodings"
HOMEPAGE="http://www.geocities.jp/kosako3/oniguruma"
SRC_URI="http://www.geocities.jp/kosako3/oniguruma/archive/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ppc64 sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Needed for a sane .so versionning on fbsd, please dont drop
	elibtoolize
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS HISTORY README* doc/*
}
