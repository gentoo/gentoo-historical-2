# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/glib-perl/glib-perl-1.012.ebuild,v 1.3 2004/02/22 10:37:25 vapier Exp $

inherit perl-module

MY_P=Glib-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Glib - Perl wrappers for the GLib utility and Object libraries"
HOMEPAGE="http://gtk2-perl.sf.net/"
SRC_URI="http://www.cpan.org/authors/id/M/ML/MLEHMANN/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha hppa ~amd64"
IUSE="xml"

DEPEND=">=x11-libs/gtk+-2*
	>=dev-libs/glib-2*
	dev-util/pkgconfig
	dev-perl/extutils-depends
	dev-perl/extutils-pkgconfig
	xml? ( dev-perl/XML-Writer
		dev-perl/XML-Parser )"
