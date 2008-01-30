# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-kioslaves/kdesdk-kioslaves-3.5.8.ebuild,v 1.4 2008/01/30 17:25:12 ranger Exp $

KMNAME=kdesdk
KMMODULE=kioslave
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kioslaves from kdesdk package: the subversion kioslave"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 ~sparc x86"
IUSE="kdehiddenvisibility"
DEPEND="dev-util/subversion"

pkg_setup() {
	if [[ -n "$(ldd /usr/bin/svn | grep -o libapr-0)" ]] \
		&& ! has_version =dev-libs/apr-0* ;
	then
		eerror "Subversion has been built against =dev-libs/apr-0*, but no matching version is installed."
		die "Please rebuild dev-util/subversion."
	fi
	if [[ -n "$(ldd /usr/bin/svn | grep -o libapr-1)" ]] \
		&& ! has_version =dev-libs/apr-1* ;
	then
		eerror "Subversion has been built against =dev-libs/apr-1*, but no matching version is installed."
		die "Please rebuild dev-util/subversion."
	fi
}

src_compile() {
	if [[ -n "$(ldd /usr/bin/svn | grep -o libapr-0)" ]] ; then
		myconf="--with-apr-config=/usr/bin/apr-config
		--with-apu-config=/usr/bin/apu-config"
	else
		myconf="--with-apr-config=/usr/bin/apr-1-config
		--with-apu-config=/usr/bin/apu-1-config"
	fi
	kde-meta_src_compile
}
