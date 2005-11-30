# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gob/gob-2.0.12.ebuild,v 1.1 2005/07/22 21:24:58 leonardop Exp $

inherit gnome2

MY_PN=gob2
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
PVP=(${PV//[-\._]/ })

DESCRIPTION="Preprocessor for making GTK+ objects with inline C code."
SRC_URI="mirror://gnome/sources/${MY_PN}/${PVP[0]}.${PVP[1]}/${MY_P}.tar.bz2"
HOMEPAGE="http://www.5z.com/jirka/gob.html"
IUSE=""

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"

RDEPEND=">=dev-libs/glib-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/flex"

DOCS="AUTHORS COPYING.generated-code ChangeLog NEWS README TODO"

USE_DESTDIR="1"
