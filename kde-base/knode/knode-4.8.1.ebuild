# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knode/knode-4.8.1.ebuild,v 1.1 2012/03/06 23:35:14 dilfridge Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdepim"
KDE_SCM="git"
inherit kde4-meta

DESCRIPTION="A newsreader for KDE"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

# test fails, last checked for 4.2.96
RESTRICT=test

DEPEND="
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep kdepim-common-libs)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libkleo/
	libkpgp/
	messagecomposer/
	messageviewer/
"

KMLOADLIBS="kdepim-common-libs"

src_unpack() {
	if use handbook; then
		KMEXTRA="
			doc/kioslave/news
		"
	fi

	kde4-meta_src_unpack
}
