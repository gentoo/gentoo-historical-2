# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koshell/koshell-1.5_rc1.ebuild,v 1.1 2006/03/29 15:10:09 carlo Exp $

MAXKOFFICEVER=${PV}
KMNAME=koffice
inherit kde-meta eutils

DESCRIPTION="KOffice workspace."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="$(deprange $PV $MAXKOFFICEVER app-office/koffice-libs)"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

KMCOPYLIB="
	libkformula lib/kformula
	libkofficecore lib/kofficecore
	libkofficeui lib/kofficeui
	libkopainter lib/kopainter
	libkotext lib/kotext
	libkwmf lib/kwmf
	libkowmf lib/kwmf
	libkstore lib/store"

KMEXTRACTONLY="lib/"

need-kde 3.4
