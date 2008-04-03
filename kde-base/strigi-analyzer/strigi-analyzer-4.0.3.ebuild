# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/strigi-analyzer/strigi-analyzer-4.0.3.ebuild,v 1.1 2008/04/03 21:47:55 philantrop Exp $

EAPI="1"

KMNAME=kdesdk
inherit kde4-meta

DESCRIPTION="KDE SDK: Strigi plugins"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=">=app-misc/strigi-0.5.7"
RDEPEND="${DEPEND}"
