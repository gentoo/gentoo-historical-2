# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaccessibility/kdeaccessibility-3.4.0_beta2.ebuild,v 1.2 2005/02/16 02:12:42 weeve Exp $

inherit kde-dist

DESCRIPTION="KDE accessibility module"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE="arts"

RDEPEND="arts? ( ~kde-base/arts-${PV}
		 || ( app-accessibility/festival
		      app-accessibility/epos
		      app-accessibility/flite
		      app-accessibility/freetts
		      app-accessibility/mbrola ) )"
