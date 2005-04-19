# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk2-fu/gtk2-fu-0.05-r1.ebuild,v 1.2 2005/04/19 14:18:48 dams Exp $
inherit perl-module

DESCRIPTION="gtk2-fu is a layer on top of perl gtk2, that brings power, simplicity and speed of development"
MY_P=Gtk2Fu-${PV}
S=${WORKDIR}/${MY_P}
SRC_URI="http://search.cpan.org/CPAN/authors/id/D/DA/DAMS/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~dams/${MY_P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64 ~alpha ~hppa ~ppc ~sparc ~ppc64"
IUSE=""

DEPEND="dev-perl/gtk2-perl"


SRC_TEST="do"
