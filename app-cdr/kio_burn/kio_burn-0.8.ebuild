# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/kio_burn/kio_burn-0.8.ebuild,v 1.1 2005/12/27 19:09:22 carlo Exp $

inherit kde

MY_P="burn-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="The Burn ioslave lets you use Konqueror to burn CDs."
HOMEPAGE="http://www-users.york.ac.uk/~jrht100/burn/"
SRC_URI="http://www-users.york.ac.uk/~jrht100/burn/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="|| ( kde-base/konqueror kde-base/kdebase )
	media-libs/taglib
	app-cdr/k3b" # uses libk3b for burner detection; configure uses it if it's detected
RDEPEND="$DEPEND
	virtual/cdrtools"

need-kde 3.4