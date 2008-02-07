# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kstyles/kstyles-4.0.1.ebuild,v 1.1 2008/02/07 00:11:47 philantrop Exp $

EAPI="1"

KMNAME=kdebase-runtime
inherit kde4-meta

DESCRIPTION="KDE: A set of different KDE styles."
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=kde-base/qimageblitz-0.0.4"
RDEPEND="${DEPEND}"
