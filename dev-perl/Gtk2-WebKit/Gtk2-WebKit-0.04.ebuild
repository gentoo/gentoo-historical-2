# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Gtk2-WebKit/Gtk2-WebKit-0.04.ebuild,v 1.3 2009/02/27 13:10:11 aballier Exp $

MODULE_AUTHOR=FLORA
inherit perl-module

DESCRIPTION="Web content engine library for Gtk2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/gtk2-perl
	net-libs/webkit-gtk"
DEPEND="${RDEPEND}
	dev-perl/glib-perl
	dev-perl/extutils-pkgconfig
	dev-perl/extutils-depends"

#SRC_TEST=do
