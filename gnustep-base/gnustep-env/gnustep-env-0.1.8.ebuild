# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-base/gnustep-env/gnustep-env-0.1.8.ebuild,v 1.6 2007/04/09 13:41:31 grobian Exp $

inherit gnustep

DESCRIPTION="This is a convience package that installs all base GNUstep libraries, convenience scripts, and environment settings for use on Gentoo."
# These are support files for GNUstep on Gentoo, so setting
#   homepage thusly
HOMEPAGE="http://www.gnustep.org"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc x86"

IUSE=""
DEPEND=">=gnustep-base/gnustep-make-1.12
	>=gnustep-base/gnustep-base-1.12
	>=gnustep-base/gnustep-gui-0.10
	virtual/gnustep-back"
#RDEPEND="${GS_RDEPEND}"
RDEPEND="${DEPEND}"

egnustep_install_domain="System"

src_unpack() {
	echo "nothing to unpack"
}

src_compile() {
	echo "nothing to compile"
}

src_install() {
	egnustep_env
	exeinto /etc/init.d
	newexe ${FILESDIR}/gnustep.runscript-${PV} gnustep
	#dosed "s:XXX_GENTOO_GNUSTEP_ROOT_XXX:$(egnstep_prefix):g" /etc/init.d/gnustep
	newenvd ${FILESDIR}/gnustep.env-${PV} 99gnustep
	dosed "s:XXX_GNUSTEP_USER_ROOT_XXX:~$(egnustep_user_root_suffix):g" /etc/env.d/99gnustep
	dosed "s:XXX_GNUSTEP_LOCAL_ROOT_XXX:$(egnustep_local_root):g" /etc/env.d/99gnustep
	dosed "s:XXX_GNUSTEP_NETWORK_ROOT_XXX:$(egnustep_network_root):g" /etc/env.d/99gnustep
	dosed "s:XXX_GNUSTEP_SYSTEM_ROOT_XXX:$(egnustep_system_root):g" /etc/env.d/99gnustep
	dodir /var/run/GNUstep
	elog "Check http://dev.gentoo.org/~grobian/fafhrd/ for very handy info in setting up your GNUstep env."
}

