# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk2-gladexml/gtk2-gladexml-1.007.ebuild,v 1.1 2008/09/08 08:19:07 tove Exp $

inherit perl-module

MY_P=Gtk2-GladeXML-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Create user interfaces directly from Glade XML files."
SRC_URI="mirror://cpan/authors/id/T/TS/TSCH/${MY_P}.tar.gz"
HOMEPAGE="http://gtk2-perl.sf.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2
	>=gnome-base/libglade-2
	>=dev-util/glade-2.0.0-r1
	>=dev-perl/glib-perl-1.020
	>=dev-perl/gtk2-perl-1.012
	dev-lang/perl"
DEPEND="${RDEPEND}
	>=dev-perl/extutils-depends-0.300
	dev-perl/extutils-pkgconfig"
