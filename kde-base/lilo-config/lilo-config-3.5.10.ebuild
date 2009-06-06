# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/lilo-config/lilo-config-3.5.10.ebuild,v 1.3 2009/06/06 08:56:14 maekke Exp $
KMNAME=kdeadmin
EAPI="1"
inherit kde-meta

DESCRIPTION="KDE LiLo kcontrol module"
KEYWORDS="amd64 ~ppc x86"
IUSE="kdehiddenvisibility"
DEPEND=""

PATCHES="$FILESDIR/never-disable.diff"
