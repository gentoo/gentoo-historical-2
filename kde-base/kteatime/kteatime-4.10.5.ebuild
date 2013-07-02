# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kteatime/kteatime-4.10.5.ebuild,v 1.1 2013/07/02 16:47:13 johu Exp $

EAPI=5

if [[ ${PV} == *9999 ]]; then
	eclass="kde4-base"
else
	eclass="kde4-meta"
	KMNAME="kdetoys"
fi
KDE_HANDBOOK="optional"
inherit ${eclass}

DESCRIPTION="KDE timer for making a fine cup of tea"
KEYWORDS=" ~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"
