# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gnustep-base/gnustep-base-1.6.0.ebuild,v 1.4 2004/05/04 16:05:32 kloeri Exp $

DESCRIPTION="GNUstep base package"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/core/${P}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 -ppc ~sparc"
IUSE=""
DEPEND=">=dev-util/gnustep-make-1.6.0*
	>=dev-libs/libxml2-2.4.23"

src_compile() {

	. /usr/GNUstep/System/Makefiles/GNUstep.sh
	# This is a workaround for a hardcoded GNUSTEP_USER_ROOT
	GNUSTEP_USER_ROOT=~/.GNUstep

	econf \
		--with-xml-prefix=/usr \
		--with-gmp-include=/usr/include \
		--with-gmp-library=/usr/lib || die "./configure failed"

	make || die
}

src_install() {

	. /usr/GNUstep/System/Makefiles/GNUstep.sh
	# This is a workaround for a hardcoded GNUSTEP_USER_ROOT
	GNUSTEP_USER_ROOT=~/.GNUstep

	make install \
		GNUSTEP_INSTALLATION_DIR=${D}/usr/GNUstep/System \
		INSTALL_ROOT_DIR=${D} \
		|| die "install failed"

	exeinto /etc/init.d ; newexe ${FILESDIR}/gnustep gnustep

}

pkg_postinst() {
	einfo "You should set the local timezone and language with the defaults command now."
	einfo
	einfo "i.e. \"defaults write NSGlobalDomain \"Local Time Zone\" America/Chicago\""
	einfo "     \"defaults write NSGlobalDomain NSLanguages \"English\"\""
	einfo
	einfo "Time zones can be found in"
	einfo "  /usr/GNUstep/System/Libraries/Resources/NSTimeZones/zones/"
	einfo
	einfo "Make sure that you type"
	einfo "  \". /usr/GNUstep/System/Makefiles/GNUstep.sh\" first to set the right PATH"
	einfo
	einfo "For GNUstep to work properly \"gnustep\" should be added to your default"
	einfo "  runlevel.  This can be done by typing \"rc-update add gnustep default\"."
}
