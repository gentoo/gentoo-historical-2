# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdessh/kdessh-4.2.0.ebuild,v 1.1 2009/01/27 17:03:42 alexxy Exp $

EAPI="2"

KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="KDE frontend to ssh"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="virtual/ssh"
