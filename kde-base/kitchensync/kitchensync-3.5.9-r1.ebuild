# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kitchensync/kitchensync-3.5.9-r1.ebuild,v 1.2 2009/02/03 22:50:01 alexxy Exp $

KMNAME=kdepim
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="Synchronize Data with KDE"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SRC_URI="${SRC_URI}
		mirror://gentoo/${P}-OpenSync0.30API.patch.tar.bz2"
IUSE=""
DEPEND=">=app-pda/libopensync-0.36
	>=kde-base/kontact-${PV}:${SLOT}
	>=kde-base/libkcal-${PV}:${SLOT}"

RDEPEND="${DEPEND}"

KMCOPYLIB="
	libkcal libkcal
	libkdepim libkdepim
	libkpinterfaces kontact/interfaces"
KMEXTRACTONLY="
	libkcal/
	libkdepim/
	libkdenetwork/
	kontact/interfaces"

PATCHES=( "${DISTDIR}/${P}-OpenSync0.30API.patch.tar.bz2" )

# Disabled by default in kontact/plugins/Makefile.am, so check before enabling - 3.4.0_beta1 -- danarmak
# KMEXTRA="kontact/plugins/kitchensync"
KMEXTRA="kontact/plugins/multisynk"

#src_unpack() {
#	kde-meta_src_unpack
	# disabling tests, see bug #164097
#	sed -e "s:SUBDIRS = . plugins test:SUBDIRS = . plugins:" \
#		-i kitchensync/libkonnector2/Makefile.am || die "sed failed"
#	sed -e "s:SUBDIRS = . tests test:SUBDIRS = .:" \
#		-i kitchensync/libksync/Makefile.am || die "sed failed"
#}
