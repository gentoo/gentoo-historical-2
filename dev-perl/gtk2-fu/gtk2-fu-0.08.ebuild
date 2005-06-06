# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk2-fu/gtk2-fu-0.08.ebuild,v 1.2 2005/06/06 09:10:19 corsair Exp $
inherit perl-module

DESCRIPTION="gtk2-fu is a layer on top of perl gtk2, that brings power, simplicity and speed of development"
MY_P=Gtk2Fu-${PV}
S=${WORKDIR}/${MY_P}
SRC_URI="http://libconf.net/gtk2-fu/download/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~dams/${MY_P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~alpha ~amd64 ~hppa ppc ppc64 ~sparc x86"
IUSE=""

DEPEND="dev-perl/gtk2-perl"


SRC_TEST="do"
