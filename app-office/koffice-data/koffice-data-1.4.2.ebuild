# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/koffice-data/koffice-data-1.4.2.ebuild,v 1.5 2005/11/22 14:40:21 cryos Exp $

MAXKOFFICEVER=${PV}
KMNAME=koffice
KMMODULE=
inherit kde-meta eutils

DESCRIPTION="Shared KOffice data files."
HOMEPAGE="http://www.koffice.org/"
LICENSE="GPL-2 LGPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 sparc ~x86"
IUSE=""

RDEPEND=""

DEPEND="dev-util/pkgconfig"

KMEXTRA="
	mimetypes/
	servicetypes/
	pics/
	templates/
	autocorrect/"

need-kde 3.3
