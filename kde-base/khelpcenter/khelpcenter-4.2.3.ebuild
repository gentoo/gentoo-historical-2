# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khelpcenter/khelpcenter-4.2.3.ebuild,v 1.1 2009/05/06 23:27:12 scarabeus Exp $

EAPI="2"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="The KDE Help Center"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug doc"

RDEPEND="
	>=www-misc/htdig-3.2.0_beta6-r1
"

src_unpack() {
	if use doc; then
		KMEXTRA="
			doc/faq
			doc/glossary
			doc/quickstart
			doc/userguide
			doc/visualdict
		"
	fi

	kde4-meta_src_unpack
}
