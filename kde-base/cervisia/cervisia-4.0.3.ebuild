# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/cervisia/cervisia-4.0.3.ebuild,v 1.1 2008/04/03 20:36:31 philantrop Exp $

EAPI="1"

KMNAME=kdesdk
inherit kde4-meta

DESCRIPTION="Cervisia - A KDE CVS frontend"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND="${RDEPEND}
	dev-util/cvs"
