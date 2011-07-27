# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kalarm/kalarm-4.7.0.ebuild,v 1.1 2011/07/27 14:04:51 alexxy Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdepim"
KDE_SCM="git"
inherit kde4-meta

DESCRIPTION="Personal alarm message, command and email scheduler for KDE"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop')
	$(add_kdebase_dep kdepim-common-libs)
	media-libs/phonon
"
DEPEND="${RDEPEND}"

KMEXTRACTONLY="
	kmail/
"
