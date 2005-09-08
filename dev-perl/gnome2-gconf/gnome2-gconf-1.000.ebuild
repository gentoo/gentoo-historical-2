# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gnome2-gconf/gnome2-gconf-1.000.ebuild,v 1.6 2005/09/08 22:13:28 agriffis Exp $

inherit perl-module

MY_P=Gnome2-GConf-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Perl wrappers for the GConf configuration engine."
SRC_URI="mirror://cpan/authors/id/R/RM/RMCFARLA/Gtk2-Perl/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rmcfarla/${MY_P}/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ~hppa ~ia64 ~ppc sparc x86"
IUSE=""


DEPEND="${DEPEND}
	>=x11-libs/gtk+-2
	>=gnome-base/gconf-1.2
	>=dev-perl/glib-perl-1.040
	>=dev-perl/gtk2-perl-1.040
	>=dev-perl/extutils-pkgconfig-1.03
	>=dev-perl/extutils-depends-0.202"
