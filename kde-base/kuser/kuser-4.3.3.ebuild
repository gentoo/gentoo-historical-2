# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kuser/kuser-4.3.3.ebuild,v 1.4 2009/11/30 06:54:50 josejx Exp $

EAPI="2"

KMNAME="kdeadmin"

inherit kde4-meta

DESCRIPTION="KDE application that helps you manage system users"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 ~sparc ~x86"
IUSE="debug +handbook"

DEPEND="$(add_kdebase_dep kdepimlibs)"
# notify is needed for dialogs
RDEPEND="${DEPEND}
	$(add_kdebase_dep knotify)
"
