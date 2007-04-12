# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkdepim/libkdepim-3.5.6-r1.ebuild,v 1.2 2007/04/12 19:19:07 mr_bones_ Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdepim-3.5-patchset-03.tar.bz2"

DESCRIPTION="common library for KDE PIM apps"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkcal)
		!<=kde-base/kmail-3.5.6-r1"

RDEPEND="${DEPEND}"

KMCOPYLIB="libkcal libkcal"
KMEXTRA="libemailfunctions/
	pixmaps"
KMEXTRACTONLY="kmail/hi16-app-kmail.png
		kmail/hi22-app-kmail.png
		kmail/hi32-app-kmail.png
		kmail/hi48-app-kmail.png
		kmail/hi64-app-kmail.png
		kmail/hi128-app-kmail.png"

src_unpack() {
	kde-meta_src_unpack
	# Call Qt 3 designer
	sed -i -e "s:\"designer\":\"${QTDIR}/bin/designer\":g" ${S}/libkdepim/kcmdesignerfields.cpp || die "sed failed"
}

src_install() {
	kde-meta_src_install

	# Install KMail icons with libkdepim to work around bug #136810.
	for res in 16 22 32 48 64 128 ; do
		dodir ${KDEDIR}/share/icons/hicolor/${res}x${res}/apps/
		cp kmail/hi${res}-app-kmail.png "${D}/${KDEDIR}/share/icons/hicolor/${res}x${res}/apps/kmail.png"
	done
}
