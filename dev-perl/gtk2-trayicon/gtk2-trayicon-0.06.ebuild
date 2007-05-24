# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk2-trayicon/gtk2-trayicon-0.06.ebuild,v 1.1 2007/05/24 14:04:42 mcummings Exp $

inherit perl-module

MY_P=Gtk2-TrayIcon-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Perl wrappers for the egg cup Gtk2::TrayIcon utilities."
HOMEPAGE="http://gtk2-perl.sf.net/"
SRC_URI="mirror://cpan/authors/id/B/BO/BORUP/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	>=dev-perl/glib-perl-1.012
	>=dev-perl/gtk2-perl-1.012
	>=gnome-base/libglade-2
	>=x11-libs/gtk+-2"
DEPEND="${RDEPEND}
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig
	dev-util/pkgconfig"
