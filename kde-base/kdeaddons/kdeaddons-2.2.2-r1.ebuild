# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaddons/kdeaddons-2.2.2-r1.ebuild,v 1.3 2002/07/11 06:30:26 drobbins Exp $

inherit kde-dist || die

DESCRIPTION="${DESCRIPTION}Addons"

newdepend "~kde-base/kdebase-${PV}
	~kde-base/kdenetwork-${PV}
	~kde-base/kdemultimedia-${PV}
	>=media-libs/libsdl-1.2"

