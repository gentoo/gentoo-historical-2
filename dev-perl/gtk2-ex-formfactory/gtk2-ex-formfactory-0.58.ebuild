# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/gtk2-ex-formfactory/gtk2-ex-formfactory-0.58.ebuild,v 1.1 2005/11/12 14:30:40 mcummings Exp $

inherit perl-module

MY_P=Gtk2-Ex-FormFactory-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Gtk2 FormFactory"
HOMEPAGE="http://www.exit1.org/Gtk2-Ex-FormFactory/"
SRC_URI="mirror://cpan/modules/by-module/Gtk2/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86 ~amd64"
IUSE=""

DEPEND="dev-perl/gtk2-perl"

