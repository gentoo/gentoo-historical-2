# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-env/kde-env-3-r2.ebuild,v 1.20 2005/02/21 22:20:14 hardave Exp $

DESCRIPTION="Sets up some env.d files for KDE"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc ~mips alpha hppa amd64 ia64 ppc64"
IUSE=""

# needs the new portage to process the CONFIG_PROTECT values correctly
DEPEND=""
RDEPEND=">=sys-apps/portage-2.0.36"

S=${WORKDIR}

src_install() {
	dodir /etc/env.d
	cat << EOF > ${D}/etc/env.d/99kde-env
KDEDIRS=/usr
CONFIG_PROTECT=/usr/share/config
EOF
}
