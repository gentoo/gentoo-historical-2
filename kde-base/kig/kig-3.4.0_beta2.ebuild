# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kig/kig-3.4.0_beta2.ebuild,v 1.1 2005/02/05 11:39:18 danarmak Exp $
KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE Interactive Geometry tool"
KEYWORDS="~x86"
IUSE=""
DEPEND=""

src_compile() {
	# the scripting support in kig is strongly dependent on the version
	# of dev-libs/boost and of python installed, and often fails to compile.
	myconf="${myconf} --disable-kig-python-scripting"

	kde_src_compile
}
