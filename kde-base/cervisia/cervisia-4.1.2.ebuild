# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/cervisia/cervisia-4.1.2.ebuild,v 1.1 2008/10/02 06:25:44 jmbsvicetto Exp $

EAPI="2"

KMNAME=kdesdk
inherit kde4-meta

DESCRIPTION="Cervisia - A KDE CVS frontend"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND="${RDEPEND}
	dev-util/cvs"
