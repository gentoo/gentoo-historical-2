# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gtkmm/gtkmm-2.2.3.ebuild,v 1.3 2003/08/07 03:35:15 vapier Exp $

inherit gnome2

DESCRIPTION="C++ interface for GTK+2"
HOMEPAGE="http://gtkmm.sourceforge.net/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="x86 ~ppc ~sparc hppa"

RDEPEND=">=dev-libs/glib-2.2
	>=x11-libs/gtk+-2.2
	>=dev-libs/libsigc++-1.2
	!=sys-devel/gcc-3.3.0*"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5.6.0
	dev-util/pkgconfig"

DOCS="AUTHORS CHANGES ChangeLog HACKING PORTING NEWS README TODO"
