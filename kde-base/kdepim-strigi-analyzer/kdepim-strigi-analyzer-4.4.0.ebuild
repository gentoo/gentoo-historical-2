# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-strigi-analyzer/kdepim-strigi-analyzer-4.4.0.ebuild,v 1.1 2010/02/09 00:17:07 alexxy Exp $

EAPI="2"

KMNAME="kdepim"
KMMODULE="strigi-analyzer"
inherit kde4-meta

DESCRIPTION="kdepim: strigi plugins"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-misc/strigi
	$(add_kdebase_dep kdepimlibs)
"
RDEPEND="${DEPEND}"
