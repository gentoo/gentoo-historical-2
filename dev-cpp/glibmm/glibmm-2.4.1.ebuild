# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/glibmm/glibmm-2.4.1.ebuild,v 1.3 2004/05/11 02:09:53 khai Exp $

inherit gnome2

DESCRIPTION="C++ interface for glib2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~x86 ~ppc"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

RDEPEND=">=dev-libs/libsigc++-2.0
		>=dev-libs/glib-2.4"

DOCS="AUTHORS CHANGES ChangeLog HACKING PORTING NEWS README TODO"

