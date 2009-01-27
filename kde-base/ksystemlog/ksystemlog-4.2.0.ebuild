# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksystemlog/ksystemlog-4.2.0.ebuild,v 1.1 2009/01/27 17:55:15 alexxy Exp $

EAPI="2"

KMNAME="kdeadmin"
KMMODULE="ksystemlog"
inherit kde4-meta

DESCRIPTION="KSystemLog is a system log viewer for KDE."
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

DEPEND="kde-base/kdepimlibs:${SLOT}"
