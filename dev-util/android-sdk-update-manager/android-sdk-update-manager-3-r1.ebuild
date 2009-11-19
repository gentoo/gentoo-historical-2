# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/android-sdk-update-manager/android-sdk-update-manager-3-r1.ebuild,v 1.2 2009/11/19 02:41:03 mr_bones_ Exp $

EAPI="2"

inherit versionator eutils

MY_PN="android-sdk"
MY_P="${MY_PN}_r${PV}-linux"

DESCRIPTION="Open Handset Alliance's Android SDK/"
HOMEPAGE="http://developer.android.com"
SRC_URI="http://dl.google.com/android/${MY_P}.tgz"
IUSE=""
RESTRICT="mirror"

LICENSE="android"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="app-arch/tar
		app-arch/gzip"
RDEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.6.5
	amd64? ( app-emulation/emul-linux-x86-gtklibs )
	x86? ( x11-libs/gtk+:2 )"

QA_DT_HASH_x86="
	opt/${P}/tools/emulator
	opt/${P}/tools/adb
	opt/${P}/tools/mksdcard
	opt/${P}/tools/sqlite3
	opt/${P}/tools/hprof-conv
	opt/${P}/tools/zipalign
	opt/${P}/tools/dmtracedump
"
QA_DT_HASH_amd64="${QA_DT_HASH_x86}"

pkg_setup() {
	enewgroup android
}

src_install(){
	local destdir="/opt/${P/_p*/}"
	dodir "${destdir}"

	cd "android-sdk-linux"

	dodoc tools/NOTICE.txt "SDK Readme.txt" || die
	rm -f tools/NOTICE.txt "SDK Readme.txt"
	cp -pPR tools "${D}/${destdir}/" || die "failed to copy"
	mkdir -p "${D}/${destdir}/"{platforms,add-ons,docs,temp} || die "failed to mkdir"
	# Maybe this is needed for the tools directory too.
	chgrp android "${D}/${destdir}/"{platforms,add-ons,docs,temp}
	chmod 775 "${D}/${destdir}/"{platforms,add-ons,docs,temp}

	echo -n "PATH=\"${destdir}/tools" > "${T}/80android"
	echo ":${destdir}/platforms/android-${PV/_p*/}/tools\"" >> "${T}/80android"
	doenvd "${T}/80android"
}

pkg_postinst() {
	ewarn "The Android SDK now uses its own manager for the development	environment."
	ewarn "You must be in the android group to manage the development environment."
	ewarn "Just run 'gpasswd -a <USER> android', then have <USER> re-login."
	ewarn "See http://dev.android.com/sdk/adding-components.html for more
	information."
	elog "If you have problems downloading the SDK, see http://code.google.com/p/android/issues/detail?id=4406"
}
