# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk2-perl/gtk2-perl-1.202.ebuild,v 1.2 2008/11/28 23:12:17 maekke Exp $

MODULE_AUTHOR=TSCH
MY_PN=Gtk2
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

inherit perl-module
#inherit virtualx

DESCRIPTION="Perl bindings for GTK2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	dev-perl/Cairo
	>=dev-perl/glib-perl-1.200
	dev-lang/perl"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-depends-0.300
	>=dev-perl/extutils-pkgconfig-1.030"
#SRC_TEST=do
#src_test(){
#	Xmake test || die
#}
