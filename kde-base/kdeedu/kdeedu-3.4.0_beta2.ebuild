# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu/kdeedu-3.4.0_beta2.ebuild,v 1.1 2005/02/09 16:17:09 greg_g Exp $

inherit kde-dist

DESCRIPTION="KDE educational apps"

KEYWORDS="~x86 ~amd64"
IUSE=""

src_compile() {
	# the scripting support in kig is strongly dependent on the version
	# of dev-libs/boost and of python installed, and often fails to compile.
	myconf="${myconf} --disable-kig-python-scripting"

	kde_src_compile
}
