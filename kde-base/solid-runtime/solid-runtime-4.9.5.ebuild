# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/solid-runtime/solid-runtime-4.9.5.ebuild,v 1.3 2013/01/27 16:13:04 ago Exp $

EAPI=4

KMNAME="kde-runtime"
KMNOMODULE=true
inherit kde4-meta

DESCRIPTION="KDE SC solid runtime modules (autoeject, automounter and others)"
KEYWORDS="amd64 ~arm ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

KMEXTRA="
	solid-device-automounter/
	solid-hardware/
	solid-networkstatus/
	solidautoeject/
	soliduiserver/
"

# file collisions, bug 395001
add_blocker solid 4.4.50
