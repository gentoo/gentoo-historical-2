# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/khotkeys/khotkeys-4.4.5.ebuild,v 1.3 2010/08/03 07:42:58 hwoarang Exp $

EAPI="3"

KMNAME="kdebase-workspace"
inherit kde4-meta

DESCRIPTION="KDE: hotkey daemon"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkworkspace)
	x11-libs/libXtst
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libs/kworkspace/
"
