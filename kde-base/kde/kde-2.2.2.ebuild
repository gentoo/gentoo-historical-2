# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde/kde-2.2.2.ebuild,v 1.2 2002/02/26 11:30:39 danarmak Exp $

DESCRIPTION="KDE 2.2.2 - merge this to pull in all kde-base/* packages"
HOMEPAGE="http://www.kde.org/"

RDEPEND=`echo ~kde-base/kde{libs,base,addons,admin,artwork,bindings,games,graphics,multimedia,network,pim,sdk,toys,utils}-${PV} ~kde-base/kdoc-${PV}`


