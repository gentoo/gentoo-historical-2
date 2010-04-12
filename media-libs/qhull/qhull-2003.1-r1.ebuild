# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/qhull/qhull-2003.1-r1.ebuild,v 1.10 2010/04/12 13:50:16 aballier Exp $

EAPI=2
inherit eutils flag-o-matic

MY_P="${PN}${PV}"
DESCRIPTION="Geometry library"
HOMEPAGE="http://www.qhull.org"
SRC_URI="${HOMEPAGE}/download/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="alpha amd64 ~hppa ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

pkg_setup() {
	append-flags -fno-strict-aliasing
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	rm -fr "${D}"/usr/share/doc/${PN}
	dodoc Announce.txt File_id.diz README.txt REGISTER.txt
	if use doc; then
		cd html
		dohtml * || die
		dodoc *.txt || die
	fi
}
