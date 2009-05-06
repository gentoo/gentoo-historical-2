# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knode/knode-4.2.3.ebuild,v 1.1 2009/05/06 23:40:10 scarabeus Exp $

EAPI="2"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="A newsreader for KDE"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug doc"

DEPEND="
	>=kde-base/libkdepim-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/libkpgp-${PV}:${SLOT}[kdeprefix=]
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkpgp/
"

KMLOADLIBS="libkdepim"

src_unpack() {
	if use doc; then
		KMEXTRA="
			doc/kioslave/news
		"
	fi

	kde4-meta_src_unpack
}
