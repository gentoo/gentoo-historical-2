# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/oniguruma/oniguruma-5.9.0.ebuild,v 1.6 2008/02/10 19:03:29 drac Exp $

MY_P=onig-${PV}

DESCRIPTION="a regular expression library for different character encodings"
HOMEPAGE="http://www.geocities.jp/kosako3/oniguruma"
SRC_URI="http://www.geocities.jp/kosako3/oniguruma/archive/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS HISTORY README* doc/*
}
