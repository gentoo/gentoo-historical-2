# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/drkonqi/drkonqi-4.0.5.ebuild,v 1.1 2008/06/06 08:13:26 ingmar Exp $

EAPI="1"

KMNAME=kdebase-runtime
inherit kde4-meta

DESCRIPTION="KDE crash handler, gives the user feedback if a program crashed"
IUSE="debug"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="sys-devel/gdb"
