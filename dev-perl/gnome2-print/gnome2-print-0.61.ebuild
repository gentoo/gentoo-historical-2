# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gnome2-print/gnome2-print-0.61.ebuild,v 1.6 2005/09/08 22:21:12 agriffis Exp $

inherit perl-module

MY_P=Gnome2-Print-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl interface to the 2.x series of the Gnome print libraries."
SRC_URI="http://search.cpan.org/CPAN/authors/id/R/RM/RMCFARLA/Gtk2-Perl/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rmcfarla/${P}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha ~ppc sparc x86"
IUSE=""

DEPEND="${DEPEND}
	>=x11-libs/gtk+-2
	dev-perl/glib-perl
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeprint-2
	>=dev-perl/gtk2-perl-${PV}"
