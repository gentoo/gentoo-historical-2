# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/sawfish-themes/sawfish-themes-0.0.1-r1.ebuild,v 1.4 2002/10/22 15:45:01 bjb Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Some nice themes for sawfish"
SRC_URI="http://ftp1.sourceforge.net/pub/mirrors/themes.org/sawmill/Adept-0.28.tar.gz http://ftp1.sourceforge.net/pub/mirrors/themes.org/sawmill/Eazel-blue-0.30.tar.gz"
HOMEPAGE="http://www.themes.org"
DEPEND=">=x11-wm/sawfish-1.0"
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 ppc alpha"

src_install() {
	version="`sawfish --version |sed -e 's/sawfish version //'`"
	dodir /usr/share/sawfish/${version}/themes
	cd ${D}/usr/share/sawfish/${version}/themes
	unpack Adept-0.28.tar.gz
	unpack Eazel-blue-0.30.tar.gz
}

