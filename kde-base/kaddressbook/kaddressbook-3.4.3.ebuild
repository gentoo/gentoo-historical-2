# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kaddressbook/kaddressbook-3.4.3.ebuild,v 1.6 2005/12/10 05:21:09 chriswhite Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="The KDE Address Book"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86"
IUSE="gnokii"
DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdepim)
$(deprange $PV $MAXKDEVER kde-base/libkcal)
$(deprange $PV $MAXKDEVER kde-base/certmanager)
$(deprange 3.4.1 $MAXKDEVER kde-base/libkdenetwork)
$(deprange $PV $MAXKDEVER kde-base/kontact)
gnokii? ( app-mobilephone/gnokii )"

PATCHES="$FILESDIR/configure-fix-kdepim-gnokii-3.4.patch"
myconf="$myconf $(use_with gnokii)"

KMCOPYLIB="
	libkdepim libkdepim
	libkcal libkcal
	libkleopatra certmanager/lib/
	libqgpgme libkdenetwork/qgpgme/
	libkpinterfaces kontact/interfaces/"
KMEXTRACTONLY="
	libkdepim/
	libkdenetwork/
	libkcal/
	certmanager/
	kontact/interfaces/
	akregator
	kmail/kmailIface.h"
KMCOMPILEONLY="
	libkcal/libical/src/libical/
	libkcal/libical/src/libicalss/
	akregator/src/librss"
	# We add them here because they are standard plugins and programs related to kaddressbook but not a dep of any other kdepim program, so they will be lost if noone install them
KMEXTRA="
	kabc/
	kfile-plugins/vcf
	kontact/plugins/kaddressbook"

src_compile() {
	export DO_NOT_COMPILE="libical" && kde-meta_src_compile myconf configure
	# generate "ical.h"
	cd ${S}/libkcal/libical/src/libical && make ical.h
	# generate "icalss.h"
	cd ${S}/libkcal/libical/src/libicalss && make icalss.h

	kde-meta_src_compile "make"
}
