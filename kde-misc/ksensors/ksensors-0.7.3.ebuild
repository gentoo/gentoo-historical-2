# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/ksensors/ksensors-0.7.3.ebuild,v 1.4 2005/02/27 12:33:43 brix Exp $

inherit kde

DESCRIPTION="KSensors - a nice lm_sensors frontend for KDE"
SRC_URI="mirror://sourceforge/ksensors/${P}.tar.gz"
HOMEPAGE="http://ksensors.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="x86 ~amd64"

IUSE=""
SLOT="0"

DEPEND=">=sys-apps/lm_sensors-2.6.3
	|| ( kde-base/kdebase-meta >=kde-base/kdebase-3.0 )"

need-kde 3.0

src_unpack()
{
	kde_src_unpack
	cd ${S}
	rm -f config.cache
}
