# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/glib-perl/glib-perl-1.220.ebuild,v 1.1 2009/03/18 10:09:20 tove Exp $

EAPI=2

MODULE_AUTHOR=TSCH
MY_PN=Glib
MY_P=${MY_PN}-${PV}
inherit perl-module

DESCRIPTION="Glib - Perl wrappers for the GLib utility and Object libraries"
HOMEPAGE="http://gtk2-perl.sf.net/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/glib-2"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-perl/extutils-pkgconfig-1.0
	>=dev-perl/extutils-depends-0.300"

S=${WORKDIR}/${MY_P}

SRC_TEST="do"
