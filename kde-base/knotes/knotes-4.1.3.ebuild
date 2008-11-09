# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/knotes/knotes-4.1.3.ebuild,v 1.1 2008/11/09 00:52:56 scarabeus Exp $

EAPI="2"

KMNAME=kdepim
inherit kde4-meta

DESCRIPTION="KDE Notes"
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND="kde-base/libkdepim:${SLOT}"

KMEXTRACTONLY="libkdepim"
KMLOADLIBS="libkdepim"
