# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksayit/ksayit-3.5.10.ebuild,v 1.3 2009/06/03 15:33:13 ranger Exp $
KMNAME=kdeaccessibility
EAPI="1"
inherit kde-meta

DESCRIPTION="KDE text-to-speech frontend."
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=kde-base/kttsd-${PV}:${SLOT}
	|| ( >=kde-base/kdemultimedia-arts-${PV}:${SLOT} >=kde-base/kdemultimedia-${PV}:${SLOT} )"

pkg_setup() {
	kde_pkg_setup

	if has_version kde-base/kdemultimedia:${SLOT} && ! built_with_use kde-base/kdemultimedia:${SLOT} arts ; then
		eerror "You have \"arts\" USE flag enabled, but kde-base/kdemultimedia:${SLOT} was built with this flag disabled."
		die "Reinstall kde-base/kdemultimedia:${SLOT} with USE=\"arts\""
	fi
}

src_compile() {
	myconf="--enable-ksayit-audio-plugins"
	kde-meta_src_compile
}
